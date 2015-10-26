#!/usr/bin/env bash
set -e

. ./vocabulary.sh

function setup_client {
    name=$1
    echo "Setting up $name"
    ssh $SSH_OPTS $CLIENT_USER@$(server_external_ip $name) ./setup.sh
}

wait_begin
for name in $CLIENTS; do
    setup_client $name &
    wait_add $!
done
wait_join
