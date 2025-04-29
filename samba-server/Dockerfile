FROM ubuntu:20.04

# Instala Samba e limpa cache do apt
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends samba smbclient && \
    rm -rf /var/lib/apt/lists/*

# Copia configuração
COPY smb.conf /etc/samba/smb.conf

# Prepara diretórios e permissões
RUN mkdir -p /var/lib/samba/private /var/log/samba /srv/samba/files && \
    chown -R root:root /srv/samba/files && \
    chmod -R 0775 /srv/samba/files

# Cria usuário Samba (sem home) e adiciona ao passdb
RUN useradd -M -s /usr/sbin/nologin sambauser && \
    (echo "sambauser"; echo "sambauser") | smbpasswd -s -a sambauser

EXPOSE 445 139

CMD ["smbd", "-FS", "--no-process-group"]
