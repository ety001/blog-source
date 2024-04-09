---
author: ety001
date: '2022-03-21 08:24:49'
layout: post
title: Send email on Debian via Exim4 through a public SMTP server
tags:
  - 经验
  - Server&OS
---

First run 

```
sudo dpkg-reconfigure exim4-config
```

and use these config options:

* **General type of mail configuration:** mail sent by smarthost; received via SMTP or fetchmail
* **System mail name:** your hostname
* **IP-address to listen on for incoming SMTP connections:** 127.0.0.1
* **Other destinations for which mail is accepted:** your hostname
* **Machines to relay mail for:** leave this blank
* **IP address or host name of the outgoing smarthost:** mail.example.com::587
* **Hide local mail name in outgoing mail?**
    * Yes - all outgoing mail will appear to come from your gmail account
    * No - mail sent with a valid sender name header will keep the sender’s name
* **Keep number of DNS-queries minimal (Dial-on-Demand)?** No
* **Delivery method for local mail:** choose the one you prefer
* **Split configuration file into small files?** Yes (you need to edit one of the files next)

Then run `sudo vi /etc/exim4/passwd.client` and add the following lines for your mail host, and any aliases it has (found through `nslookup`). Substitute `email address` and `password` with the account you want to route mail through):

```
mail.example.com:email address:password
```

Once you edit the `passwd.client` file, run `sudo update-exim4.conf` which will integrate your changes into your Exim4 config.

Run `sudo systemctl restart exim4` and make sure that the service stops and starts properly. If the service is unable to restart, something probably went wrong when you edited the `passwd.client` file.

Now the configure has been finished.

We can use `exim -v receiver@email.com` to get in send process to send a test email.

If get in the editor mode, input these charaters:

```
From: user@your.domain.example
Subject: Foobar
Text Text Text
```

After inputing, press `Ctrl+d` to send test email.