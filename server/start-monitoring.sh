#!/usr/bin/env bash

set -e

sudo mkdir -p /usr/share/collectd/plugins/
sudo chown collectd: /usr/share/collectd/plugins/ || echo "Failed to chown /usr/share/collectd/plugins/ to collectd"
sudo cp ./cassandra-stats.sh /usr/share/collectd/plugins/cassandra-stats.sh
./start-collectd.sh
