FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    iptables \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

COPY firewall.sh /firewall.sh
RUN chmod +x /firewall.sh

# Adiciona capacidades necessárias
ENV CAPABILITIES="NET_ADMIN NET_RAW"

# Mantém o container rodando
CMD ["sh", "-c", "/firewall.sh && sleep infinity"]