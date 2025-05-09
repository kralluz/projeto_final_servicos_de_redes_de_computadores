FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y bind9 dnsutils bind9utils

# Cria diretório de zones com permissões corretas
RUN mkdir -p /etc/bind/zones && \
    chown -R bind:bind /etc/bind /var/cache/bind /var/run/named && \
    chmod -R 755 /etc/bind /var/cache/bind /var/run/named

COPY setup-bind.sh /usr/local/bin/setup-bind.sh
RUN chmod +x /usr/local/bin/setup-bind.sh

# Executa o script de setup e rode o BIND
CMD bash -c "/usr/local/bin/setup-bind.sh && named -g -c /etc/bind/named.conf -u bind"

EXPOSE 53/udp 53/tcp
