---
author: ety001
layout: post
title: 终于是搞定了 Laravel 和 iview-admin 的融合
tags:
- Laravel
- iview-admin
---
最近需要开发一套后台，挑来挑去，觉得 **[iview-admin](https://github.com/iview/iview-admin)** 不错，决定要使用这个后台前端框架。上面就是最终的效果图。

但是由于我们的后台是 **Laravel** 框架用的 **Laravel Mix**， 与 **iview-admin** 用的 **vue-cli-service** 不一样，于是整合起来有些麻烦，虽然最简单的方法是开两个库独立开来，但是这会让部署什么的增加一些环节，毕竟这个项目开发就我自己，没必要折腾那么多，于是就想要整合。

从周二开始折腾，折腾来折腾去，将近一周过去了，终于搞定了（虽然解决了最后一个问题，但是原理是啥我也不知道），现在已经可以使用 **Laravel Mix** 来直接替代 **vue-cli-service** 编译啦。

为了方便自己以后再次使用，所以记录下关键的几个环节。

首先需要的就是调整下 **package.json**，我的代码最终版如下：

```
{
    "private": true,
    "scripts": {
        "dev": "npm run development",
        "development": "cross-env NODE_ENV=development node_modules/webpack/bin/webpack.js --progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js",
        "watch": "npm run development -- --watch",
        "watch-poll": "npm run watch -- --watch-poll",
        "hot": "cross-env NODE_ENV=development node_modules/webpack-dev-server/bin/webpack-dev-server.js --inline --hot --config=node_modules/laravel-mix/setup/webpack.config.js",
        "prod": "npm run production",
        "production": "cross-env NODE_ENV=production node_modules/webpack/bin/webpack.js --no-progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js"
    },
    "devDependencies": {
        "@vue/babel-preset-app": "^3.5.0",
        "axios": "^0.18",
        "bootstrap": "^4.0.0",
        "chai": "^4.1.2",
        "clipboard": "^2.0.0",
        "codemirror": "^5.38.0",
        "countup": "^1.8.2",
        "cropperjs": "^1.2.2",
        "cross-env": "^5.1",
        "dayjs": "^1.7.7",
        "echarts": "^4.0.4",
        "html2canvas": "^1.0.0-alpha.12",
        "iview": "^3.3.0",
        "iview-area": "^1.5.17",
        "jquery": "^3.2",
        "js-cookie": "^2.2.0",
        "laravel-mix": "^4.0.14",
        "less": "^2.7.3",
        "less-loader": "^4.0.5",
        "lodash": "^4.17.5",
        "mockjs": "^1.0.1-beta3",
        "popper.js": "^1.12",
        "resolve-url-loader": "2.3.1",
        "sass": "^1.17.2",
        "sass-loader": "7.*",
        "simplemde": "^1.11.2",
        "sortablejs": "^1.7.0",
        "tree-table-vue": "^1.1.0",
        "v-org-tree": "^1.0.6",
        "vue": "^2.5.17",
        "vue-i18n": "^7.8.0",
        "vue-router": "^3.0.2",
        "vue-template-compiler": "^2.5.13",
        "vuedraggable": "^2.16.0",
        "vuex": "^3.0.1",
        "wangeditor": "^3.1.1",
        "xlsx": "^0.13.3"
    }
}
```

这里是在 **Laravel** 原有的 **package.json** 基础上，把 **iview-admin** 需要的 [依赖](https://github.com/iview/iview-admin/blob/master/package.json) 一一手动添加进去的。

其中命令中的 `node_modules/webpack/bin/webpack.js` 应该是调用的 `laravel-mix` 包中的依赖。

完成 **package.json** 之后，我们使用 `npm install` 安装一下所有的依赖，然后把 **iview-admin** 项目克隆到本地，把其中的 `src` 目录下的所有文件复制到 **Laravel** 项目的 `resources/js` 目录下。如果你想变更入口名称，可以把 `main.js` 改成你自己想要的名字，这里我改为了 `admin.js`。

之后修改一下 **Laravel** 项目根目录下的 **webpack.mix.js** 文件如下：

```
const mix = require('laravel-mix');

mix.js('resources/js/admin.js', 'public/static')
    .sass('resources/sass/admin.scss', 'public/static')
    .webpackConfig({
        resolve: {
            alias: {
                '@': path.resolve(__dirname, 'resources/js/'),
                '_c': path.resolve(__dirname, 'resources/js/components'),
            },
        },
        output: {
            chunkFilename: 'static/chunks/[name].js',
        },
    })
    .babelConfig({
        "presets": [
            "@vue/app",
        ],
    })
    .version();
```

在原有的基础上增加了 `resolve` 配置，为了能够正确解析 `@` 和 `_c` 开头的引入包路径。增加了 `output` 配置，让所有的 `chunk` 文件与主文件同目录（这条配置可不加）。增加了 `babelConfig` 配置，为了解决 **动态import** 语法解析的问题（这个就是目前还没有弄明白的那个地方）。

完成上面的步骤后，就完成了大半了。

之后，在 **Laravel** 项目中增加一个后台的路由，我是直接加在 `routers/web.php` 中的，如下

```
Route::get('admin', 'AdminController@index');
```

创建 `AdminController`，代码如下

```
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function index(Request $request) {
        return view('admin/index');
    }
}
```

创建视图 `resources/view/admin/index.blade.php`，代码如下

```
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BACC</title>
    <meta name="csrf-token" content="{{ csrf_token() }}" api_token="{{ \Auth::check() ? 'Bearer ' . \Auth::user()->api_token : 'Bearer '  }}">
    <link rel="stylesheet" href="{{ mix('static/admin.css') }}">
    <!-- <script src="{{ asset('/js/tinymce.min.js') }}"></script> -->
</head>
<body>
<div id="app"></div>

<script src="{{ mix('static/admin.js') }}"></script>
</body>
</html>
```

最后要修改的就是 **iview-admin** 的路由模式了。**iview-admin** 默认使用的是 `history`，而这个配置将会让 **iview-admin** 的路由与 **Laravel** 的路由冲突，因此需要去掉这个配置。这个配置项在 `resources/js/router/index.js` 中，把下面的代码中的 `mode: 'history'`去掉即可。

```
const router = new Router({
  routes,
  mode: 'history'
})
```

所有配置完成，执行 `npm run watch`，如果一切顺利的话，所有的前端文件会编译完成，直接访问 `http://localhost:8000/admin` 就能看到 **iview-admin** 已经成功整合完成了！

撒花！