#!/usr/bin/env bash
set -e

. ./vocabulary.sh

# FIXME: yum doesn't work with bonding removed

./common_setup.sh

sudo yum install -y scylla-server scylla-tools scylla-jmx
#
#yum install -y java-1.8.0-openjdk.x86_64 ntp unzip
#wget -N http://apache.spd.co.il//cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz
#tar xpzf apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz
#ln -s apache-cassandra-$CASSANDRA_VERSION cassandra
#pushd cassandra
#wget -N http://heanet.dl.sourceforge.net/project/mx4j/MX4J%20Binary/3.0.2/mx4j-3.0.2.zip
#unzip mx4j-3.0.2.zip mx4j-3.0.2/lib/mx4j-tools.jar
#mv mx4j-3.0.2/lib/mx4j-tools.jar lib
#popd


./setup-monitoring.sh
