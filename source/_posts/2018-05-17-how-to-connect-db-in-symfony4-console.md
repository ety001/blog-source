---
author: ety001
layout: post
title: '在 Symfony4 的 Console 中使用数据服务'
tags:
- 教程
---

真的是刚爬出一个坑，又跳到一个新坑。[LightDB](https://github.com/ety001/steem-lightdb) 的 `Transfer` 组件使用 `Symfony4` 框架，感觉 `Symfony3` 出来都没有多久，就又出来4了。本来想使用框架来节约开发时间的，结果又额外增加了时间。

在 `Symfony` 的最新文档里，给出的在 `Console` 中使用数据库的最佳实践方案是，把数据库的调用封装进 `Service` ，然后通过容器注入，来实现最终的数据库调用。

下面是代码示例：

src/Service/ExampleManager.php

```
<?php
namespace App\Service;

use Doctrine\ORM\EntityManagerInterface;
use App\Entity\Example;

class ExampleManager
{
    private $em;

    public function __construct(
                        EntityManagerInterface $em
                    )
    {
        $this->em = $em;
    }

   public function findSomething($id)
   {
       return $this->em->getRepository(Example::class)->find($id);
   }
}
```

src/Command/ExampleRunCommand.php
```
<?php
namespace App\Command;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

use App\Service\ExampleManager;

class TransferRunCommand extends Command
{
    protected static $defaultName = 'example:run';
    private $example_manager;

    public function __construct(
                        ExampleManager $example_manager,
                    )
    {
        parent::__construct();
        $this->example_manager = $example_manager;
    }

    protected function configure()
    {
        $this
            ->setDescription('run the example shell')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
       $result = $this->example_manager->findSomething(1);
    }
}
```

Over!!!