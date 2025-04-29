#!/bin/bash
set -e

# Habilita forwarding IPv4
echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -P FORWARD ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

exec tail -f /dev/null
