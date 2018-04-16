---
author: ety001
date: 2011-09-15 07:14:09+00:00
layout: post
title: 使用PHP的fsockopen方法post提交数据
wordpress_id: 1607
tags:
- 编程语言
- 后端
---

test1.php文件如下:

```
function posttohost($url, $data) {
$url = parse_url($url);
if (!$url) return “couldn’t parse url”;
if (!isset($url['port'])) { $url['port'] = “”; }
if (!isset($url['query'])) { $url['query'] = “”; }
$encoded = “”;
while (list($k,$v) = each($data)) {
$encoded .= ($encoded ? “&” : “”);
$encoded .= rawurlencode($k).”=”.rawurlencode($v);
}
$fp = fsockopen($url['host'], $url['port'] ? $url['port'] : 80);
if (!$fp) return “Failed to open socket to $url[host]“;
fputs($fp, sprintf(“POST %s%s%s HTTP/1.0\n”, $url['path'], $url['query'] ? “?” : “”, $url['query']));
fputs($fp, “Host: $url[host]\n”);
fputs($fp, “Content-type: application/x-www-form-urlencoded\n”);
fputs($fp, “Content-length: ” . strlen($encoded) . “\n”);
fputs($fp, “Connection: close\n\n”);
fputs($fp, “$encoded\n”);
$line = fgets($fp,1024);
if (!eregi(“^HTTP/1\.. 200″, $line)) return;
$results = “”; $inheader = 1;
while(!feof($fp)) {
$line = fgets($fp,1024);
if ($inheader && ($line == “\n” || $line == “\r\n”)) {
   $inheader = 0;
}
elseif (!$inheader) {
   $results .= $line;
}
}
fclose($fp);
return $results;
}
$arrVal["cc"] = 88;
$strTemp = posttohost(“http://www.juuyou.com/test2.php“, $arrVal);
print_r($strTemp);
========================= 我是分隔线 ======================================
test2.php文件如下:
$intC = $_POST["cc"];
for($c=1; $c<$intC; $c++){
echo $c.”|”;
}
```

