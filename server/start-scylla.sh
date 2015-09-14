#!/usr/bin/env bash
set -e

. ./vocabulary.sh

./configure.sh

ulimit -n 1000000 # Open files
ulimit -c unlimited # Core dumps

SCYLLA_OPTS=""

if [[ is_xen && $(n_cpus) != $(n_tx_queues $SERVER_NIC) ]]; then
    # Leave CPU0 for softirq processing, otherwise performance will suffer
    SCYLLA_OPTS="$SCYLLA_OPTS --cpuset 1-$(($(n_cpus) - 1))"
fi

cmd="scylla $SCYLLA_OPTS --data-file-directories=/var/lib/scylla/data --commitlog-directory=/var/lib/scylla/commitlog
    --collectd=1 --collectd-address=$(server_internal_ip $COLLECTD_HOST):25827 --collectd-poll-period 3000 --collectd-host=\"$(hostname)\"
    --log-to-syslog=1 --log-to-stdout=1 -m80G --options-file=./scylla.yaml"

if $(run_in_chroot); then
    echo "Running in chroot"
    cp $SERVER_HOME/scylla.yaml /chroot/f22/root/
    echo "cd /root" > /chroot/f22/root/scylla.sh
    echo "ulimit" >> /chroot/f22/root/scylla.sh
    echo $cmd >> /chroot/f22/root/scylla.sh
    chmod +x /chroot/f22/root/scylla.sh
    nohup chroot /chroot/f22 /root/scylla.sh 2>&1 > scylla.stdout.log < /dev/null &
else
    echo "Not running in chroot"
    echo $cmd > ./scylla.sh
    chmod +x ./scylla.sh
    nohup ./scylla.sh $cmd 2>&1 > scylla.stdout.log < /dev/null &
fi

listen_ip=$(grep listen_address: $SERVER_HOME/scylla.yaml | awk '{print $2}')
port=9160
echo "Waiting for $listen_ip:$port ..."
wait_for_tcp_socket $listen_ip $port
echo "Done."
exit 0
