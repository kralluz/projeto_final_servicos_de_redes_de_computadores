FROM alpine:latest

RUN apk add --no-cache iproute2 iptables bash

# copia o script (não precisa de +x no host)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# executa via shell
ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]

# um roteador NAT entre duas redes, com eth0 sendo a WAN (ex: internet) e eth1 sendo a LAN. Para isso funcionar de verdade:
# Ambas interfaces precisam existir no container (usando modo bridge ou rede customizada no Docker).  
# O host/container precisa ter capacidade de roteamento entre essas redes.
