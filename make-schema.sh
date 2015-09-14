#!/usr/bin/env bash

. ./vocabulary.sh

RF=${RF:-1}

echo "Using RF=$RF"

ssh $SSH_OPTS $CLIENT_USER@$(some_client) "RF=$RF ./make_schema.sh"
