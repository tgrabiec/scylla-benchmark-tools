#!/usr/bin/env bash

set -e

. ./vocabulary.sh

COMMON_FILES="fill-template.sh vocabulary.sh config.sh $(find common -mindepth 1)"
CLIENT_FILES="$COMMON_FILES $(find client -mindepth 1)"
SERVER_FILES="$COMMON_FILES $(find server -mindepth 1)"

echo "Syncing servers..."
./scp-servers.sh $SERVER_FILES

echo "Syncing clients..."
./scp-clients.sh $CLIENT_FILES

echo "Syncing monitornig master..."
scp -r $SCP_OPTS $CLIENT_FILES monitoring-master/* $CLIENT_USER@$(server_external_ip $COLLECTD_HOST):/root
