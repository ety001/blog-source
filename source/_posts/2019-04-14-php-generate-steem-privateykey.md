---
author: ety001
layout: post
title: 用 PHP 生成 Steem 的私钥
tags:
- Server&OS
- PHP
- Steem
---
# 起因
因为最近要开发 [AuthSteem](https://github.com/ety001/authsteem)（一个 **SteemConnect** 的 **PHP** 版本的复制品），其中需要到生成私钥，验证私钥之类的操作，而目前没有找到一款包含这个功能的 **PHP SDK**，所以要自己来实现。

# 代码
虽然过程很艰辛，但是代码还是很简短的，如下：
```
use BitWasp\Bitcoin\Key\Factory\PrivateKeyFactory;
function generatePrivateKeysFromMainPassword($username, $mainPassword) {
	$roles = ['owner', 'active', 'posting', 'memo'];
	$result = [];
	$factory = new PrivateKeyFactory();
	foreach ($roles as $role) {
		$seed = $username.$role.$mainPassword;
		$brainKey = implode(" ", explode("/[\t\n\v\f\r ]+/", trim($seed)));
		$hashSha256 = hash('sha256', $brainKey);
		$privKey = $factory->fromHexUncompressed($hashSha256);
		$result[$role] = $privKey->toWif();
	}
	return $result;
}
$result = generatePrivateKeysFromMainPassword('ety001', '123456');
```

# 探索过程
过程真的是很艰辛，主要时间就是在读 **steem-js** 的源代码中度过的。另外有一篇关于比特币地址的文章也有指导意义，地址是：[https://www.cnblogs.com/kumata/p/10477369.html](https://www.cnblogs.com/kumata/p/10477369.html) 。

总结下，生成过程是 **$username**, **$role**, **$mainPassword**，三者连接后的字符串做 **sha256** 哈希，哈希的这一步的目的是产生一个 **32-byte** 的 **hex** 字符串，这个字符串也就是你的私钥了，只不过这个私钥还需要经过一步处理，才是我们平时看到的样子。这个过程就是 **Base58**。

**Base58** 的目的就是要把 **256-bit** 的二进制串（也就是 **32-byte** 的 **hex** 字符串）转换为人类可读的、相对较短、不易写错的字符串。详细的内容在上面我给出的那个文章里有。

经过 **Base58** 处理后，就能得到我们平时看到的私钥字符串了。

这里我找到了一个库 `bitwasp/bitcoin`，可以帮助我更好的完成这个过程。通过使用这个库的 `BitWasp\Bitcoin\Key\Factory\PrivateKeyFactory::fromHexUncompressed()` 方法，可以快速的完成这个工作。

# 下一步
本计划等研究出如何把私钥转成公钥后再发文，但无奈花了一个下午，还是没有弄成功，于是下一步的工作就是需要能用 `bitwasp/bitcoin` 库已有的方法，实现通过私钥得到公钥。

目前尝试了 `bitwasp/bitcoin` 库里面自带的 `BitWasp\Bitcoin\Address\PayToPubKeyHashAddress` 类继承的 `getAddress` 方法，但是得到的地址并不是 **Steem** 格式的公钥地址。问题应该是 **Steem** 得到公钥的过程跟 **BTC** 还是有区别的。

另外仿照 **Steem-js** 的这段代码[https://github.com/steemit/steem-js/blob/master/src/auth/ecc/src/key_public.js#L110](https://github.com/steemit/steem-js/blob/master/src/auth/ecc/src/key_public.js#L110) 改写了一段 PHP 的版本，仿写的代码如下：

```
use BitWasp\Bitcoin\Key\Factory\PrivateKeyFactory;
use BitWasp\Buffertools\Buffertools;
use BitWasp\Bitcoin\Crypto\Hash;
use BitWasp\Bitcoin\Base58;
function getPubKeyFromPrivKeyWif($wif) {
	$factory = new PrivateKeyFactory();
	$privKey = $factory->fromWif($wif);
	$pubKeyBuff = $privKey->getBuffer();
	$checkSum = Hash::ripemd160($pubKeyBuff);
	$addy = Buffertools::concat($pubKeyBuff, $checkSum->slice(0, 4));
	$pubdata = Base58::encode($addy);
	$pubKeyStr = 'STM'.$pubdata;
	return $pubKeyStr;
}
```

但是，结果依旧不对。

所以还得继续折腾。。。

---
**ET碎碎念，每周一，晚六点一刻更新，欢迎订阅**
**也可以订阅号留言**
![](/img/wechat-subscribe.jpg)
