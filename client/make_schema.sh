#!/usr/bin/env bash
set -e

. ./vocabulary.sh

RF=${RF:-3}

cassandra-stress write n=1 cl=ALL -schema "replication(factor=$RF)" -mode native cql3 -node $SERVER_INTERNAL_IP_CSV
