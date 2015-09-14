#!/usr/bin/env bash

sudo sysctl -w net.core.rmem_default=8388608
sudo sysctl -w net.core.rmem_max=8388608

./fill-template.sh collectd.conf.template > collectd.conf
sudo collectd -C collectd.conf
