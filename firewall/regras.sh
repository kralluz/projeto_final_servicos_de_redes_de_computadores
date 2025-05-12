#!/bin/sh
set -e

# Limpa regras existentes
iptables -F && iptables -X
iptables -t nat -F && iptables -t nat -X

# Políticas padrão
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# Permite tráfego estabelecido/relacionado
iptables -A INPUT  -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Loopback e ICMP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Serviços liberados
for PORT in 22 53 80 443; do
  iptables -A INPUT -p tcp --dport $PORT -j ACCEPT
done
iptables -A INPUT -p udp --dport 53 -j ACCEPT  # DNS UDP

# Libera tráfego interno entre sub‑redes
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

tail -f /dev/null 