#!/usr/bin/env bash

. ./vocabulary.sh

wait_begin
for name in $SERVERS; do
    ssh $SSH_OPTS $SERVER_USER@$(server_external_ip $name) NAME=$name $@ &
    wait_add $!
done
wait_join
