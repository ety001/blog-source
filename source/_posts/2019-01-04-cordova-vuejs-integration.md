---
author: ety001
layout: post
title: 融合Cordova和Vuejs的开发环境
tags:
- 前端
- cordova
- Vuejs
---

最近开始在开发 `Cordova + Webpack + Vuejs` 架构的 `App`，开发 `Demo` 的时候，最麻烦的就是测试了。

由于我是先使用 `cordova` 的工具创建 `cordova` 项目，然后用 `vue-cli` 再在 `cordova` 中创建 `vuejs` 项目。
这样在开发的时候，需要先使用 `npm run dev` 调试 `vuejs` ，然后开发差不多了，需要调用 `cordova` 插件的时候，再执行 `cordova prepare browser` 和 `cordova run browser` 调试 `cordova` 插件，每次改完代码还要再执行 `npm run build && cordova prepare browser`。

这样就很烦啊！

为了在正式开发项目前解决这个问题，我研究了[萤火钱包](https://github.com/StellarCN/firefly)的实现和 `webpack` 的文档。

萤火钱包的实现方式是自己用 `Node` 写了一个 `Web` 服务，代码在这里：[https://github.com/StellarCN/firefly/blob/master/build/dev-server.js](https://github.com/StellarCN/firefly/blob/master/build/dev-server.js) 。

由于 `Webpack` 可以使用 `require` 的方式和 `webpack-dev-server` 两种方式对代码进行打包，萤火钱包就是在自己写的 `Server` 中，先引用 `webpack` 打包代码（24行--41行），然后用 `express` 给 `cordova` 的 `js bridge` 提供解析（66行--88行），最后在 `package.json` [https://github.com/StellarCN/firefly/blob/master/package.json#L18](https://github.com/StellarCN/firefly/blob/master/package.json#L18) 中加入一行代码，完成 `cordova prepare` 后再启动自己写的 `Node` 服务器。

按照萤火的思路尝试了大半天，一直都搞不定 `webpack` 的配置，一直给我报错，如下

```
WebpackOptionsValidationError: Invalid configuration object. Webpack has been initialised using a configuration object that does not match the API schema.
 - configuration misses the property 'entry'.
   object { <key>: non-empty string | [non-empty string] } | non-empty string | [non-empty string] | function
   -> The entry point(s) of the compilation.
```

最后只得再换个思路，用 `webpack-dev-server` 再试试。

由于 `vuejs` 默认就是用 `webpack-dev-server` 作为测试环境，所以需要改动的文件还是比较少，只需要修改 `build/webpack.dev.conf.js` 中的配置和 `package.json` 就好了。

在 `build/webpack.dev.conf.js` 中的 `devServer` 配置项里加上下面的代码：

```
    before(app){
      // serve Cordova javascript and plugins
      const cordovaPlatformPath = path.join(__dirname, '../platforms/browser/www')
      app.use('/plugins', express.static(path.join(cordovaPlatformPath, 'plugins')))
      app.get(
        [
          '/cordova.js',
          '/cordova_plugins.js',
        ],
        function (req, res) {
          try {
            res.sendFile(path.join(cordovaPlatformPath, req.path))
          } catch(err) {
            console.log(err)
          }
      })
      // serve Cordova config.xml
      app.get('/config.xml',
        function(req,res){
          try{
            res.sendFile(path.join(__dirname, '../'+req.path))
          } catch(err){
            consol.log(err)
          }
      })
    },
```

另外再在该文件头部加入 `express` 包的引用。

通过 `devServer.before` 加入 `cordova` 的 `js bridge`，这样就可以用 `webpack-dev-server` 来解析 `js bridge` 了。

最后在 `package.json` 中修改下原有的 `dev` 命令如下：

```
"dev": "cordova prepare browser && cross-env PORT=3000 webpack-dev-server --inline --progress --config build/webpack.dev.conf.js",
```

这样以后只需要执行 `npm run dev` 就可以了，只有当用 `cordova` 安装了新插件的时候，才需要重启下 `npm run dev`。

---

再插入个小修改。我在 `src/main.js` 中加入了如下的代码，可以让 `cordova js bridge` 动态插入进 `APP`：

```
// add cordova.js only if serving the app through file://
if (window.location.protocol === 'file:' || window.location.port === '3000') {
  const cordovaScript = document.createElement('script');
  cordovaScript.setAttribute('type', 'text/javascript');
  cordovaScript.setAttribute('src', 'cordova.js');
  document.body.appendChild(cordovaScript);
}
```

OVER!!