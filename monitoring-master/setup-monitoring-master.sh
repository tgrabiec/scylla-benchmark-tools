#!/usr/bin/env bash

set -e

. ~/vocabulary.sh

./setup.sh
./setup-monitoring.sh

sudo yum install -y docker
sudo service docker start

./create-containers.sh
