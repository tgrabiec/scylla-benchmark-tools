#!/bin/sh
set -e

. ./vocabulary.sh

sudo yum install -y collectd collectd-write_riemann collectd-netlink
sudo yum install -y psmisc sysstat lsof perf tcpdump tcpreplay git net-tools

sudo useradd collectd || echo "Failed to add 'collectd' user"

# mkdir -p src
# cd src
# rm -rf FlameGraph
# git clone https://github.com/brendangregg/FlameGraph
