#!/usr/bin/env bash
set -e

killall java || echo "Not running on $(hostname)"
