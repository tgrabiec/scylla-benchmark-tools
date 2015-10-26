#!/usr/bin/env bash

. ./vocabulary.sh

sudo sysctl -w net.core.rmem_default=8388608
sudo sysctl -w net.core.rmem_max=8388608

sudo collectd -C collectd.conf
