---
author: ety001
title: 折腾了三天终于搞定公司的VPN融合到我家里的网络的工作了
date: 2026-06-29 20:00:00
layout: post
tags:
- 经验
- 服务器
- Linux
- Cloudflare
---

最近公司开发人员的 VPN 从 Easyconnect 迁移到 Cloudflare WARP 了，真的是令人振奋人心，比起 Easyconnect 来说， WARP 对于 Linux 环境友好太多太多了！

由于流量走公司 VPN 的时候，会有审计行为，因此作为在家工作的我，都是用 [Mihomo](https://wiki.metacubex.one/en/config/general/) 把涉及公司资源的访问单独路由到一个虚拟机，虚拟机里登陆公司 VPN。

为了节省资源，我的虚拟机安装的是不带桌面的 Archlinux，因为 WARP 提供 CLI 方式登陆。另外安装 [Mihomo](https://wiki.metacubex.one/en/config/general/) 作为 http 代理。

VPN 登陆后，路由表会发生变化，还需要安装 [FRP](https://gofrp.org/en/) 把 http 代理映射到路由器上。

最后就是在本地的 [Mihomo](https://wiki.metacubex.one/en/config/general/) 做好各种转发规则。

用了半天，发现处于 VPN 内的公司 JumpServer 服务经常出现 AccessDenied 的情况。一开始以为是自己触发了什么规则，后来在 Windows 下面测试，才知道是会话过期的原因。

这就有些蛋疼了。不能每次会话过期就要登陆虚拟机，重新登陆 vpn 吧。

经过研究，打算用 [webhook](https://github.com/adnanh/webhook) 在虚拟机里做个轻量钩子，本地登陆后把 token 通过钩子传给虚拟机的指定脚本，完成自动重登录。

借助 Deepseek ，很快就把几个脚本完成了。下面就是各个脚本：

### /etc/webhook/hooks.yaml

```
- id: re-reg
  execute-command: /data/warp/webhook.sh
  command-working-directory: /home/ety001
  incoming-payload-content-type: application/json
  response-headers:
  - name: Access-Control-Allow-Origin
    value: "*"
  - name: Access-Control-Allow-Methods
    value: "GET, POST, OPTIONS"
  - name: Access-Control-Allow-Headers
    value: "Content-Type"
  response-message: ok
  http-methods:
    - "POST"
    - "OPTIONS"
  pass-arguments-to-command:
  - source: payload
    name: token
```

执行 `sudo systemctl enable --now webhook` 即可启动钩子。

### /data/warp/webhook.sh

```
#!/bin/bash

warp-cli disconnect
warp-cli registration delete

if [ -z "$1" ]; then
    exit 1
fi

#token=$(echo "$1" | awk -F"'" '{print $2}')
token=$1

warp-cli --accept-tos registration token "${token}"

sudo warp-cli dns endpoint set x.x.x.x
sudo warp-cli api endpoint set x.x.x.x
sudo warp-cli tunnel endpoint set x.x.x.x:2408

warp-cli connect
```

### 本地使用下面的命令创建 xdg-open 处理程序
```
mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/warp-handler.desktop <<EOF
[Desktop Entry]
Type=Application
Name=WARP Handler
Exec=/data/app/handler.sh %u
MimeType=x-scheme-handler/com.cloudflare.warp;
NoDisplay=true
EOF

update-desktop-database ~/.local/share/applications
```

### handler.sh
```
#!/bin/bash

# 提取完整 URL
full_url="$1"

# 提取 token 部分（去掉协议头）
#token="${full_url#com.cloudflare.warp://}"
token=${full_url}

# 构造 JSON 数据
json_data="{\"token\": \"$token\"}"

echo $json_data
# 发送 POST 请求
curl -X POST \
     -H "Content-Type: application/json" \
     -d "$json_data" \
     http://192.168.x.1:9000/hooks/re-reg
```

### 测试一下

当出现 JumpServer 无法访问的情况，那么直接在本地浏览器访问一下公司的 WARP 地址，完成登陆后，如下图：

![image.png](https://cdn.steemitimages.com/DQmfHroTFZ4Geo2aVzZCWicpA9BGU7Zoz83SDy8qSFnRQaB/image.png)

点击弹出的对话框的打开 xdg-open，就可以把 token 传到虚拟机完成 warp 的重新登陆。

网络折腾好以后，终于可以继续安心工作了！本来就紧凑的工作节奏，耽误两天就积压了一大堆。。。。
