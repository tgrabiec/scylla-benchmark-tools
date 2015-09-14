#!/usr/bin/env bash
set -e

. ./vocabulary.sh

./stop-cassandra.sh

if $(run_in_chroot); then
    ./invoke-on-servers.sh rm -rf /chroot/f22/root/apache-cassandra-${CASSANDRA_VERSION}/data/*
else
    ./invoke-on-servers.sh rm -rf $SERVER_HOME/cassandra/data/*
fi

./start-cassandra.sh
