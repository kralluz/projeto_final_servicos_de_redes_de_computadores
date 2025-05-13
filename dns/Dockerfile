FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y bind9 bind9utils bind9-dnsutils && \
    rm -rf /var/lib/apt/lists/*

COPY bind /etc/bind
EXPOSE 53/udp 53/tcp

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"] 