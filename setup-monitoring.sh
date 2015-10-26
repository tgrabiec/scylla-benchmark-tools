#!/usr/bin/env bash

. ./vocabulary.sh

ssh $SSH_OPTS $CLIENT_USER@$(server_external_ip $COLLECTD_HOST) ./setup-monitoring-master.sh
