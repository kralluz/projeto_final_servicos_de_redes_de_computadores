#!/bin/bash

echo "=== Iniciando configuração do cliente ==="

# Primeiro, tenta obter configuração via DHCP
echo "Solicitando configuração via DHCP..."
dhclient -v eth0 || true

# Em caso de falha do DHCP, configura manualmente
echo "Configurando DNS como backup..."
cat > /etc/resolv.conf << EOF
domain corp.local
search corp.local
nameserver 192.168.10.3
nameserver 8.8.8.8
EOF

# Configura a rota padrão se não configurada via DHCP
if ! ip route | grep -q "^default"; then
    echo "Configurando gateway padrão..."
    ip route add default via 192.168.20.4 || true
fi

# Verifica configuração de rede
echo "=== Configuração de rede ==="
ip addr show
ip route
cat /etc/resolv.conf

echo "Cliente configurado e pronto para testes."

# Mantém o container em execução
sleep infinity 