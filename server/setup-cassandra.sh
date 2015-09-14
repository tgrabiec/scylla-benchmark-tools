#!/usr/bin/env bash

# Run in cassandra directory

. ~/config.sh

N_CPUS=48

sed -i "s/1.2.3.4/$SERVER_INTERNAL_IP/" conf/cassandra.yaml
sed -i "s/127.0.0.1/$SERVER_INTERNAL_IP/" conf/cassandra.yaml
sed -i "s/localhost/$SERVER_INTERNAL_IP/" conf/cassandra.yaml
sed -i "s/concurrent_writes: .*/concurrent_writes: $((8 * $N_CPUS))/" conf/cassandra.yaml
