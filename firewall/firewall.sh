#!/bin/bash

# Limpa regras
iptables -F
iptables -t nat -F
iptables -X

# Configura política padrão - mais permissiva para testes
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Loopback e conexões estabelecidas
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Permitir ICMP (ping)
iptables -A INPUT -p icmp -j ACCEPT

# Permitir tráfego entre as redes servers e clients
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

# NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Mantém container vivo
echo "Firewall configurado."
exec tail -f /dev/null
    