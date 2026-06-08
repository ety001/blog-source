---
author: ety001
title: 在廉价独服下调优 Hivemind PostgreSQL
date: 2026-06-08 20:00:00
layout: post
tags:
- 经验
- 服务器
- PostgreSQL
- Docker
- steem
---

# 背景

手里有一台 dzire 的廉价独服，配置如下：

| 项目 | 参数 |
|------|------|
| CPU | Intel Xeon E31270（8 核） |
| 内存 | 16GB DDR3 |
| 磁盘 | **机械硬盘（HDD）** |
| 用途 | Hivemind 同步 Steem 区块数据 |

Hivemind 是 Steem 链的社交层索引器，通过 Docker Compose 部署，其中 PostgreSQL 数据库承载了大量的写入和查询操作。同步一段时间后，数据库体积达到了 **431GB**，其中最大的几张表：

| 表名 | 大小 |
|------|------|
| hive_posts_cache | 216GB |
| hive_trxid_block_num | 110GB |
| 其他表 | ~105GB |

问题来了：同步进程始终落后链头几百个区块，追不上。

# 问题诊断

## 症状

`top` 和 `htop` 里最显眼的指标是 **IO Wait 持续 25%~35%**，CPU 大量时间在等磁盘。

## 确认瓶颈

用 `iostat` 和 `vmstat` 进一步确认：

```bash
# iostat -x 1 观察
Device:  rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s  %util  await
sda        0.00    45.20   12.30  120.50     0.15     3.80   95.2   28.5

# vmstat 1 观察
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  3      0 2100000 450000 8500000    0    0   120   380  2500  4500 15  8 42 32  3
```

关键信号：

- **%util 接近 100%**：磁盘已经满负荷
- **wa（IO Wait）持续 25~35%**：CPU 大量时间在等 IO
- **w/s 高达 120+**：大量小随机写（WAL + 数据文件）

**结论：磁盘 IO 是瓶颈，毫无疑问。**

在 SSD 上这些问题可能根本不会出现，但在 HDD 上，PostgreSQL 默认配置的检查点频率、WAL 刷写策略会导致大量小随机写，对机械硬盘来说是灾难性的。

# 调优思路

核心策略：**减少磁盘写频率，增大批量写入，降低 fsync 开销**。

具体来说：

1. **增大 `shared_buffers`**：让更多热数据留在内存，减少磁盘读取
2. **增大 `max_wal_size`** + **延长 `checkpoint_timeout`**：减少检查点频率，让每次检查点写出更多数据（顺序写更友好）
3. **放宽 WAL 刷写策略**：`wal_writer_delay`、`wal_writer_flush_after` 调大，减少 fsync 次数
4. **激进调优 bgwriter**：让后台写出进程多干活，减少检查点时的突发写入
5. **关闭 `full_page_writes`**：HDD 上这个特性会导致每次检查点后首次修改页写出完整页，极大放大写入量。**注意：这依赖文件系统支持原子写（如 ZFS），否则断电有数据损坏风险。** 本场景是同步数据，可以接受这个风险。

> **⚠️ 警告**：第二轮激进配置的前提是——这台机器**只做同步，不对外提供服务**。如果你在生产环境中使用，请谨慎评估每一个参数。

# 具体配置

## 第一轮调优（保守）

初步调整，先把 PostgreSQL 的默认参数改到合理范围：

| 参数 | 默认值 | 调整后 |
|------|--------|--------|
| shared_buffers | 128MB（或 4GB） | 6GB |
| max_wal_size | 1GB（或 2GB） | 4GB |
| checkpoint_timeout | 5min（或 15min） | 30min |

这一轮调完后，IO Wait 有所下降但仍然不够，同步仍然落后。

## 第二轮调优（激进）

因为这台机器的唯一任务就是追赶同步，不需要担心崩溃恢复后的数据一致性（大不了重新同步），于是上了激进方案：

| 参数 | 第一轮值 | 激进值 | 说明 |
|------|----------|--------|------|
| shared_buffers | 6GB | **8GB** | 占总内存 50% |
| max_wal_size | 4GB | **8GB** | 允许 WAL 累积更多再检查点 |
| checkpoint_timeout | 30min | **1h** | 每小时才做一次检查点 |
| wal_writer_delay | 200ms | **2s** | WAL writer 每 2 秒才醒来一次 |
| wal_writer_flush_after | 1MB | **16MB** | 累积 16MB 才 fsync |
| bgwriter_delay | 200ms | **5s** | 后台写出进程降低唤醒频率 |
| bgwriter_lru_maxpages | 100 | **5000** | 每次醒来多写出一些脏页 |
| bgwriter_lru_multiplier | 2.0 | **10.0** | 更激进地预写出 |
| full_page_writes | on | **off** | 关闭全页写，大幅减少 IO |

## 完整的 postgresql.conf（16g-postgres.conf）

```ini
# =============================================================
# PostgreSQL 16GB HDD 独服调优配置 - Hivemind 同步专用
# 注意：激进配置，仅适用于同步/非生产场景
# =============================================================

# ---- 内存 ----
shared_buffers = 8GB
work_mem = 64MB
maintenance_work_mem = 1GB
effective_cache_size = 12GB

# ---- WAL / 检查点 ----
max_wal_size = 8GB
min_wal_size = 2GB
checkpoint_timeout = 1h
checkpoint_completion_target = 0.9
wal_writer_delay = 2s
wal_writer_flush_after = 16MB
full_page_writes = off
wal_buffers = 64MB

# ---- 后台写出 ----
bgwriter_delay = 5s
bgwriter_lru_maxpages = 5000
bgwriter_lru_multiplier = 10.0

# ---- 查询规划 ----
random_page_cost = 4.0
effective_io_concurrency = 2
max_parallel_workers_per_gather = 2
max_parallel_workers = 4
max_parallel_maintenance_workers = 2

# ---- 连接 ----
max_connections = 100

# ---- 日志（方便观察） ----
log_checkpoint = on
log_connections = on
log_disconnections = on
log_lock_waits = on
log_temp_files = 0

# ---- autovacuum ----
autovacuum = on
autovacuum_max_workers = 4
autovacuum_naptime = 30s
```

几个值得解释的点：

- **`random_page_cost = 4.0`**：HDD 的随机访问代价远高于 SSD（SSD 通常设 1.1），告诉规划器尽量走顺序扫描或索引扫描。
- **`effective_io_concurrency = 2`**：HDD 的并发 IO 能力有限，设高了没意义。
- **`autovacuum_naptime = 30s`**：Hivemind 同步产生大量 UPDATE/INSERT，频繁 vacuum 有助于避免表膨胀。
- **`full_page_writes = off`**：这个最激进。正常情况下 PostgreSQL 在检查点后首次修改一页时会写出完整页（防止部分写撕裂）。关闭后每次只写差异，大幅减少写入量。如果你的文件系统是 ZFS 或使用了带电池保护的 RAID 控制器，风险可控。

## Docker Compose 配置片段

PostgreSQL 配置文件放在 `docker-compose.yml` 同目录下，通过 volume 挂载：

```yaml
services:
  postgres:
    image: postgres:15
    restart: unless-stopped
    shm_size: '2gb'
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: hivemind
      POSTGRES_PASSWORD: your_password_here
      POSTGRES_DB: hivemind
    volumes:
      - ./data/postgresql:/var/lib/postgresql/data
      - ./16g-postgres.conf:/etc/postgresql/postgresql.conf
    command: postgres -c config_file=/etc/postgresql/postgresql.conf
    deploy:
      resources:
        limits:
          memory: 14g
        reservations:
          memory: 10g
```

注意 `shm_size: '2gb'` 不能省——PostgreSQL 的 `shared_buffers` 依赖共享内存，默认的 64MB 远远不够。

# 效果对比

| 指标 | 默认配置 | 第一轮（保守） | 第二轮（激进） |
|------|----------|----------------|----------------|
| IO Wait | 25~35% | ~22% | **~15%** |
| 同步速度 | 落后链头数百块 | 略有改善 | **稳定追赶，差距持续缩小** |
| 检查点写入突发 | 频繁且剧烈 | 减少但仍有突发 | **平滑，几乎无感** |

IO Wait 从 25~35% 降到 15%，看似降幅不大，但对于 HDD 来说这已经是巨大的改善。关键改善在于写入模式——从大量小随机写变成了少量大批量顺序写，这正是机械硬盘最擅长的工作模式。

# 总结

1. **先诊断再动手**：用 `iostat`、`vmstat`、`pg_stat_bgwriter` 定位瓶颈，不要盲目改参数
2. **HDD 的核心敌人是随机写**：所有调优方向都围绕"把随机写变顺序写、把频繁写变批量写"
3. **激进配置有代价**：`full_page_writes = off` 在断电时有数据损坏风险，生产环境慎用
4. **资源要给够**：`shared_buffers` 给到总内存的 50%，`shm_size` 别忘了调大
5. **同步场景可以激进**：最坏情况就是重新同步，不用过于保守

如果你的独服也是 HDD，且在跑重 IO 的数据库同步任务，希望这篇能帮到你。
