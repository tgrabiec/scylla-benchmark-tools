#!/usr/bin/env bash

file=$1

. ./config.sh

eval "cat <<EOF
$(<$file)
EOF
" 2> /dev/null
