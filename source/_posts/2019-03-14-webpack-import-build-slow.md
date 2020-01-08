---
author: ety001
layout: post
title: 解决由import()导致的Webpack编译过慢的问题
tags:
- Webpack
---
## 引子

最近真的是跟 **Webpack** 作上了，又在 **Webpack** 上花费了宝贵的两天的工作时间。

上次好不容易把 **iview-admin** 集成进 **Laravel**，本来以为可以开开心心的开发了，结果在收尾的功能中需要加入富文本编辑器。由于 **iview-admin** 中集成了一个富文本编辑器，于是就把集成的这个 **wangeditor** 引入过来使用了。

结果，`webpack` 对于文件的编译速度瞬间从几秒变成了一分半钟。

WTF！

## 找原因

**Laravel Mix**默认的开发环境的编译命令如下：

```
cross-env NODE_ENV=development node_modules/webpack/bin/webpack.js --progress --hide-modules --config=node_modules/laravel-mix/setup/webpack.config.js
```

但是这个坑爹的配置，根本看不出来编译慢的问题出在哪里好吗？！（如下图，加入 **wangedit** 编辑器后，每次在70%位置就会卡主大约70多秒，甚至更多）

![](/upload/20190314/5mgCmOWo0PlYQyIv6DtpuBe2dOKS1dXqbSDkKyOl.png)

怎么才能找到是具体哪个文件编译慢呢？

最先想到的是看看 **webpack.js** 的可用参数，最终找到了一个 `--profile` 参数，加上这个参数后，稍微多了点信息，但是完全不够啊。。。还是没法确认问题在哪啊。。。

![](/upload/20190314/9Tjse6bSpsVQc05Lf3y9qjVTf54VLJxfOOY2BCYV.png)

接下来的大部分时间都花在了搜索引擎上，主要围绕的搜索关键词是 **webpack build slow** 之类的。但是完全没有什么用。

又切换了个思路，看看有没有什么好的调试工具。群里有人推荐我 **speed-measure-webpack-plugin** 。

看了下说明，是个好插件，可惜我这个项目的 **webpack** 套在 **laravel-mix** 里面，我只能通过 **laravel-mix** 提供的方法来配置 **webpack** 的参数，而 **speed-measure-webpack-plugin** 的使用方法是下面这个样子：

```
把原来的
const webpackConfig = {
  plugins: [
    new MyPlugin(),
    new MyOtherPlugin()
  ]
}
改为
const SpeedMeasurePlugin = require("speed-measure-webpack-plugin");
const smp = new SpeedMeasurePlugin();
const webpackConfig = smp.wrap({
  plugins: [
    new MyPlugin(),
    new MyOtherPlugin()
  ]
});
```

如果我想要用 **speed-measure-webpack-plugin** 的话，需要在 `node_modules` 目录下找到 **laravel-mix** 包，然后修改里面的代码，让 **laravel-mix** 在 **merge** 完用户自定义的配置后，调用 **speed-measure-webpack-plugin** ，再传给 **webpack**。

我看了下 **laravel-mix** 的代码，感觉就目前我的水平要想实现的话，需要耗费不止两天的时间吧，这样方向也有点偏。于是这个方案也抛弃了。

## 柳暗花明

虽然 **speed-measure-webpack-plugin** 不能用，但是给了我一个启发，那就是有没有可以直接写在 **webpack** 的 `plugins` 配置中调用的调试插件呢？

功夫不负有心人，在大半天之后，偶然在 **Stack Overflow** 的一个问题的回复中看到了 **simple-progress-webpack-plugin** 这个插件。不过当时心是灰的，因为找了很久没找到，打开这个插件的文档，里面也没有个截图啥的，完全就是死马当活马医，试了试。按照文档提示，先安装 `npm install simple-progress-webpack-plugin --save-dev`，然后修改 **laravel-mix** 的配置：

```
const SimpleProgressWebpackPlugin = require( 'simple-progress-webpack-plugin' ); // 这是新增的配置

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
    plugins: [
      new SimpleProgressWebpackPlugin() // 这是新增的配置
    ],
  })
  .babelConfig({
    persets: ['@vue/app']
  })
  .version();
```

这次打印出来的信息有些用处了，如下图所示

![](/upload/20190314/PDgL8dwFCOFWMeOnhuHKgeQXJGJCGRpozYqBhXqV.png)

这次知道是在 **Optimize modules** 阶段速度慢了，具体是在 **Module and chunk tree optimization** 这里。于是以 **webpack optimize modules slow** 为关键词搜索，结果第一条就解决了问题：

![](/upload/20190314/KTcXU9Us6ovluPwrjKInWrMMiRET9li1oSorU7U6.png)

![](/upload/20190314/ZBwQ1lkkhBHQ8JQU8ImNfyBwBuXT205TLYBWwhx9.png)

妈蛋的原来是在异步加载优化这里慢啊。按照 **issue** 里提到的 **babel-plugin-dynamic-import-node** 插件，搜索了下，找到安装部署方法 `npm install babel-plugin-dynamic-import-node --save-dev`，然后配置下 **laravel-mix**

```
const SimpleProgressWebpackPlugin = require( 'simple-progress-webpack-plugin' );

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
    plugins: [
      new SimpleProgressWebpackPlugin()
    ],
  })
  .babelConfig({
    plugins: ['dynamic-import-node'], // 新增配置
  })
  .version();
```

再次编译，瞬间完成！！撒花！！

## 区别

但是看到有提到是在 **dev** 环境使用 **babel-plugin-dynamic-import-node** 插件，这是为啥呢？用 **require** 和 **import()** 有啥区别呢？

初步探索了下发现使用 **babel-plugin-dynamic-import-node** 把 **import()** 替换成 **require** 编译的话，就没有 **chunk files** 了，相当于是跳过了 **code split** 之类的阶段吧（我猜是这样）。

可以看下下面的两个截图，第一个是不使用 **babel-plugin-dynamic-import-node** 进行生产环境 **build**，第二个是使用的情况进行 **build**。

![](/upload/20190314/Zg2z9MCHBwYopX7wks27BGHLIME812UDjNVBDUMr.png)

![](/upload/20190314/NU6O2K8WIQaJdmjXkfMJdc4jab0ZKGg2MtJggPbz.png)

从最终的文件大小和编译所需要的时间来看，目前不用 **chunk** 功能，并没有什么问题，于是最终选择使用 **babel-plugin-dynamic-import-node** 以此来解决编译时间过长的原因。

具体深入进去还有什么区别没时间探索了，目前编译后，使用正常，那就先这样吧。。。
