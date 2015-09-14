#!/usr/bin/env bash
set -e

. ./config.sh

function collect {
    local name=$1
    ./collect-results.sh $name
    echo "Collected $name:"
    ./result_summary $name
}

function run_all {
    echo "=== Benchmarking $SERVER with RF=$RF CL=$CL DURATION=$DURATION ==="

    local date=$(date +%Y-%m-%d-%T)

   echo "=== Starting write-only benchmark ==="
  ./restart-$SERVER-fresh.sh
  ./start-write.sh
  collect $SERVER-write-rf$RF-cl-$CL-$date

   echo "=== Starting read-only benchmark ==="
   ./restart-$SERVER-fresh.sh
   ./start-read.sh
   collect $SERVER-read-rf$RF-cl-$CL-$date

    echo "=== Starting mixed benchmark ==="
    ./restart-$SERVER-fresh.sh
    ./start-mixed.sh
    collect $SERVER-mixed-rf$RF-cl-$CL-$date

    ./stop-$SERVER.sh
}

export RF=${RF:-1}
export CL=${CL:-ONE}
export DURATION=${DURATION:-15m}
export SERVER=${SERVER:-none}

if [ $SERVER == none ]; then
    echo "SERVER env variable must be set"
    exit 1
fi

run_all
