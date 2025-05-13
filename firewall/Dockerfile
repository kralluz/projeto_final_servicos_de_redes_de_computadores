FROM debian:stable-slim
RUN apt-get update && apt-get install -y iptables && rm -rf /var/lib/apt/lists/*

COPY regras.sh /usr/local/bin/regras.sh
RUN chmod +x /usr/local/bin/regras.sh

ENTRYPOINT ["/usr/local/bin/regras.sh"]