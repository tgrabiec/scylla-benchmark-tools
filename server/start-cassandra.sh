#!/usr/bin/env bash
set -e

. ./vocabulary.sh

./configure.sh
ulimit -n 1000000

if $(run_in_chroot); then
    echo "Running in chroot"
    cat > /chroot/f22/root/cassandra.sh <<EOF
cd /root/apache-cassandra-${CASSANDRA_VERSION}
export JVM_OPTS
bin/cassandra
EOF
    conf_dir=/root/apache-cassandra-${CASSANDRA_VERSION}/conf
    chmod +x /chroot/f22/root/cassandra.sh
    nohup chroot /chroot/f22 /root/cassandra.sh 2>&1 > cassandra.stdout.log < /dev/null &
else
    conf_dir=./conf
    echo "Not running in chroot"
    cd cassandra
    nohup bin/cassandra 2>&1 > stdout.log < /dev/null &
fi

listen_ip=$(grep listen_address: $conf_dir/cassandra.yaml | cut -d: -f2)
port=9160

echo "Waiting for $listen_ip:$port ..."
wait_for_tcp_socket $listen_ip $port
