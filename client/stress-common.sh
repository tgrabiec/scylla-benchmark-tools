#!/usr/bin/env bash

function stress_pid() {
	ps -ef | grep stress.jar | grep -v grep | awk '{print $2}'
}
