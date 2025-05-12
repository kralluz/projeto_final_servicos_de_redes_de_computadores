#!/bin/bash

# Configurar o DNS local
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# Iniciar o BIND
exec /usr/sbin/named -g -c /etc/bind/named.conf 