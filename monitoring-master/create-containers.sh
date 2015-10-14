#!/usr/bin/env bash

. ./vocabulary.sh

sudo docker create \
  --name graphite \
  --restart=always \
  -p 127.0.0.1:80:80 \
  -p $(server_internal_ip $COLLECTD_HOST):2003:2003 \
  -p 127.0.0.1:2003:2003 \
  -p $(server_internal_ip $COLLECTD_HOST):8125:8125/udp \
  -p 127.0.0.1:8125:8125/udp \
  hopsoft/graphite-statsd

graphite_conf_dir=$(./get-graphite-conf-dir.sh)
cp -rf graphite/storage-schemas.conf $graphite_conf_dir/conf/
cp -rf graphite/carbon.conf $graphite_conf_dir/conf/
cp -rf graphite/blacklist.conf $graphite_conf_dir/conf/
cp -f graphite/settings.py $graphite_conf_dir/webapp/graphite
cp -f graphite/local_settings.py $graphite_conf_dir/webapp/graphite

docker create \
 -p 127.0.0.1:8080:80 \
 --name tessera \
 -e GRAPHITE_URL=http://127.0.0.1 \
 -it \
 aalpern/tessera-simple
