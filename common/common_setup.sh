#!/usr/bin/env bash
set -e

. ./vocabulary.sh

NAME=$(distro_name)

if [[ $NAME == "Fedora" || $NAME == "Red Hat Enterprise Linux Server" ]]; then
    sudo cp scylla.fedora.repo /etc/yum.repos.d/
elif [[ $NAME == "CentOS Linux" ]]; then
    sudo cp scylla.centos.repo /etc/yum.repos.d/
    sudo yum install -y epel-release
else
    echo "Unsupported distribution: $NAME"
    exit 1
fi
