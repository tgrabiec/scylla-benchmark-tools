#!/usr/bin/env bash

./stop-monitoring.sh

for p in $(ps -ef | grep riemann | grep -v grep | awk '{print $2}'); do kill $p; done

sudo docker stop tessera
sudo docker stop graphite
