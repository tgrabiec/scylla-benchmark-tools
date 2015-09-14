#!/usr/bin/env bash
set -e

yum install -y bzip2

wget -N https://aphyr.com/riemann/riemann-0.2.10.tar.bz2
tar xvfj riemann-0.2.10.tar.bz2
mv riemann-0.2.10/etc/riemann.config riemann-0.2.10/etc/riemann.config.old || true
cp -f riemann.config riemann-0.2.10/etc/
