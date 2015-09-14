#!/usr/bin/env bash
set -e

. ./vocabulary.sh

CL=${CL:-ONE}
DURATION=${DURATION:-15m}

./pin-irq.py eth0

rm -f out-*

taskset -c 1-15 cassandra-stress mixed cl=$CL duration=$DURATION 'ratio(read=1,write=1)' -pop 'dist=gauss(1..10000000,5000000,500000)' \
     -mode native cql3 -rate threads=700 -node $SERVER_INTERNAL_IP_CSV -log file=out-1.log 2>&1 > stdout.log </dev/null
