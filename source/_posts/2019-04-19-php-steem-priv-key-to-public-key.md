---
author: ety001
layout: post
title: 用php实现steem的private key转为public key的功能
tags:
- Server&OS
---
直接上代码：

```
use BitWasp\Bitcoin\Key\Factory\PrivateKeyFactory;
use BitWasp\Buffertools\Buffer;
use BitWasp\Buffertools\Buffertools;
use BitWasp\Bitcoin\Crypto\Hash;
use BitWasp\Bitcoin\Base58;
use BitWasp\Bitcoin\Bitcoin;
use BitWasp\Bitcoin\Crypto\EcAdapter\Impl\PhpEcc\Key\PublicKey;

function getPubKeyFromPrivKeyWif($wif) {
	$factory = new PrivateKeyFactory();
	$privKey = $factory->fromWif($wif);
	$publicKey = $privKey->getPublicKey();
	$pubKeyBuff = doSerialize($publicKey);
	$checkSum = Hash::ripemd160($pubKeyBuff);
	$addy = Buffertools::concat($pubKeyBuff, $checkSum->slice(0, 4));
	$pubdata = Base58::encode($addy);
	$pubKeyStr = 'STM'.$pubdata;
	return $pubKeyStr;
}

function doSerialize(PublicKey $pubKey) {
	$point = $pubKey->getPoint();
	$prefix = getPubKeyPrefix($pubKey);
	$xBuff = Buffer::hex(gmp_strval($point->getX(), 16), 32);
	$yBuff = Buffer::hex(gmp_strval($point->getY(), 16), 32);
	$data = Buffertools::concat($prefix , $xBuff);
	// steem的compress与btc相反
	if ($pubKey->isCompressed()) {
		$data = Buffertools::concat($data, $yBuff);
	}
	return $data;
}

function getPubKeyPrefix($pubKey) {
	// steem的compress与btc相反
	return !$pubKey->isCompressed() ?
		Bitcoin::getEcAdapter()->getMath()->isEven($pubKey->getPoint()->getY())
			? Buffer::hex('02', 1) : Buffer::hex('03', 1)
		: Buffer::hex('04', 1);
}
```

之前一直搞不出来，就是因为不知道为什么 **Steem** 判断压缩的变量跟 **BTC** 的正好是反的。不懂，先略过吧。
