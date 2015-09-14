#!/usr/bin/env bash

. ./vocabulary.sh

./invoke-on-clients.sh ./stop-monitoring.sh
./stop-monitoring-on-servers.sh
ssh $SSH_OPTS $CLIENT_USER@$(server_external_ip $COLLECTD_HOST) ./stop-monitoring-master.sh