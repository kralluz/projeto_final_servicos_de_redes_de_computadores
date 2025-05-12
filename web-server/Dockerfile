FROM nginx:latest

# Instala ferramentas necessárias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apache2-utils \
    iproute2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copia página inicial
COPY index.html /usr/share/nginx/html/index.html

# Configuração simples do Nginx
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
