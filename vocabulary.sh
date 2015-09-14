#!/usr/bin/env bash

if [ ! -e config.sh ]; then
    echo "Please copy config.sh.template into config.sh and fill it in"
fi

. ./config.sh

N_CLIENTS=0
for c in $CLIENTS; do ((N_CLIENTS += 1)); done

N_SERVERS=0
for c in $SERVERS; do ((N_SERVER += 1)); done

function some_client {
    echo $CLIENTS | cut -d" " -f1
}

function wait_begin {
    unset pids
}

function wait_join {
    for pid in ${pids}; do
        wait $pid
    done
}

function wait_add {
    pids="$pids $1"
}

function scp_clients {
    wait_begin
    for name in $CLIENTS; do
        scp $SCP_OPTS $@ $CLIENT_USER@$name:$CLIENT_HOME &
        wait_add $!
    done
    wait_join
}

function invoke_on_clients {
    for name in $CLIENTS; do
        ssh $SSH_OPTS $CLIENT_USER@$name $@
    done
}

function invoke_on_clients_parallel {
    wait_begin
    for name in $CLIENTS; do
        ssh $SSH_OPTS $CLIENT_USER@$name $@ &
        wait_add $!
    done
    wait_join
}

function server_external_ip {
    name=$1
#    name=$(echo $1 | tr '[:lower:]' '[:upper:]')
    holder=${name}_SERVER_EXTERNAL_IP
    eval val=\$$holder
    echo $val
}

function server_internal_ip {
    name=$1
    holder=${name}_SERVER_INTERNAL_IP
    eval val=\$$holder
    echo $val
}

function wait_for_tcp_socket {
    ip=$1
    port=$2
    pid=$3
    while [ -z "$(netstat -ltn | grep ${ip}:${port})" ] ; do
        sleep 0.5
    done
}

SERVER_INTERNAL_IP_CSV=""
for name in $SERVERS; do
    if [ -n "$SERVER_INTERNAL_IP_CSV" ]; then
        SERVER_INTERNAL_IP_CSV="${SERVER_INTERNAL_IP_CSV},"
    fi
    SERVER_INTERNAL_IP_CSV="${SERVER_INTERNAL_IP_CSV}$(server_internal_ip $name)"
done

function distro_name {
    eval $(cat /etc/*-release | grep ^NAME=)
    echo $NAME
}

function n_cpus {
    lscpu | grep ^CPU\(s\) | awk '{print $2}'
}

function is_xen {
    if [ -n "$(dmesg | grep -i xen)" ]; then
        return 0
    else
        return 1
    fi
}

function n_tx_queues {
    NIC=$1
    ls /sys/class/net/$NIC/queues/ | grep tx | wc -l
}

function n_rx_queues {
    NIC=$1
    ls /sys/class/net/$NIC/queues/ | grep tx | wc -l
}

function run_in_chroot {
    if [ "$RUN_IN_CHROOT" == "y" ]; then
        return 0
    else
        return 1
    fi
}
