# Relatório de Testes dos Serviços Docker
docker-compose up -d --build

## 1. DHCP
docker exec client01 ip addr show eth0

docker exec client01 apt-get update

docker exec client01 apt-get update && docker exec client01 apt-get install -y iputils-ping dnsutils curl

docker exec client01 ip addr show eth0

- **Teste:** Cliente obteve IP automaticamente
- **Comando:** `ip addr show eth0`
- **Resultado:**
  - IP atribuído: 192.168.20.50

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

docker exec client01 ping -c 2 192.168.20.253
docker exec client01 ping -c 2 192.168.20.254
docker exec client01 ping -c 2 192.168.10.10

docker exec client01 curl -I http://192.168.10.20

## 3. Firewall
- **Teste:** Acessibilidade do container firewall
- **Comando:** `ping -c 4 192.168.20.253`
- **Resultado:**
  - Respondeu ao ping normalmente

## 4. Router
- **Teste:** Acessibilidade do container router
- **Comando:** `ping -c 4 192.168.20.254`
- **Resultado:**
  - Respondeu ao ping normalmente

## 5. DNS Server
- **Teste:** Acessibilidade do container DNS
- **Comando:** `ping -c 4 192.168.10.10`
- **Resultado:**
  - Respondeu ao ping normalmente

## 6. Nginx (Web)
- **Teste:** Acesso HTTP ao serviço web
- **Comando:** `curl -I http://192.168.10.20`
- **Resultado:**
  - HTTP/1.1 200 OK

---

Todos os testes básicos dos serviços foram realizados com sucesso, exceto a resolução do nome `dhcp-server` no DNS, que retornou NXDOMAIN (não encontrado). Os demais serviços estão operacionais e acessíveis conforme esperado. 