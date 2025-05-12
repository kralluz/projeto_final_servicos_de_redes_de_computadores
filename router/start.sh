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

# Identifica interfaces e IPs (eth0 é rede de servidores, eth1 é rede de clientes)
echo "Configurando informações das interfaces..."
SERVER_IF="eth0"
CLIENT_IF="eth1"
SERVER_NET="192.168.20.0/24"
CLIENT_NET="192.168.10.0/24"

# Configura IPs nas interfaces
ip addr add 192.168.20.4/24 dev $SERVER_IF || true
ip addr add 192.168.10.1/24 dev $CLIENT_IF || true

# Adiciona rotas estáticas
echo "Configurando rotas..."
ip route add $SERVER_NET dev $SERVER_IF src 192.168.20.4 || true
ip route add $CLIENT_NET dev $CLIENT_IF src 192.168.10.1 || true

# Permite roteamento entre interfaces
echo "Configurando regras de encaminhamento..."
iptables -A FORWARD -i $CLIENT_IF -o $SERVER_IF -j ACCEPT || true
iptables -A FORWARD -i $SERVER_IF -o $CLIENT_IF -j ACCEPT || true

# Configura NAT
echo "Configurando NAT..."
iptables -t nat -A POSTROUTING -s $CLIENT_NET -o $SERVER_IF -j MASQUERADE || true
iptables -t nat -A POSTROUTING -s $SERVER_NET -o $CLIENT_IF -j MASQUERADE || true

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
