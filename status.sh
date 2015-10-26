#!/usr/bin/env bash

. ./vocabulary.sh

echo "=== Load driver status ==="

wait_begin
for name in $CLIENTS; do
    ssh $SSH_OPTS $CLIENT_USER@$(server_external_ip $name) pgrep java > /dev/null
    echo -n $name ": "
    if [ $? == 0 ]; then
    	echo "UP"
    else
    	echo "DOWN"
    fi
    pids[${i}]=$!
done
wait_join
