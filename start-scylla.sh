#!/usr/bin/env bash

. ./common-server.sh

start_cluster sudo -s LC_ALL=C ./start-scylla.sh
