---
author: ety001
date: 2017-04-05 10:09:00
layout: post
title: Symfony部署命令
tags: 后端
---

1. composer 更新代码
```bash
php composer.phar install --no-dev --optimize-autoloader
```

2. Symfony 清空cache
```shell
php bin/console cache:clear --env=prod --no-debug
```

3. 生成 Assets
```shell
php bin/console assetic:dump --env=prod --no-debug
```

#### 其他的总结

```shell
rm -rf bin/cache/* #手动清空缓存
php bin/console route:debug  # 查看哪些路由已经注册
```
