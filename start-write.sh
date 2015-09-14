#!/usr/bin/env bash

. ./vocabulary.sh

#RF=3
#CL=QUORUM

RF=${RF:-1}
CL=${CL:-ONE}
DURATION=${DURATION:-15m}

echo "RF=$RF CL=$CL DURATION=$DURATION"

RF=$RF ./make-schema.sh
./invoke-on-clients.sh CL=$CL DURATION=$DURATION ./start-write.sh
