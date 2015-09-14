#!/usr/bin/env bash
set -e

. ./vocabulary.sh

for name in $SERVERS; do
    ssh $SSH_OPTS $SERVER_USER@$(server_external_ip $name) ./stop-cassandra.sh
done
