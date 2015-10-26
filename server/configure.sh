#!/usr/bin/env bash

. ./vocabulary.sh

NR_HUGEPAGES=128
NR_CPUS=$(n_cpus)
NIC=${SERVER_NIC:-eth0}
DISK=${SERVER_DISK:-sda}

# First IRQ of given NIC
function first_irq() {
    ifc=$1
    cat /proc/interrupts | grep $ifc | awk '{print $1}' | cut -d: -f1 | head -1
}

# Last IRQ of given NIC
function last_irq() {
    ifc=$1
    cat /proc/interrupts | grep $ifc | awk '{print $1}' | cut -d: -f1 | tail -1
}

function cpu_mask() {
    cpu=$1
    mask=""
    if ((cpu >= 32)); then
        ((cpu -= 32))
        mask=",0"
    fi
    printf "%x${mask}\n" $((1 << $cpu))
}

function bind_ifc_irqs() {
    ifc=$1
    echo "Binding IRQs of $ifc"
    start=$(first_irq $ifc)
    end=$(last_irq $ifc)
    for (( i = $start , j=0 ; i < $end; i++, j++ )) ; do echo $(cpu_mask $j)  > /proc/irq/$i/smp_affinity ; done
}

function node_cpus() {
    node=$1
    numactl --hardware | grep "node $node cpus" | cut -d: -f2
}

function bind_tx() {
    ifc=$1
    echo "Binding TX queues of $ifc"
    # for i in $(node_cpus 1); do
    for (( i = 0 ; i < $NR_CPUS; i++ )); do
        echo $(cpu_mask $i) > /sys/class/net/$ifc/queues/tx-$i/xps_cpus
        ((i++))
    done
}

function bind_rx() {
    ifc=$1
    echo "Binding RX queues of $ifc"
    for (( i = 0 ; i < $NR_CPUS; i++ )); do
        echo $(cpu_mask $i) > /sys/class/net/$ifc/queues/rx-$i/rps_cpus
        ((i++))
    done
}

function unbond() {
    ifc=$1
    bond=$(grep $ifc /sys/class/net/bond*/bonding/slaves | perl -pe 's/.+(bond\d+)\/.*/$1/')
    if [ -n "$bond" ]; then
        echo "Unbonding $ifc from $bond"
        ip=$(ifconfig $bond | grep "inet " | awk '{print $2}')
        netmask=$(ifconfig $bond | grep "inet " | awk '{print $4}')
        echo "-$ifc" > /sys/class/net/${bond}/bonding/slaves
        echo "-$bond" > /sys/class/net/bonding_masters
        ifconfig $ifc $ip netmask $netmask
    fi
}

# Open files
ulimit -n 1000000

# HUGEPAGES
mount -t hugetlbfs -o pagesize=2097152 none /mnt/huge
mount -t hugetlbfs -o pagesize=2097152 none /dev/hugepages/
for n in /sys/devices/system/node/node?; do
    echo $NR_HUGEPAGES > $n/hugepages/hugepages-2048kB/nr_hugepages;
done

#unbond $NIC

N_TX_QUEUES=$(n_tx_queues $NIC)
N_RX_QUEUES=$(n_rx_queues $NIC)

# RSS affinity
if [[ $N_RX_QUEUES == $NR_CPUS ]]; then
    echo "Binding RX queues"
    killall irqbalance
    bind_ifc_irqs $NIC
    bind_rx $NIC
else
    echo "Not Binding RX queues"
fi

if [[ $N_TX_QUEUES == $NR_CPUS ]]; then
    echo "Binding TX queues"
    bind_tx $NIC
else
    echo "Not Binding TX queues"
fi

# Scaling governor
if [ -e /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]; then
    for (( i = 0 ; i < $NR_CPUS; i++ )); do
        echo performance > /sys/devices/system/cpu/cpu${i}/cpufreq/scaling_governor
    done
else
    echo "No cpufreq"
fi

# Flush page cache
echo 3 > /proc/sys/vm/drop_caches

echo 4096 > /proc/sys/net/core/somaxconn
echo 4096 > /proc/sys/net/ipv4/tcp_max_syn_backlog

echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource

echo deadline > /sys/block/$DISK/queue/scheduler
echo 8 > /sys/class/block/$DISK/queue/read_ahead_kb
echo 0 > /sys/class/block/$DISK/queue/rotational
