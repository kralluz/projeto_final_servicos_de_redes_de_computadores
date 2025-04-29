FROM alpine:latest

RUN apk add --no-cache iptables bash

COPY firewall.sh /usr/local/bin/firewall.sh

ENTRYPOINT ["sh", "/usr/local/bin/firewall.sh"]
CMD ["-h"]