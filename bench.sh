#!/bin/bash
# VPS Bench v1.0 — Standardized VPS Benchmarking Script
# https://vpsrankings.com | https://github.com/cash602-cmd/vps-bench
# License: MIT

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  VPS Bench v1.0 — vpsrankings.com${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# --- System Info ---
echo -e "${GREEN}[System Info]${NC}"
echo "  Hostname: $(hostname)"
echo "  OS:       $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2 || echo 'Unknown')"
echo "  Kernel:   $(uname -r)"
echo "  CPU:      $(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d':' -f2 | xargs || echo 'Unknown')"
echo "  Cores:    $(nproc 2>/dev/null || echo 'Unknown')"
echo "  RAM:      $(free -h 2>/dev/null | awk '/Mem:/ {print $2}' || echo 'Unknown')"
echo "  Disk:     $(df -h / 2>/dev/null | awk 'NR==2 {print $2}' || echo 'Unknown')"
echo "  Uptime:   $(uptime -p 2>/dev/null || uptime | awk '{print $3,$4}' || echo 'Unknown')"
echo ""

# --- CPU Benchmark (sysbench) ---
echo -e "${GREEN}[CPU Benchmark — sysbench]${NC}"
if command -v sysbench &>/dev/null; then
  single=$(sysbench cpu --cpu-max-prime=20000 --threads=1 run 2>/dev/null | grep 'events per second' | awk '{print $NF}')
  multi=$(sysbench cpu --cpu-max-prime=20000 --threads=$(nproc) run 2>/dev/null | grep 'events per second' | awk '{print $NF}')
  echo "  Single-thread:  ${single:-N/A} events/s"
  echo "  Multi-thread:   ${multi:-N/A} events/s ($(nproc) threads)"
else
  echo -e "  ${YELLOW}sysbench not found. Install: apt install sysbench${NC}"
fi
echo ""

# --- Disk I/O (dd) ---
echo -e "${GREEN}[Disk I/O — dd]${NC}"
echo -n "  Sequential Write (256MB): "
dd_write=$(dd if=/dev/zero of=/tmp/vps-bench-test bs=1M count=256 conv=fdatasync 2>&1 | tail -1)
echo "$dd_write" | awk '{print $(NF-1), $NF}'
echo -n "  Sequential Read  (256MB): "
dd_read=$(dd if=/tmp/vps-bench-test of=/dev/null bs=1M count=256 2>&1 | tail -1)
echo "$dd_read" | awk '{print $(NF-1), $NF}'
rm -f /tmp/vps-bench-test
echo ""

# --- Disk I/O (FIO) ---
echo -e "${GREEN}[Disk I/O — FIO]${NC}"
if command -v fio &>/dev/null; then
  echo "  4K Random Read:"
  fio --name=rand_read --ioengine=libaio --rw=randread --bs=4k --direct=1 \
      --size=256M --numjobs=1 --runtime=10 --group_reporting --minimal 2>/dev/null | \
      awk -F';' '{printf "    IOPS: %s | BW: %.2f MB/s\n", $8, $7/1024}'
  echo "  4K Random Write:"
  fio --name=rand_write --ioengine=libaio --rw=randwrite --bs=4k --direct=1 \
      --size=256M --numjobs=1 --runtime=10 --group_reporting --minimal 2>/dev/null | \
      awk -F';' '{printf "    IOPS: %s | BW: %.2f MB/s\n", $49, $48/1024}'
  rm -f rand_read.0.0 rand_write.0.0
else
  echo -e "  ${YELLOW}fio not found. Install: apt install fio${NC}"
fi
echo ""

# --- Network Latency ---
echo -e "${GREEN}[Network Latency — ping]${NC}"
declare -A TARGETS
TARGETS=(
  ["Cloudflare"]="1.1.1.1"
  ["Google"]="8.8.8.8"
  ["Quad9"]="9.9.9.9"
  ["China Telecom"]="202.96.209.133"
  ["China Unicom"]="221.5.88.88"
)
for name in "${!TARGETS[@]}"; do
  ip="${TARGETS[$name]}"
  latency=$(ping -c 3 -W 2 "$ip" 2>/dev/null | tail -1 | awk -F'/' '{print $5}')
  printf "  %-18s (%s): %sms\n" "$name" "$ip" "${latency:-timeout}"
done
echo ""

# --- Download Speed ---
echo -e "${GREEN}[Download Speed]${NC}"
echo -n "  Cloudflare (25MB):  "
speed_cf=$(curl -so /dev/null -w "%{speed_download}" --connect-timeout 5 --max-time 15 \
  "https://speed.cloudflare.com/__down?bytes=26214400" 2>/dev/null)
printf "%.2f MB/s\n" "$(echo "$speed_cf / 1048576" | bc -l 2>/dev/null || echo 0)"

echo -n "  Hetzner DE (10MB):  "
speed_hz=$(curl -so /dev/null -w "%{speed_download}" --connect-timeout 5 --max-time 15 \
  "https://speed.hetzner.de/10MB.bin" 2>/dev/null)
printf "%.2f MB/s\n" "$(echo "$speed_hz / 1048576" | bc -l 2>/dev/null || echo 0)"
echo ""

# --- Traceroute (China Routes) ---
echo -e "${GREEN}[China Route Detection]${NC}"
if command -v traceroute &>/dev/null || command -v mtr &>/dev/null; then
  echo "  Checking China Telecom route..."
  route=$(traceroute -n -m 15 -w 2 202.96.209.133 2>/dev/null | grep -oE '(4809|4134|9929|58807|9808|56048)' | head -1)
  case "$route" in
    4809) echo -e "  China Telecom: ${GREEN}CN2 GIA (AS4809)${NC} ★★★★★" ;;
    4134) echo -e "  China Telecom: ${YELLOW}163 Backbone (AS4134)${NC} ★★☆☆☆" ;;
    *) echo "  China Telecom: Could not detect route" ;;
  esac
  
  route_cu=$(traceroute -n -m 15 -w 2 221.5.88.88 2>/dev/null | grep -oE '(9929|4837|10099)' | head -1)
  case "$route_cu" in
    9929) echo -e "  China Unicom: ${GREEN}9929 Premium (AS9929)${NC} ★★★★★" ;;
    4837) echo -e "  China Unicom: ${YELLOW}4837 Backbone (AS4837)${NC} ★★★☆☆" ;;
    *) echo "  China Unicom: Could not detect route" ;;
  esac
else
  echo -e "  ${YELLOW}traceroute not found. Install: apt install traceroute${NC}"
fi
echo ""

# --- Summary ---
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  Test Complete!${NC}"
echo -e "${CYAN}  Full benchmark database:${NC}"
echo -e "${CYAN}  https://vpsrankings.com/benchmarks${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo "  For Geekbench 6 tests, run manually:"
echo "  https://www.geekbench.com/download/linux/"
echo ""
echo "  Submit your results or request a provider test:"
echo "  https://github.com/cash602-cmd/vps-bench/issues"
echo ""