#!/usr/bin/env bash

. ./vocabulary.sh

eval `ssh-agent`
ssh-add

wait_begin

ssh $SSH_OPTS -L 5556:localhost:5556 -N root@$(server_external_ip $COLLECTD_HOST) &
wait_add $!

ssh $SSH_OPTS -L 8080:localhost:8080 -N root@$(server_external_ip $COLLECTD_HOST) &
wait_add $!

sudo -E ssh $SSH_OPTS -L 80:localhost:80 -N root@$(server_external_ip $COLLECTD_HOST) &
wait_add $!

wait_join
