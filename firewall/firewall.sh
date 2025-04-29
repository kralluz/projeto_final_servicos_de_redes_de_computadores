#!/bin/bash
set -e

# Limpa regras
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Loopback e conexões estabelecidas
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# DNS
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# DHCP (cliente/servidor)
iptables -A INPUT -p udp --dport 67:68 -j ACCEPT

# LDAP
iptables -A INPUT -p tcp --dport 389 -j ACCEPT

# Samba
iptables -A INPUT -p tcp --dport 445 -j ACCEPT

# FTP
iptables -A INPUT -p tcp --dport 21 -j ACCEPT

# HTTP
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Mantém container vivo
exec tail -f /dev/null
    