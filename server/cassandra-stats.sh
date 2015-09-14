#!/bin/bash

statsfile=/tmp/storage_proxy.stats
cfstatsfile=/tmp/column_family.standard1.stats

HOSTNAME="${COLLECTD_HOSTNAME:-localhost}"
INTERVAL="${COLLECTD_INTERVAL:-60}"
CONNECT_TO=$1

while sleep "$INTERVAL"; do
    curl -s -X GET "http://$CONNECT_TO:8081/mbean?objectname=org.apache.cassandra.db:type=StorageProxy" > $statsfile
    writes=$(grep WriteOperations < $statsfile | perl -pe 's/.+>(\d+)<.*/$1/')
    reads=$(grep ReadOperations < $statsfile | perl -pe 's/.+>(\d+)<.*/$1/')
    total=$((writes + reads))

    curl -s -X GET "http://$CONNECT_TO:8081/mbean?objectname=org.apache.cassandra.db%3Atype%3DColumnFamilies%2Ckeyspace%3Dkeyspace1%2Ccolumnfamily%3Dstandard1" > $cfstatsfile
    standard1_write_count=$(grep WriteCount < $cfstatsfile | perl -pe 's/.+>(\d+)<.*/$1/')

    echo "PUTVAL $HOSTNAME/cassandra-0/total_operations-writes N:$writes"
    echo "PUTVAL $HOSTNAME/cassandra-0/total_operations-reads N:$reads"
    echo "PUTVAL $HOSTNAME/cassandra-0/total_operations-all N:$total"
    echo "PUTVAL $HOSTNAME/cassandra-0/total_operations-cf-writes N:$standard1_write_count"
done
