#!/usr/bin/env bash

. ./vocabulary.sh

function seed_names() {
    local server_array
    read -a server_array <<< $SERVERS
    echo ${server_array[0]}
}

function seeds() {
    local server_array
    read -a server_array <<< $SERVERS
    echo $(server_internal_ip ${server_array[0]})
}

function is_seed() {
    name=$1
    if [[ $(seeds) == *$(server_internal_ip $name)* ]]; then
        return 0
    else
        return 1
    fi
}

function start_cluster() {
    local start_script_name=$@

    for name in $(seed_names); do
        echo "Starting seed ($name) "
        ssh $SSH_OPTS $SERVER_USER@$(server_external_ip $name) $start_script_name
    done

    for name in $SERVERS; do
        if is_seed $name; then
            echo "Skipping seed node $name"
        else
            echo "Starting on $name"
            ssh $SSH_OPTS $SERVER_USER@$(server_external_ip $name) $start_script_name
        fi
    done
}
