#!/bin/bash

# Habilita o encaminhamento de pacotes
echo 1 > /proc/sys/net/ipv4/ip_forward

# Limpa todas as regras existentes
iptables -F
iptables -X
iptables -t nat -F
iptables -t mangle -F

# Define as políticas padrão
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Permite tráfego na interface loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permite conexões estabelecidas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permite NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Permite encaminhamento entre interfaces
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

echo "Firewall configurado com sucesso!"
    