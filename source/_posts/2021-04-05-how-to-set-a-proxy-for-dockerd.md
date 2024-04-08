---
author: ety001
layout: post
title: How to set a proxy for dockerd?
tags:
  - 服务器
  - 经验
  - 配置
  - Docker
  - proxy
---

![image.png](https://cdn.steemitimages.com/DQmZmk5YpB38FTThN8M9z64pb54H3LjZLFEGYGMij9BuMYL/image.png)

In some cases, we need to pull some docker image through our custom proxy server.

But the `HTTPS_PROXY` and `HTTP_PROXY` in current login terminal will not be useful for the `docker pull` command.
The `proxychains-ng` tool is the same situation.

This is because docker is divided into `dockerd` and `client`. The `docker pull` command is executed by `dockerd` service. So we need make sure `dockerd` use proxy server.

The Docker daemon uses the `HTTP_PROXY`, `HTTPS_PROXY`, and `NO_PROXY` environmental variables in its start-up environment to configure HTTP or HTTPS proxy behavior. You cannot configure these environment variables using the `daemon.json` file.

So we can edit the systemd service file.

**1.First create a new folder**

```
$ sudo mkdir -p /etc/systemd/system/docker.service.d
```

**2.Then create a new file named `/etc/systemd/system/docker.service.d/http-proxy.conf`**

```
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80"
Environment="HTTPS_PROXY=http://proxy.example.com:80"
```

**3.Reload and restart**

```
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```

**4.Verify that the configuration has been loaded and matches the changes you made, for example:**

```
$  sudo systemctl show --property=Environment docker
```

