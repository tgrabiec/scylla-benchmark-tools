#!/usr/bin/env bash

set -e

. ./vocabulary.sh

for name in $SERVERS; do
    address=$(server_external_ip $name)
    export SERVER_INTERNAL_IP=$(server_internal_ip $name)
    t=$(mktemp)
    ./fill-template.sh server/collectd.conf.template > $t
    unset SERVER_INTERNAL_IP
    scp $SCP_OPTS $t $SERVER_USER@${address}:${SERVER_HOME}/collectd.conf
    ssh $SSH_OPTS $SERVER_USER@${address} sudo mkdir -p /usr/share/collectd/plugins/ && sudo chown collectd: /usr/share/collectd/plugins/
    scp $SCP_OPTS server/cassandra-stats.sh $SERVER_USER@${address}:/usr/share/collectd/plugins/cassandra-stats.sh
    ssh $SSH_OPTS $SERVER_USER@${address} ${SERVER_HOME}/start-collectd.sh
done
