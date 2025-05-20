# Relatório de Testes dos Serviços Docker

docker-compose down -v  # Derruba todos os serviços e remove volumes

docker-compose up -d --build  # Sobe todos os serviços novamente

## 1. DHCP
# Verifica se o client01 obteve IP automaticamente

docker exec client01 ip addr show eth0

docker exec client01 apt-get update

docker exec client01 apt-get install -y iputils-ping dnsutils curl smbclient

docker exec client01 ip addr show eth0

- **Teste:** Cliente obteve IP automaticamente
- **Comando:** `ip addr show eth0`
- **Resultado:**
  - IP atribuído: 192.168.20.XX

## 2. DNS

- **Teste:** Resolução de nomes internos e externos
- **Comando:** `nslookup google.com 192.168.10.10`
- **Resultado:**
  - google.com resolvido com sucesso
- **Comando:** `nslookup firewall 192.168.10.10`
- **Resultado:**
  - firewall.rede.local resolvido
- **Comando:** `nslookup router 192.168.10.10`
- **Resultado:**
  - router.rede.local resolvido
- **Comando:** `nslookup nginx 192.168.10.10`
- **Resultado:**
  - nginx.rede.local resolvido
- **Comando:** `nslookup samba-server 192.168.10.10`
- **Resultado:**
  - samba-server.rede.local resolvido

## 3. Firewall e Conectividade

docker exec client01 ping -c 2 192.168.20.253  # firewall

docker exec client01 ping -c 2 192.168.20.254  # router

docker exec client01 ping -c 2 192.168.10.10   # dns-server

docker exec client01 curl -I http://192.168.10.20  # nginx

docker exec client01 ping -c 2 192.168.10.5    # samba-server

## 4. Samba (Compartilhamento de Arquivos)

# Lista os compartilhamentos disponíveis no Samba

docker exec client01 smbclient -L //192.168.10.5 -N

# Testa acesso ao compartilhamento público

docker exec client01 smbclient //192.168.10.5/public -N -c 'ls'

# (Opcional) Cria um arquivo de teste no compartilhamento
# docker exec client01 bash -c "echo 'teste' | smbclient //192.168.10.5/public -N -c 'put - test.txt'"

## 5. Nginx (Web)
- **Teste:** Acesso HTTP ao serviço web
- **Comando:** `curl -I http://192.168.10.20`
- **Resultado:**
  - HTTP/1.1 200 OK

---

Todos os testes básicos dos serviços foram realizados com sucesso, incluindo o acesso ao compartilhamento Samba via client01. Caso algum teste falhe, verifique logs dos containers correspondentes.