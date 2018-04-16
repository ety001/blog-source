---
author: ety001
date: 2017-04-09 10:09:00
layout: post
title: 5分钟用EasyAdminBundle创建简易博客后台
tags: 后端
---
最近需要做一个快速上线的项目，要求使用 `Symfony` 框架。

久闻 *Symfony* 的 *Bundle* 很丰富，于是搜索了下现成的后台系统。
首先发现的是 *Sonata Admin Panel*，是个老牌的系统了，可惜经过研究发现，
它对于 *Symfony3* 下的新版本的 *FOS Bundle(一个用户系统)* 不支持。于是又找了一个，
名字是 [EasyAdminBundle](https://github.com/javiereguiluz/EasyAdminBundle)。

这篇博客会用最短最快的方式，让你建立一个简易的博客后台，其中的各个步骤则不解释。

体验环境：MacOS X 或 Linux (注意 *php* 的 *pdo_mysql.so* 请打开)

* 安装 Symfony
```bash
$ sudo mkdir -p /usr/local/bin
$ sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
$ sudo chmod a+x /usr/local/bin/symfony
```

* 创建 Symfony 项目 并启动服务
```shell
$ symfony new blog
$ cd blog
$ php bin/console server:start
```

访问下 http://127.0.0.1:8000 看是否正常启动。

* 如需停止服务，执行下面的命令
```shell
$ php bin/console server:stop
```

* 下载安装 EasyAdmin
```bash
$ composer require javiereguiluz/easyadmin-bundle
```

* 激活插件
```php
<?php
// app/AppKernel.php
// ...
class AppKernel extends Kernel
{
    public function registerBundles()
    {
        $bundles = array(
            // ...
            new JavierEguiluz\Bundle\EasyAdminBundle\EasyAdminBundle(),
        );
    }
    // ...
}
```

* 载入路由
```
# app/config/routing.yml
easy_admin_bundle:
    resource: "@EasyAdminBundle/Controller/"
    type:     annotation
    prefix:   /admin
```

* 载入静态资源
```
# Symfony 3
php bin/console assets:install --symlink
```

* 在 *app/config/parameters.yml* 中配置数据库连接

* 创建 *Entity*
```bash
$ php bin/console doctrine:generate:entity --entity="AppBundle:Category" --fields="name:string(255) enabled:boolean" --no-interaction
$ php bin/console doctrine:generate:entity --entity="AppBundle:Posts" --fields="title:string(255) contents:text() enabled:boolean" --no-interaction
```

* 在 *src/AppBundle/Entity/PostsEntity.php* 中增加关联关系
```php
<?php
// ...
class Posts
{
    // ...
    /**
     * @ORM\ManyToOne(targetEntity="Category", inversedBy="posts")
     * @ORM\JoinColumn(name="category_id", referencedColumnName="id")
     */
    private $category;
}
```

* 在 *src/AppBundle/Entity/Category.php* 中增加对应的关联关系(新增代码如下)
```php
// src/AppBundle/Entity/Category.php

// ...
use Doctrine\Common\Collections\ArrayCollection;

class Category
{
    // ...

    /**
     * @ORM\OneToMany(targetEntity="Posts", mappedBy="category")
     */
    private $posts;

    public function __construct()
    {
        $this->posts = new ArrayCollection();
    }
}
```

* 执行以下命令，完善对应属性的方法
```bash
$ composer update
$ php bin/console doctrine:generate:entities AppBundle --no-backup
```

* 执行以下命令，生成数据表
```php
$ php bin/console doctrine:schema:update --force
```

* 配置后台
```
# app/config/config.yml
easy_admin:
    entities:
        Category:
            class: AppBundle\Entity\Category
            form:
                fields:
                    - name
        Posts:
            class: AppBundle\Entity\Posts
            form:
                fields:
                    - title
                    - { property: 'category', type: 'easyadmin_autocomplete' }
                    - contents
```

* 配置语言
```
# app/config/config.yml
framework:
    translator: { fallbacks: ['%locale%'] }
```

这时，访问 [http://127.0.0.1:8000/admin](http://127.0.0.1:8000/admin)，就能看到我们的后台了。

下面是集成 FOS Bundle 的操作。

1. 安装 FOS
```bash
$ composer require friendsofsymfony/user-bundle "~2.0"
```

2. 启用 FOS
```php
<?php
// app/AppKernel.php

public function registerBundles()
{
    $bundles = array(
        // ...
        new FOS\UserBundle\FOSUserBundle(),
        // ...
    );
}
```

3. 创建 User Class
```php
<?php
// src/AppBundle/Entity/User.php

namespace AppBundle\Entity;

use FOS\UserBundle\Model\User as BaseUser;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="fos_user")
 */
class User extends BaseUser
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer")
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    protected $id;

    public function __construct()
    {
        parent::__construct();
        // your own logic
    }
}
```

4. 增加防火墙配置(全部替换原有内容)
```
# app/config/security.yml
security:
    encoders:
        FOS\UserBundle\Model\UserInterface: bcrypt

    role_hierarchy:
        ROLE_ADMIN:       ROLE_USER
        ROLE_SUPER_ADMIN: ROLE_ADMIN

    providers:
        fos_userbundle:
            id: fos_user.user_provider.username

    firewalls:
        main:
            pattern: ^/
            form_login:
                provider: fos_userbundle
                csrf_token_generator: security.csrf.token_manager
                # if you are using Symfony < 2.8, use the following config instead:
                # csrf_provider: form.csrf_provider

            logout:       true
            anonymous:    true

    access_control:
        - { path: ^/login$, role: IS_AUTHENTICATED_ANONYMOUSLY }
        - { path: ^/register, role: IS_AUTHENTICATED_ANONYMOUSLY }
        - { path: ^/resetting, role: IS_AUTHENTICATED_ANONYMOUSLY }
        - { path: ^/admin/, role: ROLE_ADMIN }
```

5. 配置 FOS
```
# app/config/config.yml
fos_user:
    db_driver: orm # other valid values are 'mongodb' and 'couchdb'
    firewall_name: main
    user_class: AppBundle\Entity\User
    from_email:
        address: "%mailer_user%"
        sender_name: "%mailer_user%"
```

6. 在 *app/config/parameters.yml* 中配置第5步中的 *mailer_user* 参数

7. 导入 FOS 的路由配置
```
# app/config/routing.yml
fos_user:
    resource: "@FOSUserBundle/Resources/config/routing/all.xml"
```

8. 更新数据库
```bash
$ php bin/console doctrine:schema:update --force
```

9. 创建新的控制器
```php
// src/AppBundle/Controller/AdminController.php
namespace AppBundle\Controller;

use JavierEguiluz\Bundle\EasyAdminBundle\Controller\AdminController as BaseAdminController;

class AdminController extends BaseAdminController
{
    public function createNewUserEntity()
    {
        return $this->get('fos_user.user_manager')->createUser();
    }

    public function prePersistUserEntity($user)
    {
        $this->get('fos_user.user_manager')->updateUser($user, false);
    }

    public function preUpdateUserEntity($user)
    {
        $this->get('fos_user.user_manager')->updateUser($user, false);
    }
}
```

10. 在 config.yml 中增加 User 的配置
```
easy_admin:
    entities:
        User:
            class: AppBundle\Entity\User
            form:
                fields:
                    - username
                    - email
                    - enabled
                    - lastLogin
                    # if administrators are allowed to edit users' passwords and roles, add this:
                    - { property: 'plainPassword', type: 'text', type_options: { required: false } }
                    - { property: 'roles', type: 'choice', type_options: { multiple: true, choices: { 'ROLE_USER': 'ROLE_USER', 'ROLE_ADMIN': 'ROLE_ADMIN' } } }
```

此时你再访问的时候，就会弹出来一个很丑的登陆界面（因为FOS默认不带皮肤）。
使用下面的命令创建一个管理员账号

```bash
$ php bin/console fos:user:create admin --super-admin
```

按照提示，即可完成管理员创建的工作。回到网页上，登陆即可。

至此，一个简单的后台就搭建完毕了。

接下来还有很多的工作可以做，这个以后再来完善补充。
