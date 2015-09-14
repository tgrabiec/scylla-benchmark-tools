#!/usr/bin/env bash

set -e

. ./vocabulary.sh

./start-collectd-sink.sh
./start-riemann.sh

docker start graphite
docker start tessera

wait_for_tcp_socket 127.0.0.1 8080
sleep 2 # wait for tessera

echo "Creating dashboard definitions..."

curl -X POST -H 'Content-Type: application/json' -d @scylla-dashboard.json http://localhost:8080/api/dashboard/
curl -X POST -H 'Content-Type: application/json' -d @cassandra-dashboard.json http://localhost:8080/api/dashboard/
