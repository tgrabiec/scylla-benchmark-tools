#!/usr/bin/env bash
set -e

. ./vocabulary.sh

function strip {
    local arg=$1
    echo -n $arg | tr -d '\n' | tr -d '\r'
}

function fetch_whisper_file {
    local metric=$1
    local dst=$(dirname $dir/whisper/$metric.wsp)
    mkdir -p $dst
    scp $SCP_OPTS $CLIENT_USER@$(server_external_ip $COLLECTD_HOST):$graphite_conf_dir/storage/whisper/$metric.wsp $dst || echo "Metric not found: $metric"
}

if [ -n "$1" ]; then
    id=$1
else
    id=$(date +%Y-%m-%d-%T)
fi

dir=results/$id

mkdir -p $dir

echo "Saving to $dir..."

graphite_conf_dir=$(strip $(ssh $SSH_OPTS $CLIENT_USER@$(server_external_ip $COLLECTD_HOST) ./get-graphite-conf-dir.sh))
fetch_whisper_file cassandra/total_operations-all
fetch_whisper_file cassandra/total_operations-reads
fetch_whisper_file cassandra/total_operations-writes
fetch_whisper_file transport/total_requests_served

wait_begin
for name in $CLIENTS; do
    mkdir -p $dir/$name
    scp $SCP_OPTS $CLIENT_USER@$(server_external_ip $name):$CLIENT_HOME/out-1.log $dir/$name/out-1.log || echo "scp failed from $name" &
    wait_add $!
done
wait_join

