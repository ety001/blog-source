---
author: ety001
layout: post
title: 利用docker搭建eth智能合约开发环境
tags:
- eth
---

最近有个项目需要使用 eth 的智能合约，虽然我不看好eth，但是为了挣钱也不得不花些时间去学习下了。之所以选择 Docker 是因为我不喜欢删除的时候删不干净，毕竟不熟悉工具会安装哪些东西。使用 Docker 的话，基本上都被封装在容器里，不用了删掉容器和映射出来的目录数据就ok了。

去 eth 的 github 看了下，是有提供 Docker 镜像的，那么我们直接拉取官方做好的镜像包就好了

```
docker pull ethereum/client-go
```

由于我们是本地开发测试，所以我们启动测试节点

```
docker run -it --rm -v $(pwd)/eth:/root/.ethereum ethereum/client-go console --dev
```

其中 `$(pwd)/eth` 是用来存储区块数据的宿主机目录，设置成为自己的一个目录就好。
执行后，就会看到类似下面的样子

![](/img/2018/11/I3uvvSuwMnDrAKTO926pL4v9igiALK2utr573LtJ.png)

最后会出现一个 `>` 的控制符，这时候就可以输入命令了，比如查看下目前的账户

```
> eth.accounts
["0xeeffae8858bee06d1b4f57d7a2fbf3544a593f12"]
```

获取指定用户的 balance

```
> eth.getBalance(eth.accounts[0])
1.15792089237316195423570985008687907853269984665640564039457584007913129639927e+77
```

创建个密码是“ety001"的新用户来专门测试开发

```
> personal.newAccount('ety001')
"0x6ed051356a14c1354a95f3352856f05d622b1658"
```

转账给新账户，用于测试

```
> eth.sendTransaction({from: '0xb0ebe17ef0e96b5c525709c0a1ede347c66bd391', to: '0xf280facfd60d61f6fd3f88c9dee4fb90d0e11dfc', value: web3.toWei(1, "ether")})
```

从网上找一段合约代码试试创建合约，把下面的代码复制到 [Remix](http://remix.ethereum.org) 里，编译器选择 `0.4.18` 编译，之后点击“detail”

```
pragma solidity ^0.4.18;
contract hello {
    string greeting;
    
    function hello(string _greeting) public {
        greeting = _greeting;
    }

    function say() constant public returns (string) {
        return greeting;
    }
}
```

![](/img/2018/11/Ic2xRAWOqFBjvdjOiTLXL8fL960X8Oh7bCS7sN9r.png)

点击“detail”打开一个浮层，里面找到 `WEB3DEPLOY` 的代码，复制出来，修改一下第一行，比如

```
var _greeting = 'hi, ety001'
```

修改完后解锁钱包，把代码复制进 `console` 里，回车，即可创建新的合约了

```
> personal.unlockAccount(eth.accounts[1],"ety001");
```

![](/img/2018/11/uaxS8DXBqqQRLMt1ryH5RRdToEtXgK9waQ8ykaGN.png)

在 `console` 里输入 `hello.say()` 回车后，就能看到输出了 `hi, ety001` 了，这样一个智能合约的开发环境就搭建好了。

完工！