#!/usr/bin/env bash
docker inspect graphite | grep opt/graphite | grep docker/volumes | tr '",' '  ' | awk '{print  $3}'
