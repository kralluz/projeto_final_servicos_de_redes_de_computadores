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

# Identifica interfaces e IPs (eth0 é rede de clientes, eth1 é rede de servidores)
echo "Configurando informações das interfaces..."
CLIENT_IF="eth0"
SERVER_IF="eth1"
CLIENT_NET="192.168.20.0/24"
SERVER_NET="192.168.10.0/24"

# Permite roteamento entre interfaces (servers -> clients e vice-versa)
echo "Configurando regras de encaminhamento..."
iptables -A FORWARD -i $CLIENT_IF -o $SERVER_IF -j ACCEPT || true
iptables -A FORWARD -i $SERVER_IF -o $CLIENT_IF -j ACCEPT || true

# Configura NAT para acesso à internet
echo "Configurando NAT..."
iptables -t nat -A POSTROUTING -s $CLIENT_NET -o $SERVER_IF -j MASQUERADE || true
iptables -t nat -A POSTROUTING -s $SERVER_NET -o $CLIENT_IF -j MASQUERADE || true

# Adiciona regras de masquerade específicas para garantir comunicação entre redes
echo "Configurando masquerade entre redes..."
iptables -t nat -A POSTROUTING -s $CLIENT_NET -d $SERVER_NET -j MASQUERADE || true
iptables -t nat -A POSTROUTING -s $SERVER_NET -d $CLIENT_NET -j MASQUERADE || true

# Exibe configuração
ip addr show
ip route
iptables -L -v -n
iptables -t nat -L -v -n

echo "Router configurado com sucesso. Aguardando..."

# Mantém o container em execução
sleep infinity
