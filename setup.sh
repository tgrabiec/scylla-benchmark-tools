#!/usr/bin/env bash
set -e

. ./vocabulary.sh

./sync.sh
./setup-clients.sh
./setup-servers.sh
./setup_monitoring.sh
./reconfigure.sh
