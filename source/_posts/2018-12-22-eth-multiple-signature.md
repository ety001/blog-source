---
author: ety001
layout: post
title: ETH多签测试
tags:
- ethereum
- 数字货币
---

## 前言

ETH的多签是依靠智能合约实现的，也就是说持币的是智能合约，通过在智能合约里设置条件，来使转账之类的权限通过多人签名来集体控制。

从网上找到了一段简单的多签智能合约，代码如下：

```
pragma solidity ^0.4.21;

contract MultiSigWallet{
    address private owner;
    mapping (address => uint8) private managers;
    
    modifier isOwner{
        require(owner == msg.sender);
        _;
    }
    
    modifier isManager{
        require(
            msg.sender == owner || managers[msg.sender] == 1);
        _;
    }
    
    uint constant MIN_SIGNATURES = 3;
    uint private transactionIdx;
    
    struct Transaction {
        address from;
        address to;
        uint amount;
        uint8 signatureCount;
        mapping (address => uint8) signatures;
    }
    
    mapping (uint => Transaction) private transactions;
    uint[] private pendingTransactions;
    
    function MultiSigWallet() public{
        owner = msg.sender;
    }
    
    event DepositFunds(address from, uint amount);
    event TransferFunds(address to, uint amount);
    event TransactionCreated(
        address from,
        address to,
        uint amount,
        uint transactionId
        );
    
    function addManager(address manager) public isOwner{
        managers[manager] = 1;
    }
    
    function removeManager(address manager) public isOwner{
        managers[manager] = 0;
    }
    
    function () public payable{
        emit DepositFunds(msg.sender, msg.value);
    }
    
    function withdraw(uint amount) isManager public{
        transferTo(msg.sender, amount);
    }
    function transferTo(address to,  uint amount) isManager public{
        require(address(this).balance >= amount);
        uint transactionId = transactionIdx++;
        
        Transaction memory transaction;
        transaction.from = msg.sender;
        transaction.to = to;
        transaction.amount = amount;
        transaction.signatureCount = 0;
        transactions[transactionId] = transaction;
        pendingTransactions.push(transactionId);
        emit TransactionCreated(msg.sender, to, amount, transactionId);
    }
    
    function getPendingTransactions() public isManager view returns(uint[]){
        return pendingTransactions;
    }
    
    function signTransaction(uint transactionId) public isManager{
        Transaction storage transaction = transactions[transactionId];
        require(0x0 != transaction.from);
        require(msg.sender != transaction.from);
        require(transaction.signatures[msg.sender]!=1);
        transaction.signatures[msg.sender] = 1;
        transaction.signatureCount++;
        
        if(transaction.signatureCount >= MIN_SIGNATURES){
            require(address(this).balance >= transaction.amount);
            transaction.to.transfer(transaction.amount);
            emit TransferFunds(transaction.to, transaction.amount);
            deleteTransactions(transactionId);
        }
    }
    
    function deleteTransactions(uint transacionId) public isManager{
        uint8 replace = 0;
        for(uint i = 0; i< pendingTransactions.length; i++){
            if(1==replace){
                pendingTransactions[i-1] = pendingTransactions[i];
            }else if(transacionId == pendingTransactions[i]){
                replace = 1;
            }
        } 
        delete pendingTransactions[pendingTransactions.length - 1];
        pendingTransactions.length--;
        delete transactions[transacionId];
    }
    
    function walletBalance() public isManager view returns(uint){
        return address(this).balance;
    }
}
```

## 部署合约

我本地的测试网络是使用 [**Ganache**](https://truffleframework.com/ganache) 搭建的，如下图

![](/upload/20181222/L4Eyix0wrf4gIollkxdHytVyd5cgbCdXI3kvcZP9.png)

我修改了我的 **Ganache** 的端口为 **8545**。

然后打开 [**Remix**](http://remix.ethereum.org/#)，在右边栏选择 **Run**，在 **Environment** 中选择 **Web3 Provider**，如下图

![](/upload/20181222/5cE6alqJv6QxCd25lESLhFuxeeZQRrVAiFWtj40h.png)

在弹出的层中，输入本地地址和刚才配置的8545端口，就可以连接到 **Ganache** 的环境了，如下图

![](/upload/20181222/jY43d1c4RtY1pGlwO7dl0KizQJWql8aGzAhXnCN1.png)

连接成功后，会看到在 **Environment** 下面的 **Account** 栏中会列出所有 **Ganache** 中的测试账号。

我们选择第一个账号作为部署合约的主账号，即合约的 **owner**。

在编辑器中创建一个新的合约文件，把上面的合约代码复制进编辑器，右边栏选择 **Compile** ，
在 **Select new compiler version** 中选择 **0.4.21** 版本的编译器，等待编译完成。
完成后，最下面出现绿色的提示信息，如下图

![](/upload/20181222/k6OPqJvJys4K69lcKHn4BshSUYtXWLAsdcl1QZKL.png)

再切换回 **Run** 标签，点击 **Deploy** 就可以部署了。
部署成功后，在 **Deployed Contracts** 中就能看到新部署的合约了，下拉打开可以看到合约的各个接口，如图

![](/upload/20181222/S8aVs938m7ft7bxlmVTRmk9mwyyHomyXPUbCamwz.png)

## 增加合约管理员

在右边栏找到合约的 **addManager** 接口，下拉打开输入一个以太钱包地址，然后点击 **transact** 即完成添加。
这里我把 **Ganache** 的第 2 到 4 的地址加入进管理员中。

![](/upload/20181222/YnjFibmHTTEV1g0fD8LVpltCwUz1XB1PTRRwXUBq.png)

## 给合约内转账

切换回 **Ganache**，在 **Transactions** 中找到我们刚才部署的合约地址，`0x08ea5409922D4204C0E03d17243E77c3810C0CCe`，

![](/upload/20181222/UeCYGKvH71KR9rglfytM804vtEPhujdRTyI8Lh6T.png)

使用任意的其他账号转账任意个 **ETH** 进合约里。
我用的是 [**MyEtherWallet**](https://www.myetherwallet.com/)进行的转账，只需要把节点设置成本地网络，
然后用私钥模式登陆转账即可，这里就略过不说了。

![](/upload/20181222/MPimqby4mz4E5Na5klyh1V5j8mdmS524tUYAi8eB.png)

转完账后，在 **Remix** 的 **Run** 标签下，找到合约的 **walletBalance** 接口，
点击调用即可显示当前合约的余额，注意单位！

![](/upload/20181222/iE2U7iMdDcVZsTRxrCaC0RV7mL0UFZdYMfsxWmE8.png)

## 多签从合约内转出金额

回到 **Remix**，在右边栏的 **Run** 标签下，先确认 **Account** 选择的是合约的 **owner**，
这个例子里就是第一个测试地址了。

在合约中找到 **transferTo**，下拉打开，输入一个本地测试网络中的以太钱包地址，输入待转账的金额，点击 **transact**。这里注意单位，下图为转 5 ETH，

![](/upload/20181222/A9w0zfyJdUyEhmZQLffBCVMGsQxd2Nm8dG4FoMr6.png)

成功执行后，就会有一个等待多签的 **transaction** 在 **pendingTransactions** 这个数组里。
点击 **getPendingTransactions** 可以得到当前等待多签的 **transaction** 在数组中的索引值。
下图则代表当前等待多签的 **transaction** 的索引值是 0 。

![](/upload/20181222/TJgxy72QO6CEOZ6BmOCvz2GLPCtl9FtM9h0uoueH.png)

这时，在 **Run** 标签页的顶部，把 **Account** 依次切换为其他几个管理员，分别执行合约的 **signTransaction** 接口即可完成多签，其中 **transactionId** 就是上一步中的索引值，如下图

![](/upload/20181222/oOACWaJc1OkPG4XOfeEAlCP62tS0h5ihc4hClikr.png)

目前这个合约代码中，是当签名管理员的数量大于等于3个，就正式完成多签并发送交易。
所以当第三个管理执行完 **signTransaction** 后，查一下合约的余额就发现已经转出去 5ETH了。

## 总结

目前这个例子中的合约代码还是比较简单的，没有各个用户的权重关系。这个就可以根据自己的需要来写合约了。

Over！