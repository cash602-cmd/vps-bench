# 🚀 VPS Bench — Standardized VPS Benchmarking Script

A lightweight, opinionated benchmarking script for VPS servers.  
Designed to produce consistent, comparable results across providers.

> 📊 Published results & live data: **[Benchmark Database](https://vpsrankings.com/benchmarks)**

## Quick Start

```bash
# One-line install & run (requires root)
curl -sL https://raw.githubusercontent.com/cash602-cmd/vps-bench/main/bench.sh | bash
```

Or download and run manually:

```bash
wget https://raw.githubusercontent.com/cash602-cmd/vps-bench/main/bench.sh
chmod +x bench.sh
./bench.sh
```

## What It Tests

| Test | Tool | Metric |
|------|------|--------|
| **CPU** | sysbench | Single & Multi-thread events/s |
| **Disk (basic)** | dd | Sequential read/write MB/s |
| **Disk (advanced)** | FIO | 4K random read/write IOPS |
| **Network** | curl | Download speed from global endpoints |
| **Latency** | ping | RTT to Cloudflare, Google, China ISPs |
| **China Routes** | traceroute | CN2 GIA / 9929 / CMIN2 / 163 detection |

## Sample Output

```
============================================
  VPS Bench v1.0 — vpsrankings.com
============================================

[System Info]
  Hostname: vultr-hf-lax
  OS:       Ubuntu 24.04.1 LTS
  Kernel:   6.8.0-45-generic
  CPU:      AMD EPYC-Milan (3rd Gen)
  Cores:    2
  RAM:      2.0Gi
  Disk:     55G

[CPU Benchmark — sysbench]
  Single-thread:  3847.21 events/s
  Multi-thread:   7694.53 events/s (2 threads)

[Disk I/O — dd]
  Sequential Write (256MB): 1.2 GB/s
  Sequential Read  (256MB): 2.8 GB/s

[Disk I/O — FIO]
  4K Random Read:
    IOPS: 78432 | BW: 306.38 MB/s
  4K Random Write:
    IOPS: 62118 | BW: 242.65 MB/s

[Network Latency — ping]
  Cloudflare         (1.1.1.1):     0.532ms
  Google             (8.8.8.8):     1.247ms
  China Telecom      (202.96.209.133): 156.3ms
  China Unicom       (221.5.88.88):  142.8ms

[Download Speed]
  Cloudflare (25MB):  156.23 MB/s
  Hetzner DE (10MB):  42.17 MB/s

[China Route Detection]
  China Telecom: CN2 GIA (AS4809) ★★★★★
  China Unicom:  9929 Premium (AS9929) ★★★★★

============================================
  Test Complete!
  Full database: https://vpsrankings.com/benchmarks
============================================
```

## Tested Providers

We have benchmarked these providers (and counting):

| Provider | Type | Dedicated Review & Benchmark |
|----------|------|------------------------------|
| **Vultr** | High Frequency, Cloud Compute | [Vultr Review 2026: High-Performance Global Cloud](https://vpsrankings.com/en/articles/7at9f141-vultr-review-2026-best-high-performance-global-vps-with) |
| **RackNerd** | Budget VPS | [RackNerd VPS Review 2026: Budget Value Pick](https://vpsrankings.com/en/articles/11edv4zd-racknerd-vps-review) |
| **Hetzner** | Cloud, Dedicated | [Hetzner VPS Review 2026: Cost-Effective European Cloud](https://vpsrankings.com/en/articles/or4r5go7-hetzner-vps-review-real-experience-of-cost-effective) |
| **DigitalOcean** | Basic, Premium Droplets | [DigitalOcean Review 2026: Developer-Preferred Cloud](https://vpsrankings.com/en/articles/5kvqbmq7-digitalocean-review-2026-high-performance-vps-preferred-by) |
| **Hostinger** | Cloud VPS | [Hostinger VPS Review 2026: Beginner-Friendly Cloud VPS](https://vpsrankings.com/en/articles/je6pucra-2026-hostinger-vps-review-beginner-friendly-great-value-but) |
| **BandwagonHost** | CN2 GIA Optimized | [BandwagonHost Review 2026: CN2 GIA Routing Advantage](https://vpsrankings.com/en/articles/vrdmqzyg-bandwagonhost-review-2026-does-bandwagon-vps-still-have-its) |
| **Contabo** | VPS S/M/L/XL | [Contabo VPS Review 2026: High-Storage Instance Analysis](https://vpsrankings.com/en/articles/iqrwcfsk-contabo-vps-review-2026) |
| **Cloudways** | Managed Cloud | [Cloudways Review 2026: Managed Cloud Platform Guide](https://vpsrankings.com/en/articles/oykzenyi-cloudways-review-2026) |
| **Kamatera** | Custom Config Cloud | [Kamatera Review 2026: Flexible Hourly Cloud VPS](https://vpsrankings.com/en/articles/0h9m2b80-kamatera-review-2026-is-their-flexible-cloud-vps-worth) |
| **DMIT** | Premium Asia Routes | [DMIT VPS Review 2026: Premium CN2 GIA & Optimized Routes](https://vpsrankings.com/en/articles/c5cjkbgg-dmit-vps-evaluation-high-performance-optimized-lin) |

> 💡 Want your provider tested? [Open an issue](https://github.com/cash602-cmd/vps-bench/issues/new)!

> 💡 **Budget Planning**: Trying to decide between $5, $10, and $20 budget tiers? Read our comprehensive breakdown: [Budget VPS Comparison: $5 / $10 / $20 Plans Tested](https://vpsrankings.com/en/articles/m2am74qh-vps-options-for-different-budgets-51020-level-comp).

## Why Another Benchmark Script?

Most benchmark scripts dump a wall of unstructured text. This one:

1. **Standardized** — Same tests, same parameters, every time
2. **Comparable** — Clean output format designed for side-by-side comparison
3. **China-aware** — Detects CN2 GIA, 9929, CMIN2, and 163 backbone routes
4. **Archived** — Results formatted for our [Benchmark Database](https://vpsrankings.com/benchmarks)
5. **Transparent** — Every test command is visible in the script, no hidden calls

## Requirements

- Linux (Ubuntu/Debian/CentOS/AlmaLinux)
- Root access (for disk benchmarks)
- Optional: `sysbench`, `fio`, `traceroute` (script will warn if missing)

```bash
# Install all optional dependencies (Debian/Ubuntu)
apt update && apt install -y sysbench fio traceroute bc

# Install all optional dependencies (CentOS/AlmaLinux)
yum install -y sysbench fio traceroute bc
```

## Contributing

PRs welcome! If you want to add a test or improve the output:

1. Fork this repo
2. Create a feature branch (`git checkout -b feature/add-gpu-bench`)
3. Submit a PR with a description of what you changed

Ideas for future tests:
- [ ] GPU benchmark (for AI/ML workloads)
- [ ] Streaming service unlock detection
- [ ] IPv6 connectivity check
- [ ] Automated result upload to vpsrankings.com

## Related Resources

- 🏆 [VPS Rankings](https://vpsrankings.com/rankings) — Score-based VPS leaderboard
- 📊 [Benchmark Database](https://vpsrankings.com/benchmarks) — All published test results
- 💰 [Budget VPS Comparison Guide](https://vpsrankings.com/en/articles/m2am74qh-vps-options-for-different-budgets-51020-level-comp) — $5 / $10 / $20 Tiered Comparison
- 💵 [VPS Deals](https://vpsrankings.com/deals) — Current discounts and promos
- 🧮 [VPS Calculator](https://vpsrankings.com/vps-calculator) — Find the right plan for your workload
- 📖 [Beginner Guide](https://vpsrankings.com/guide) — From zero to deployed
- 🤖 [AI-friendly summary](https://vpsrankings.com/llms.txt) — For LLM agents

## License

MIT — Use it, fork it, share it. Attribution appreciated but not required.

---

**Built with ❤️ by [Bob Tong](https://vpsrankings.com/author) at [VPS Rankings](https://vpsrankings.com/)**
