#!/usr/bin/env bash
set -e

. ./vocabulary.sh

./common_setup.sh

sudo yum install -y scylla-tools scylla-jmx ntp

# yum -q install -y java-1.8.0-openjdk.x86_64
# wget -N --quiet http://apache.spd.co.il//cassandra/2.1.9/apache-cassandra-2.1.9-bin.tar.gz
# tar xpzf apache-cassandra-2.1.9-bin.tar.gz

# Replace driver
# cp cassandra-driver-core-2.0.9.2.jar apache-cassandra-2.1.9/tools/lib
# cp cassandra-stress apache-cassandra-2.1.9/tools/bin

sudo service firewalld stop || echo "firewalld not stopped"

sudo ntpdate time.apple.com

./setup-monitoring.sh

sudo bash -c "echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource"
