#!/usr/bin/env bash
sudo service collectd stop || echo "service not stopped"
sudo killall collectd || echo "collectd not running on $(hostname)"
