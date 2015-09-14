#!/usr/bin/env bash
set -e

. ./vocabulary.sh

wait_begin
for name in $SERVERS; do
    scp $SCP_OPTS "$@" $SERVER_USER@$(server_external_ip $name):$SERVER_HOME &
    wait_add $!
done
wait_join
