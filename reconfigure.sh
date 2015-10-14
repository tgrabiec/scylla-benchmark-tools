#!/usr/bin/env bash

. ./vocabulary.sh
. ./common-server.sh

./scp-clients.sh config.sh

for name in $SERVERS; do
    N_CPUS=48 # FIXME: dynamic
    export SERVER_INTERNAL_IP=$(server_internal_ip $name)
    export SEEDS=$(seeds)
    export CONCURRENT_WRITES=$((N_CPUS * 8))
    export CONCURRENT_READS=$((N_CPUS * 8))
    export MEMTABLE_FLUSH_WRITERS=12

    ./fill-template.sh server/scylla.yaml.template > server/scylla.yaml
    scp $SCP_OPTS config.sh server/scylla.yaml $SERVER_USER@$(server_external_ip $name):${SERVER_HOME}

    ./fill-template.sh server/cassandra.yaml.template > server/cassandra.yaml
    if $(run_in_chroot); then
        cassandra_conf_dst=/chroot/f22/root/apache-cassandra-$CASSANDRA_VERSION/conf/
    else
        cassandra_conf_dst=${SERVER_HOME}/cassandra/conf/
    fi
    scp $SCP_OPTS server/cassandra.yaml $SERVER_USER@$(server_external_ip $name):$cassandra_conf_dst

    t=$(mktemp)
    export COLLECTD_HOST_INTERNAL_IP=$(server_external_ip $COLLECTD_HOST)
    ./fill-template.sh server/collectd.conf.template > $t
    scp $SCP_OPTS $t $SERVER_USER@$(server_external_ip $name):${SERVER_HOME}/collectd.conf

    unset SERVER_INTERNAL_IP
    unset SEEDS
    unset CONCURRENT_WRITES
done
