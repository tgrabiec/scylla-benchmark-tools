#!/usr/bin/env bash
set -e

sudo service scylla-server stop || echo "Service not stopped"
sudo killall -9 scylla || echo "Not running on $(hostname)"
