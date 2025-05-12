FROM ubuntu:22.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y isc-dhcp-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run && \
    chown dhcpd:dhcpd /var/run

COPY dhcpd.conf /etc/dhcp/dhcpd.conf
COPY isc-dhcp-server /etc/default/isc-dhcp-server
EXPOSE 67/udp
CMD ["sh","-c","service isc-dhcp-server start && tail -f /var/log/syslog"] 