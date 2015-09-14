#!/usr/bin/env bash

. ./stress-common.sh

if [ -n "$(stress_pid)" ]; then
	tail -q -n 1 out* | awk '{print $3}' | cut -d, -f1 | awk '{ sum+=$1 } END { print sum }'
else
	echo "0"
fi
