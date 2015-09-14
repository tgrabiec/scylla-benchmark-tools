#!/usr/bin/env python
import sys
import os
import subprocess

def pin(regex, cpu):
    print('Pinning \'%s\' to CPU %d' % (regex, cpu))
    subprocess.check_call(['taskset -cap %d $(pgrep %s)' % (cpu, regex)], shell=True)

def pin_to_range(regex, first, last):
    print('Pinning \'%s\' to CPUs %d-%d' % (regex, first, last))
    subprocess.check_call(['taskset -cap %d-%d $(pgrep %s)' % (first, last, regex)], shell=True)

def is_present(regex):
    return subprocess.check_output(['pgrep %s' % regex + ' || exit 0'], shell=True)

def pin_if_present(regex, cpu):
    if is_present(regex):
        pin(regex, cpu)
    else:
        print('No \'%s\' running' % regex)

def pin_irq(irq, cpu):
    print('Pinning IRQ %d to CPU %d' % (irq, cpu))
    with open('/proc/irq/%d/smp_affinity_list' % irq, 'w') as f:
        f.write(str(cpu))

def interface_irqs(interface):
    with open('/proc/interrupts', 'r') as f:
        for line in f:
            if interface in line:
                yield int(line.split(':')[0])

if __name__ == "__main__":
    nic = sys.argv[1]

    cpus_for_app = 15
    irq_cpus = 1

    cpu = 0

    # for app in ['java']:
    #     if is_present(app):
    #         pin_to_range(app, cpu, cpu + cpus_for_app - 1)
    #         cpu += cpus_for_app

    if is_present('irqbalance'):
        print('Stopping irqbalance')
        subprocess.check_call(['killall', 'irqbalance'])

    irqs = list(interface_irqs(nic))
    if not irqs:
        print('No IRQs found for ' + nic)
    else:
        first_irq_cpu = cpu
        i = 0
        for irq in interface_irqs(nic):
            pin_irq(irq, first_irq_cpu + i % irq_cpus)
            i += 1
        cpu += irq_cpus

    # pin('vhost', cpu)
    cpu += 1
