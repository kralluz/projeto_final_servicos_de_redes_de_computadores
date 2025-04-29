FROM nginx:latest

# Instala apache2-utils para htpasswd e limpa cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends apache2-utils && \
    rm -rf /var/lib/apt/lists/*

# Copia configuração do host virtual e cria arquivo de senhas
COPY default.conf /etc/nginx/conf.d/default.conf
RUN htpasswd -cb /etc/nginx/.htpasswd alice alicepass

# Copia página inicial
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
