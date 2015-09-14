#!/usr/bin/env bash
set -e

range_start=$1
count=$2
range_end=$((range_start + count))

. ./vocabulary.sh

rm -f out-*

cassandra-stress write n=$count cl=ALL -pop "seq=$range_start..$range_end"  -mode native cql3 -rate threads=500 \
     -node $SERVER_INTERNAL_IP_CSV -log file=populate.log 2>&1 > populate.stdout.log

# apache-cassandra-2.1.8/tools/bin/cassandra-stress write n=$count -pop "seq=$range_start..$range_end"  -mode native cql3 -rate threads=700 \
#      -node $SERVER_INTERNAL_IP -log file=out-1.log

#cassandra-stress user profile=dml.yaml ops\(insert=1\) n=$count -pop "seq=$range_start..$range_end" -node $SERVER_INTERNAL_IP \
#    -rate threads=700  -mode native cql3 -log file=out-1.log 2>&1 > stdout.log
