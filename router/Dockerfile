FROM alpine:latest

RUN apk add --no-cache iproute2 iptables bash

# copia o script (não precisa de +x no host)
COPY start.sh /usr/local/bin/start.sh

# executa via shell
ENTRYPOINT ["sh", "/usr/local/bin/start.sh"]
