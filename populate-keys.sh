#!/usr/bin/env bash

#
# Usage: ./populate-keys.sh count [ offset ]
#

. ./vocabulary.sh

TOTAL=$1
RANGE_START=${2:-0}

if [ -z "$TOTAL" ]; then
    echo "Usage: ./populate-keys RANGE"
    exit 1
fi

PER_CLIENT=$(( (TOTAL + N_CLIENTS - 1)/ N_CLIENTS))

wait_begin
for name in $CLIENTS; do
    range=$RANGE_START..$((RANGE_START + PER_CLIENT))
    echo "$name: $range"
    ssh $SSH_OPTS $CLIENT_USER@$(server_external_ip $name) ./populate-keys.sh $RANGE_START $PER_CLIENT &
    wait_add $!
    ((RANGE_START += PER_CLIENT))
done
wait_join
