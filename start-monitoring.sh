#!/usr/bin/env bash

set -e

. ./vocabulary.sh

ssh $SSH_OPTS $CLIENT_USER@$(server_external_ip $COLLECTD_HOST) ./start-monitoring-master.sh
./invoke-on-clients.sh ./start-monitoring.sh
./start-monitoring-on-servers.sh
