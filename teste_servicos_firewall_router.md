# Testes de Serviços Firewall e Router

Este documento descreve as etapas para testar os serviços de Firewall e Router na infraestrutura de rede. Assume-se que o ambiente Docker Compose já está inicializado e todos os containers estão em execução.

## Pré-requisitos

- Docker e Docker Compose instalados
- Todos os containers da infraestrutura em execução
- Acesso ao terminal/linha de comando

## Etapas de Teste para o Serviço Router

### 1. Verificar containers em execução

```bash
docker ps | findstr "router"
```

Verifique se o container do router está em execução.

### 2. Verificar configuração de interfaces do router

```bash
docker exec router ip addr
```

Observe que o router deve ter pelo menos duas interfaces de rede configuradas:
- eth0: conectada à rede 192.168.20.0/24 (IP: 192.168.20.4)
- eth1: conectada à rede 192.168.10.0/24 (IP: 192.168.10.4)

### 3. Examinar tabela de roteamento do router

```bash
docker exec router ip route
```

Verifique se o router possui rotas para as redes necessárias:
- Rota para a rede 192.168.20.0/24
- Rota para a rede 192.168.10.0/24 (se não aparecer diretamente, é porque está na mesma rede da interface)
- Possível rota padrão (default)

### 4. Verificar se o encaminhamento de pacotes está habilitado

```bash
docker exec router sysctl net.ipv4.ip_forward
```

Confirme que o valor é 1, indicando que o encaminhamento de pacotes IP está habilitado.

### 5. Examinar regras NAT configuradas

```bash
docker exec router iptables -t nat -L -v
```

Verifique as regras na tabela NAT, principalmente na chain POSTROUTING:
- Regras de MASQUERADE para permitir NAT entre as redes
- Regras específicas para redirecionamento de portas (DNAT), se houver

### 6. Testar conectividade com o router a partir do cliente

```bash
docker exec client01 ping -c 3 192.168.20.4
```

Confirme que há resposta do router (0% de perda de pacotes).

### 7. Testar roteamento entre redes através do router

```bash
docker exec client01 traceroute 192.168.10.9
```

Observe que o traceroute mostra o caminho passando pelo router (192.168.20.4) antes de chegar ao destino em outra rede.

## Etapas de Teste para o Serviço Firewall

### 1. Verificar container do firewall em execução

```bash
docker ps | findstr "firewall"
```

Verifique se o container do firewall está em execução.

### 2. Verificar configuração de interfaces do firewall

```bash
docker exec firewall ip addr
```

Observe que o firewall deve ter pelo menos duas interfaces de rede configuradas:
- eth0: conectada à rede 192.168.20.0/24 (IP: 192.168.20.5)
- eth1: conectada à rede 192.168.10.0/24 (IP: 192.168.10.5)

### 3. Verificar se o encaminhamento de pacotes está habilitado no firewall

```bash
docker exec firewall sysctl net.ipv4.ip_forward
```

Confirme que o valor é 1, indicando que o encaminhamento de pacotes IP está habilitado.

### 4. Examinar regras de firewall configuradas

```bash
docker exec firewall iptables -L -v
```

Verifique as regras nas várias chains:
- INPUT: regras para pacotes destinados ao próprio firewall
- FORWARD: regras para pacotes que passam pelo firewall
- OUTPUT: regras para pacotes originados no firewall

Observe especialmente as políticas padrão (ACCEPT, DROP, etc.) e regras específicas.

### 5. Testar conectividade com o firewall a partir do cliente

```bash
docker exec client01 ping -c 3 192.168.20.5
```

Confirme que há resposta do firewall (0% de perda de pacotes).

### 6. Testar regras de filtragem do firewall

Teste de serviços permitidos:
```bash
docker exec client01 curl -I http://192.168.10.9
```

Teste de serviços bloqueados (caso tenha algum serviço bloqueado nas regras):
```bash
docker exec client01 telnet 192.168.10.9 22
```

Verifique se os serviços permitidos estão acessíveis e os bloqueados não estão.

## Testes Integrados de Router e Firewall

### 1. Testar acesso a serviços através da infraestrutura completa

```bash
# Teste de acesso ao servidor web
docker exec client01 curl -I http://192.168.10.9

# Teste de acesso ao servidor LDAP
docker exec client01 ldapsearch -x -H ldap://192.168.10.3 -b "dc=corp,dc=local" -D "cn=admin,dc=corp,dc=local" -w admin
```

### 2. Verificar logs do firewall para análise de tráfego

```bash
docker exec firewall iptables -L -v
```

Observe os contadores de pacotes para ver quais regras estão sendo acionadas.

## Resolução de Problemas

### Problemas com Router

1. Se não houver conectividade entre redes:
   - Verifique se o encaminhamento de pacotes está habilitado: `docker exec router sysctl net.ipv4.ip_forward`
   - Verifique as rotas configuradas: `docker exec router ip route`
   - Verifique as regras de NAT: `docker exec router iptables -t nat -L`
   - Verifique os logs do router: `docker logs router`

2. Se o NAT não estiver funcionando:
   - Verifique as regras de MASQUERADE: `docker exec router iptables -t nat -L POSTROUTING -v`
   - Confirme que as interfaces estão configuradas corretamente

### Problemas com Firewall

1. Se as conexões estiverem sendo bloqueadas indevidamente:
   - Verifique as regras de firewall: `docker exec firewall iptables -L -v`
   - Verifique os logs do firewall: `docker logs firewall`
   - Tente adicionar uma regra temporária para permitir o tráfego específico para testes

2. Se o firewall não estiver filtrando tráfego adequadamente:
   - Verifique a ordem das regras de firewall (a primeira regra que dá match é aplicada)
   - Verifique se as interfaces estão corretamente configuradas
   - Confirme que as políticas padrão estão configuradas adequadamente

## Conclusão

Após executar todas as etapas de teste, você deverá ter um ambiente com Router e Firewall funcionando corretamente. O sistema deve ser capaz de:

1. Rotear tráfego entre as diferentes redes (192.168.10.0/24 e 192.168.20.0/24)
2. Aplicar NAT para permitir que hosts em redes internas acessem recursos externos
3. Filtrar tráfego de acordo com as regras de firewall configuradas
4. Permitir acesso controlado aos serviços entre as diferentes redes

Se todos os testes forem bem-sucedidos, os serviços de Router e Firewall estão configurados corretamente. 