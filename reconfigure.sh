#!/usr/bin/env bash

. ./vocabulary.sh
. ./common-server.sh

for name in $SERVERS; do
    echo "=== Configuring $name ==="
    N_CPUS=48 # FIXME: dynamic
    export SERVER_INTERNAL_IP=$(server_internal_ip $name)
    export SEEDS=$(seeds)
    export CONCURRENT_WRITES=$((N_CPUS * 8))
    export CONCURRENT_READS=$((N_CPUS * 8))
    export MEMTABLE_FLUSH_WRITERS=12
    export COLLECTD_HOST_INTERNAL_IP=$(server_external_ip $COLLECTD_HOST)
    export M1_TOOLS_HOSTNAME=$name

    t=$(mktemp)
    ./fill-template.sh server/scylla.yaml.template > $t
    scp $SCP_OPTS $t $SERVER_USER@$(server_external_ip $name):${SERVER_HOME}/scylla.yaml
    scp $SCP_OPTS config.sh $SERVER_USER@$(server_external_ip $name):${SERVER_HOME}/scylla.yaml
    rm $t

    ./fill-template.sh server/cassandra.yaml.template > server/cassandra.yaml
    if $(run_in_chroot); then
        cassandra_conf_dst=/chroot/f22/root/apache-cassandra-$CASSANDRA_VERSION/conf/
    else
        cassandra_conf_dst=${SERVER_HOME}/cassandra/conf/
    fi
    scp $SCP_OPTS server/cassandra.yaml $SERVER_USER@$(server_external_ip $name):$cassandra_conf_dst

    t=$(mktemp)
    ./fill-template.sh server/collectd.conf.template > $t
    scp $SCP_OPTS $t $SERVER_USER@$(server_external_ip $name):${SERVER_HOME}/collectd.conf
    rm $t

    unset SERVER_INTERNAL_IP
    unset SEEDS
    unset CONCURRENT_WRITES
    unset COLLECTD_HOST_INTERNAL_IP
    unset M1_TOOLS_HOSTNAME
done

./scp-clients.sh config.sh

for name in $CLIENTS; do
    echo "=== Configuring $name ==="
    t=$(mktemp)
    export COLLECTD_HOST_INTERNAL_IP=$(server_internal_ip $COLLECTD_HOST)
    export M1_TOOLS_HOSTNAME=$name
    ./fill-template.sh client/collectd.conf.template > $t
    scp $SCP_OPTS $t $CLIENT_USER@$(server_external_ip $name):${CLIENT_HOME}/collectd.conf
done
