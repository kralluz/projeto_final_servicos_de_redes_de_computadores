FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y isc-dhcp-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/dhcp-server && \
    mkdir -p /var/lib/dhcp && \
    touch /var/lib/dhcp/dhcpd.leases && \
    chown -R dhcpd:dhcpd /var/run/dhcp-server /var/lib/dhcp

COPY dhcpd.conf /etc/dhcp/dhcpd.conf
COPY isc-dhcp-server /etc/default/isc-dhcp-server

EXPOSE 67/udp

# Inicia o DHCP em primeiro plano
CMD ["dhcpd", "-d", "-f", "-cf", "/etc/dhcp/dhcpd.conf", "-lf", "/var/lib/dhcp/dhcpd.leases", "eth0"] 