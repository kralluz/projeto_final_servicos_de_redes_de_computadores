FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y vsftpd

# copia a configuração do vsftpd
COPY vsftpd.conf /etc/vsftpd.conf

# cria usuário e home seguro
RUN useradd -m ftpuser && \
    mkdir -p /home/ftpuser/ftp && \
    chown -R ftpuser:ftpuser /home/ftpuser/ftp

EXPOSE 21
CMD ["vsftpd", "/etc/vsftpd.conf"]
