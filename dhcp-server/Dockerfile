FROM ubuntu:20.04

# instala o isc-dhcp-server
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y isc-dhcp-server

# copia o arquivo de configuração
COPY dhcpd.conf /etc/dhcp/dhcpd.conf

# força o DHCP a escutar na eth0
RUN sed -i 's/INTERFACESv4=""/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server

EXPOSE 67/udp

CMD ["dhcpd", "-4", "-f", "-d"]
