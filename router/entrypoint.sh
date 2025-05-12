#!/bin/bash

echo "Iniciando configuração do router..."

# Habilita forwarding IPv4
echo 1 > /proc/sys/net/ipv4/ip_forward

# Limpa regras existentes (ignora erros)
iptables -F || true
iptables -t nat -F || true
iptables -X || true

# Configura política padrão
iptables -P FORWARD ACCEPT || true
iptables -P INPUT ACCEPT || true
iptables -P OUTPUT ACCEPT || true

# Identifica interfaces e IPs (eth0 é a interface principal)
echo "Configurando informações das interfaces..."
SERVER_IF="eth0"
SERVER_NET="192.168.10.0/24"
CLIENT_NET="192.168.20.0/24"

# Configura IPs nas interfaces (usando os IPs definidos no docker-compose)
ip addr add 192.168.10.254/24 dev $SERVER_IF || true
ip addr add 192.168.20.254/24 dev $SERVER_IF || true

# Adiciona rotas estáticas
echo "Configurando rotas..."
ip route add $SERVER_NET dev $SERVER_IF src 192.168.10.254 || true
ip route add $CLIENT_NET dev $SERVER_IF src 192.168.20.254 || true

# Permite roteamento entre redes
echo "Configurando regras de encaminhamento..."
iptables -A FORWARD -s $CLIENT_NET -d $SERVER_NET -j ACCEPT || true
iptables -A FORWARD -s $SERVER_NET -d $CLIENT_NET -j ACCEPT || true

# Configura NAT
echo "Configurando NAT..."
iptables -t nat -A POSTROUTING -s $CLIENT_NET -j MASQUERADE || true
iptables -t nat -A POSTROUTING -s $SERVER_NET -j MASQUERADE || true

# Exibe configuração
echo "Configuração atual:"
ip addr show
echo -e "\nRotas configuradas:"
ip route
echo -e "\nRegras de firewall:"
iptables -L -v -n
echo -e "\nRegras de NAT:"
iptables -t nat -L -v -n

echo "Router configurado com sucesso. Aguardando..."

# Mantém o container em execução
sleep infinity
