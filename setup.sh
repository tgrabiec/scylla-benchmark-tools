#!/usr/bin/env bash
set -e

. ./vocabulary.sh

./sync.sh
./setup-clients.sh
./setup-servers.sh
./setup-monitoring.sh
./reconfigure.sh
