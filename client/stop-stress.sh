#!/usr/bin/env bash

. ./stress-common.sh

pid=$(stress_pid)
if [ -n "$pid" ]; then
	kill $pid
else
	echo "Not running on $(hostname)"
fi
