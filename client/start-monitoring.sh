#!/usr/bin/env bash

. ./vocabulary.sh

sudo sysctl -w net.core.rmem_default=8388608
sudo sysctl -w net.core.rmem_max=8388608

export COLLECTD_HOST_INTERNAL_IP=$(server_internal_ip $COLLECTD_HOST)
./fill-template.sh collectd.conf.template > collectd.conf
sudo collectd -C collectd.conf
