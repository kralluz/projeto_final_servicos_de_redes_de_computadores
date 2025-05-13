FROM dperson/samba:latest

# Cria diretório de compartilhamento
RUN mkdir -p /samba/share && chmod 777 /samba/share

# Copia configuração customizada
COPY smb.conf /etc/samba/smb.conf

# Expor portas SMB (apenas para rede interna Docker)
# EXPOSE 137/udp 138/udp 139/tcp 445/tcp

# Usa configuração do smb.conf e permite guest
CMD ["-n"]
