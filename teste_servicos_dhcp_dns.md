# Testes de Serviços DHCP e DNS

Este documento descreve as etapas para testar os serviços DHCP e DNS na infraestrutura de rede. Assume-se que o ambiente Docker Compose já está inicializado e todos os containers estão em execução.

## Pré-requisitos

- Docker e Docker Compose instalados
- Todos os containers da infraestrutura em execução
- Acesso ao terminal/linha de comando

## Etapas de Teste para o Serviço DHCP

### 1. Verificar containers em execução

```bash
docker ps
```

Verifique se os containers necessários estão em execução, especialmente `dhcp-server` e `client01`.

### 2. Verificar configuração de IP atual do cliente

```bash
docker exec client01 ip addr
```

Observe que o cliente deve ter um endereço IP na rede 192.168.20.0/24, atribuído pelo servidor DHCP.

### 3. Examinar arquivo de leases DHCP

```bash
docker exec client01 cat /var/lib/dhcp/dhclient.leases
```

Verifique se o arquivo contém:
- Endereço IP fixo (fixed-address): 192.168.20.100
- Máscara de sub-rede (subnet-mask): 255.255.255.0
- Roteador/Gateway (routers): 192.168.20.4
- Tempo de concessão (dhcp-lease-time): 600 segundos
- Servidores DNS (domain-name-servers): 192.168.10.3
- Identificador do servidor DHCP (dhcp-server-identifier): 192.168.20.2
- Domínio (domain-name): corp.local

### 4. Testar conectividade com o gateway

```bash
docker exec client01 ping -c 3 192.168.20.4
```

Confirme que há resposta do gateway (0% de perda de pacotes).

### 5. Forçar renovação do lease DHCP

```bash
docker exec client01 dhclient -r eth0
docker exec client01 dhclient eth0
```

### 6. Verificar nova configuração de IP

```bash
docker exec client01 ifconfig eth0
```

Confirme que o cliente recebeu o mesmo endereço IP (192.168.20.100) ou outro dentro do escopo do DHCP.

## Etapas de Teste para o Serviço DNS

### 1. Verificar configuração do DNS no cliente

```bash
docker exec client01 cat /etc/resolv.conf
```

Verifique se o arquivo contém:
- Domínio (domain): corp.local
- Servidores de nomes (nameserver): 192.168.10.3 (primário) e 8.8.8.8 (secundário)

### 2. Testar resolução de nomes externos

```bash
docker exec client01 nslookup firewall.corp.local
```

Confirme que o cliente consegue resolver nomes de domínios externos.

### 3. Testar resolução de nomes internos

```bash
docker exec client01 nslookup ldap.corp.local
docker exec client01 nslookup samba.corp.local
docker exec client01 nslookup ftp.corp.local
docker exec client01 nslookup www.corp.local
```

Verifique se o cliente consegue resolver nomes de domínios internos.

### 4. Testar resolução reversa

```bash
docker exec client01 nslookup 192.168.10.3
docker exec client01 nslookup 192.168.20.2
```

Confirme que o DNS reverso está funcionando corretamente.

### 5. Verificar latência de resolução DNS

```bash
docker exec client01 time nslookup google.com
```

Avalie o tempo de resposta do servidor DNS.
