#!/usr/bin/env bash

set -e

. ./vocabulary.sh

RF=${RF:-1}
CL=${CL:-ONE}
DURATION=${DURATION:-15m}

echo "RF=$RF CL=$CL DURATION=$DURATION"

RF=$RF ./make-schema.sh
./populate-keys.sh 100000000
sleep 15 # So that result_summary can distinguish the main run from the populate run
./invoke-on-clients.sh CL=$CL DURATION=$DURATION ./start-mixed.sh
