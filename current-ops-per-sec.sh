#!/usr/bin/env bash

. ./vocabulary.sh

invoke_on_clients_parallel ./current-ops-per-sec.sh | awk '{ sum+=$1 } END { print sum }'
