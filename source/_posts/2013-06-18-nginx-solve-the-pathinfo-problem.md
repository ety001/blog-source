---
author: ety001
comments: true
date: 2013-06-18 12:25:17
layout: post
slug: nginx-solve-the-pathinfo-problem
title: nginx中解决pathinfo问题
wordpress_id: 2406
tags:
- Server&OS
---

`
location / {
    if (!-e $request_filename) {
        rewrite  ^(.*)$  /index.php/$1  last;
        break;
    }
}

location ~ \.php($|/) {
     fastcgi_pass  unix:/tmp/php-cgi.sock;
     fastcgi_index  index.php;

     set $script    $uri;
     set $path_info "";
     if ($uri ~ "^(.+\.php)(/.*)") {
          set  $script     $1;
          set  $path_info  $2;
     }

     include       fastcgi.conf;
     fastcgi_param SCRIPT_FILENAME   $document_root$script;
     fastcgi_param SCRIPT_NAME       $script;
     fastcgi_param PATH_INFO         $path_info;
}
`

