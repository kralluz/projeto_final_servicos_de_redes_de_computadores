FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y bind9 dnsutils

# copia o script de setup das config do Bind
COPY setup-bind.sh /usr/local/bin/setup-bind.sh

# executa o script para gerar named.conf* e zonas
RUN bash /usr/local/bin/setup-bind.sh

EXPOSE 53/udp 53/tcp
CMD ["named", "-g", "-c", "/etc/bind/named.conf"]
