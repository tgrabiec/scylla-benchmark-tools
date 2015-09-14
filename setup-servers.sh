#!/usr/bin/env bash
set -e

. ./vocabulary.sh

function setup_server {
    name=$1
    address=$(server_external_ip $name)
    ssh $SSH_OPTS $SERVER_USER@${address} ${SERVER_HOME}/setup.sh
}

wait_begin
for s in $SERVERS; do
    setup_server $s &
    wait_add $!
done
wait_join
