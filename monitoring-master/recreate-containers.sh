#!/usr/bin/env bash

./stop-monitoring-master.sh
sudo docker stop tessera
sudo docker stop graphite
sudo docker rm tessera
sudo docker rm graphite
./create-containers.sh
./start-monitoring-master.sh
