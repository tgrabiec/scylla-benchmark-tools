#!/usr/bin/env bash
set -e

. ./vocabulary.sh

./stop-scylla.sh

if $(run_in_chroot); then
    ./invoke-on-servers.sh sudo rm -rf /chroot/f22/var/lib/scylla/data /chroot/f22/var/lib/scylla/commitlog
else
    ./invoke-on-servers.sh sudo rm -rf $DATA_DIR/data $DATA_DIR/commitlog
fi

./start-scylla.sh
