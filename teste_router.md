
## 1. Verificar Status do Router

```bash

# Verificar as interfaces de rede do router
docker exec router ip addr show

# Verificar as rotas configuradas
docker exec router ip route

# Verificar o status do forwarding de pacotes
docker exec router sysctl net.ipv4.ip_forward
```

## 2. Testar Conectividade Básica

```bash
# Testar ping do cliente para o router
docker exec client01 ping -c 4 192.168.20.4

# Testar ping do cliente para outro servidor na rede
docker exec client01 ping -c 4 192.168.20.2

# Verificar a rota padrão no cliente
docker exec client01 ip route
```

## 4. Verificar Logs e Diagnóstico

```bash
# Verificar logs do router
docker logs router

# Verificar status das interfaces
docker exec router ip link show

# Verificar tabela ARP
docker exec router arp -n
```
