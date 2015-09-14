#!/usr/bin/env bash

sudo docker stop tessera
sudo docker stop graphite
sudo docker rm tessera
sudo docker rm graphite
./create-containers.sh
