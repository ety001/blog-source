---
author: ety001
comments: true
date: 2014-04-12 06:25:56+00:00
layout: post
slug: chunked_http_c
title: 关于以chunked方式传输的HTTP响应报文的解码C语言实现
wordpress_id: 2600
tags:
- 编程语言
- 理论
---

#### 注意：

该文转载出处已不可访问，找到一篇相似的文章，可以参考：
[https://blog.csdn.net/liuchonge/article/details/50061331](https://blog.csdn.net/liuchonge/article/details/50061331)

-- 2019-11-28 更新

---

转自：[http://www.devdiv.com/chunked_http_c_-article-2473-1.html](http://www.devdiv.com/chunked_http_c_-article-2473-1.html)

今天的主要内容还是不会偏离帖子的标题，关于HTTP采用chunked方式传输数据的解码问题。相信“在座”的各位有不少是搞过web系统的哈，但考虑到其他没接触过的XDJMs，这里还是简要的介绍一下：

chunked编码的基本方法是将大块数据分解成多块小数据，每块都可以自指定长度，其具体格式RFC文档中是这样描述的(http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html)：

```
       Chunked-Body   = *chunk
                        last-chunk
                        trailer
                        CRLF
       chunk          = chunk-size [ chunk-extension ] CRLF
                        chunk-data CRLF
       chunk-size     = 1*HEX
       last-chunk     = 1*("0") [ chunk-extension ] CRLF
       chunk-extension= *( ";" chunk-ext-name [ "=" chunk-ext-val ] )
       chunk-ext-name = token
       chunk-ext-val  = token | quoted-string
       chunk-data     = chunk-size(OCTET)
       trailer        = *(entity-header CRLF)
```

这个据说是BNF文法，我本人有点陌生，于是又去维基百科里面找了下，里面有报文举例，这样就一目了然了(http://en.wikipedia.org/wiki/Chunked_transfer_encoding)，我摘一段报文如下：

```
HTTP/1.1 200 OK
Content-Type: text/plain
Transfer-Encoding: chunked

25
This is the data in the first chunk

1C
and this is the second one

3
con
8
sequence
0
```

总而言之呢，就是说，这种方式的HTTP响应，头字段中不会带上我们常见的Content-Length字段，而是带上了Transfer-Encoding: chunked的字样。这种响应是未知长度的，有很多段自定义长度的块组合而成，每个块以一个十六进制数开头，该数字表示这块chunk数据的长度(包括数据段末尾的CRLF，但不包括十六进制数后面的CRLF)。

于是，众多Coders在发现了这个真相以后就开始在互联网上共享各种语言的解码代码。我看了C、PHP和Python那几个版本的代码，发现了一个问题就是，他们解析的数据是完整的，也就是说，他们所操纵的数据是假定已经在解码前在外部完成了拼装的，但是这完全不符合我的使用场景，Why？因为我的数据都是直接从Socket里面拿出来的，Socket里面的数据绝对不会有如此漂亮的格式，它们在那个时候都是散装的，当然我也可以选择将他们组装好然后再去解，但是以我粗浅的认识认为，那样子无论是从时间还是从空间的效率上来讲都是极为低下的(当你开发了一个kext程序，就明白我的苦衷了)。于是我又继续搜索，以期待能有高手已经提前帮我解决了这些问题，不过很遗憾，我没能找到。

没办法，自己做吧，比较重要的地方无非就是一个结尾的判断、一个chunk长度的读取、chunk之间的分段问题。看起来貌似比较轻松，不过代码写起来还是花费了不少时间的，今天又单独从项目中提取了这部分功能用C重写了一下。接下来就结合部分代码来说明一下整个过程。

1. 先看dechunk.h这个文件

```
#define DCE_OK              0
#define DCE_ISRUNNING       1
#define DCE_FORMAT          2
#define DCE_ARGUMENT        3
#define DCE_MEM             4
#define DCE_LOCK            5

int dechunk_init();
int dechunk(void *input, size_t inlen);
int dechunk_getbuff(void **buff, size_t *buf_size);
int dechunk_free();

void *memstr(void *src, size_t src_len, char *sub);
```

宏定义就不用说了，都是一些错误码定义。函数一共有5个。dechunk_init、dechunk、dechunk_free这三个是解码的主要流程，dechunk_getbuff则是获取数据的接口。接下来看memstr，这是个很奇怪的名字，也是代码中唯一值得重点提醒一下的地方，其主要功能是在一块内存中寻找能匹配sub表示的字符串的地址。有人肯定要问了，不是有strstr么？对，我也这样想过，并且对于一些chunked网站也是实用的，但是，它不是通用的。主要是因为还有一些网站不仅使用了chunked传输方式，还采用了gzip的内容编码方式。当你碰到这种网站的时候，你再想使用strstr就等着郁闷吧，因为strstr会以字符串中的'\0'字符作为结尾标识，而恰巧经过gzip编码后的数据会有大量的这种字符。

2. 接下来看dechunk.c
```
int dechunk(void *input, size_t inlen)
{
    if (!g_is_running)
    {
        return DCE_LOCK;
    }

    if (NULL == input || inlen <= 0)
    {
        return DCE_ARGUMENT;
    }

    void *data_start = input;
    size_t data_len = inlen;

    if (g_is_first)
    {
        data_start = memstr(data_start, data_len, "\r\n\r\n");
        if (NULL == data_start)
        {
            return DCE_FORMAT;
        }

        data_start += 4;
        data_len -= (data_start - input);

        g_is_first = 0;
    }

    if (!g_is_chunkbegin)
    {
        char *stmp = data_start;
        int itmp = 0;

        sscanf(stmp, "%x", &itmp;);
        itmp = (itmp > 0 ? itmp - 2 : itmp);          // exclude the terminate "\r\n"

        data_start = memstr(stmp, data_len, "\r\n");
        data_start += 2;    // strlen("\r\n")

        data_len        -=  (data_start - (void *)stmp);
        g_chunk_len     =   itmp;
        g_buff_outlen   +=  g_chunk_len;
        g_is_chunkbegin =   1;
        g_chunk_read    =   0;

        if (g_chunk_len > 0 && 0 != g_buff_outlen)
        {
            if (NULL == g_buff_out)
            {
                g_buff_out = (char *)malloc(g_buff_outlen);
                g_buff_pt = g_buff_out;
            }
            else
            {
                g_buff_out = realloc(g_buff_out, g_buff_outlen);
            }

            if (NULL == g_buff_out)
            {
                return DCE_MEM;
            }
        }
    }

#define CHUNK_INIT() \
do \
{ \
g_is_chunkbegin = 0; \
g_chunk_len = 0; \
g_chunk_read = 0; \
} while (0)

    if (g_chunk_read < g_chunk_len)
    {
        size_t cpsize = DC_MIN(g_chunk_len - g_chunk_read, data_len);
        memcpy(g_buff_pt, data_start, cpsize);

        g_buff_pt       += cpsize;
        g_chunk_read    += cpsize;
        data_len        -= (cpsize + 2);
        data_start      += (cpsize + 2);

        if (g_chunk_read >= g_chunk_len)
        {
            CHUNK_INIT();

            if (data_len > 0)
            {
                return dechunk(data_start, data_len);
            }
        }
    }
    else
    {
        CHUNK_INIT();
    }

#undef CHUNK_INIT()

    return DCE_OK;
}
```


其他函数没什么好说的，主要就只是把dechunk这个函数的流程讲一下(本来要是写了注释，我就不啰嗦这么多了，没办法，我们还是要对自己写的代码负责的不是)。

首先判断是否初始化过，全局变量g_is_running的唯一用途就只是用来防止多线程的调用，这只是一种很低级的保护，大家可以在实际使用中仁者见仁，智者见智。接下来，判断是否是http响应的第一个包，因为第一个包中包含有http的相应头，我们必须把这部分内容给过滤掉，判断的依据就是寻找两个连续的CRLF，也就是"\r\n\r\n"。
响应body的第一行，毫无疑问是第一个chunk的size字段，读取出来，设置状态，设置计数器，分配内存(如果不是第一个chunk的时候，通过realloc方法动态改变我们所分配的内存)。紧接着，就是一个对数据完整性的判断，如果input中的剩余数据的大小比我们还未读取到缓冲区中的chunk的size要小，这很明显说明了这个chunk分成了好几次被收到，那么我们直接按顺序拷贝到我们的chunk缓冲区中即可。反之，如果input中的剩余数据比未读取的size大，则说明了当前这个input数据包含了不止一个chunk，此时，使用了一个递归来保证把数据读取完。这里值得注意的一点是读取数据的时候要把表示数据结束的CRLF字符忽略掉。
总的流程基本就是这个样子，外部调用者通过循环把socket获取到的数据丢进来dechunk，外部循环结束条件就是socket接受完数据或者判断到表示chunk结束的0数据chunk。

3. 最后看一下main.c

```
int main (int argc, const char * argv[])
{
    const char              *server_ipstr   = "59.151.32.20";   // the host address of "www.mtime.com"
                                                                // you can also use function gethostbyname
                                                                // to get the address
    const unsigned short    server_port     = 80;               // default port of http protocol

    int sock_http_get = -1;

    do
    {
        sock_http_get = socket(PF_INET, SOCK_STREAM, 0);

        if (-1 == sock_http_get)
        {
            printf("socket() error %d.\n", errno);
            break;
        }

        struct sockaddr_in addr_server;
        bzero(&addr;_server, sizeof(addr_server));

        addr_server.sin_family          = AF_INET;
        addr_server.sin_addr.s_addr     = inet_addr(server_ipstr);
        addr_server.sin_port            = htons(server_port);

        if (-1 == connect(sock_http_get, (struct sockaddr *)&addr;_server, sizeof(addr_server)))
        {
            printf("connect() error %d.\n", errno);
            break;
        }

        printf("connected...\n");

        char *request =
        "GET / HTTP/1.1\r\n"
        "Host: www.mtime.com\r\n"
        "Connection: keep-alive\r\n"
        "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.220 Safari/535.1\r\n"
        "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n"
        "Accept-Encoding: gzip,deflate,sdch\r\n"
        "Accept-Language: zh-CN,zh;q=0.8\r\n"
        "Accept-Charset: GBK,utf-8;q=0.7,*;q=0.3\r\n"
        "Cookie: DefaultCity-CookieKey=561; DefaultDistrict-CookieKey=0; _userCode_=2011725182104293; _userIdentity_=2011725182109188; _movies_=105799.87871.91873.68867; __utma=196937584.1484842614.1299113024.1314613017.1315205344.4; __utmz=196937584.1299113024.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _urm=0%7C0%7C0%7C0%7C0; _urmt=Mon%2C%2005%20Sep%202011%2006%3A49%3A04%20GMT\r\n"
        "\r\n";

        if (-1 == send(sock_http_get, request, strlen(request), 0))
        {
            printf("send() error %d.\n", errno);
            break;
        }

#define MY_BUF_SIZE     1024
        char buff[MY_BUF_SIZE] = {0};
        int recv_bytes = 0;
        int chunkret = DCE_OK;

        if (DCE_OK == dechunk_init())
        {
            while (-1 != (recv_bytes = recv(sock_http_get, buff, MY_BUF_SIZE, 0))
                   && 0 != recv_bytes)
            {
                printf("%s", buff);
                if (DCE_OK != (chunkret = dechunk(buff, recv_bytes)))
                {
                    printf("\nchunkret = %d\n", chunkret);
                    break;
                }

                if (NULL != memstr(buff, recv_bytes, "\r\n0\r\n"))
                {
                    break;
                }

                bzero(buff, MY_BUF_SIZE);
            }

            printf("\n*********************************\n");
            printf("receive finished.\n");
            printf("*********************************\n");

            void *zipbuf = NULL;
            size_t zipsize = 0;
            dechunk_getbuff(&zipbuf;, &zipsize;);

            printf("\n%s\n", (char *)zipbuf);

            z_stream strm;
            bzero(&strm;, sizeof(strm));

            printf("BEGIN:decompress...\n");
            printf("*********************************\n");

            if (Z_OK == inflateInit2(&strm;, 31))    // 31:decompress gzip
            {
                strm.next_in    = zipbuf;
                strm.avail_in   = zipsize;

                char zbuff[MY_BUF_SIZE] = {0};

                do
                {
                    bzero(zbuff, MY_BUF_SIZE);
                    strm.next_out = (Bytef *)zbuff;
                    strm.avail_out = MY_BUF_SIZE;

                    int zlibret = inflate(&strm;, Z_NO_FLUSH);

                    if (zlibret != Z_OK && zlibret != Z_STREAM_END)
                    {
                        printf("\ninflate ret = %d\n", zlibret);
                        break;
                    }

                    printf("%s", zbuff);

                } while (strm.avail_out == 0);
            }

            printf("\n");
            printf("*********************************\n");

            dechunk_free();
        }
#undef MY_BUF_SIZE

    } while (0);

    close(sock_http_get);

    return 0;
}
```


按照惯例，main函数是我们用来测试的函数。


这个函数中，我们首先使用socket创建了跟服务器之间的连接，紧接着我手动构造了一个请求报文，通过socket发送出去，然后循环获取数据。然后通过使用zlib库来对dechunk出来的数据进行解码以确定数据是否正确。关于zlib的使用跟本次讨论的话题不太沾边，这里就不详述，有兴趣的我们可以另行讨论。

解码前和解码后的数据都会被打印到控制台中去，日志比较庞大，这里就不给出具体信息了，大家可以自行调试观察。
关于这个文件我说明一下，网站选的是www.mtime.com，因为它采用的就是chunked + gzip的方式，是一种相对难处理的数据。该网站的IP地址信息，相信各位有不下于100种方法去找到，所以我就没有使用gethostbyname那个方法了，因为那个方法返回的结构体使用起来实在不怎么方便。另外就是关于手动拼装的请求报文哪里来，千万不要告诉我你去用各种专业抓包工具去抓。没那么麻烦，打开你的Chrome，右键选择审查元素，然后访问你要访问的网站，OK，所有请求都会被记录在案。

/*******************************分割一下吧*****************************/

关于代码就说这么多，不过我还是声明一下，因为没多少时间，所以我只能尽力把代码写的不那么难看，注释不多，但我在这里也有所弥补，各个函数功能的实现也许有效率方面的问题抑或是各种bug，这个属于我的编程能力不足，大家可以提出宝贵的修改意见，我一定虚心接受。如果有不明白的地方(我这只是以防万一哈^_^)也可以跟帖一起讨论。根据设计的原则，每个函数的功能应该尽量的单一和完整，调用者应该确保传递的数据符合函数的要求，但是我的main函数中却没有一些必要的判断(比如http响应是否是chunked的，是否是gzip的)，因为我准备的测试数据已经确定好了的。

写了那么多，也该结尾了，不过还是要送上源码工程以祝大家天天晚上睡好觉！
源码在这里 --->
Vincent，如果您要查看本帖隐藏内容请回复


doors.du说：“我觉得明天起床这个帖子会火的，不管你们信不信，我反正信了......”




  http_chunk_demo.zip (19.35 KB, 下载次数: 2742)
