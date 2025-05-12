FROM nginx:stable-alpine

# Copia um arquivo index.html simples para a raiz do servidor (em /usr/share/nginx/html)
COPY index.html /usr/share/nginx/html/index.html

# Expõe a porta 80
EXPOSE 80

# O entrypoint padrão do NGINX (nginx -g 'daemon off;') já inicia o servidor em primeiro plano, então não é necessário sobrescrever o CMD. 