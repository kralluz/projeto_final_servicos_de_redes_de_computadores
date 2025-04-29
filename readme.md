# Implementação de Serviços de Gestão de Redes de Computadores em Docker

## Instituto Federal Goiano – Câmpus Ceres
**Curso:** Bacharelado em Sistemas de Informação  
**Disciplina:** Gestão de Redes de Computadores  
**Semestre:** 2025/01  
**Data da Entrega:** 29/04/2025
**Professor:** Roitier Campos Gonçalves
**Turma:** Serviços de Redes de Computadores - 5° Período  
**Valor:** 5 Pontos  
**Autores:** Carlos Henrique Alves, Felipe Gomes, Iago José, Victor Augusto

# Projeto de Infraestrutura de Rede Corporativa com Docker

## Objetivo
Implementar uma infraestrutura de rede corporativa básica utilizando Docker, integrando serviços essenciais como:
- DNS
- DHCP
- Firewall
- LDAP
- SAMBA
- FTP
- Web Server (Apache/NGINX)

---

## Escopo do Projeto

### 1. Serviços Básicos de Rede

#### DNS (Bind9)
Responsável por resolver nomes dentro da rede local (`corp.local`) e realizar a resolução reversa (associar IPs a nomes de hosts).

**Configuração no Projeto:**
- Foi utilizado o **Bind9** para criar um servidor DNS.
- As zonas foram configuradas da seguinte forma:
  - **Zona Forward**: `corp.local`, associando nomes como `dns.corp.local`, `dhcp.corp.local`, `ldap.corp.local`, entre outros, aos respectivos endereços IP.
  - **Zona Reverse**: `10.168.192.in-addr.arpa`, permitindo a resolução reversa dos IPs da rede `192.168.10.0/24`.
- Consultas para domínios externos são encaminhadas para os servidores públicos do Google (`8.8.8.8`, `8.8.4.4`).

**Infraestrutura em Docker:**
```dockerfile
FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y bind9 dnsutils

COPY setup-bind.sh /usr/local/bin/setup-bind.sh

RUN bash /usr/local/bin/setup-bind.sh

EXPOSE 53/udp 53/tcp

CMD ["named", "-g", "-c", "/etc/bind/named.conf"]
```

**Setup automático:**
- Utilização de um script `setup-bind.sh` que remove as configurações padrão do Bind9 e gera automaticamente:
  - `named.conf.options`
  - `named.conf.local`
  - Arquivos de zona (`db.corp.local` e `db.192.168.10`)
- O DNS escuta em todas as interfaces (`listen-on { any; };`) e permite consultas de qualquer origem (`allow-query { any; };`).

---

#### DHCP (ISC DHCP Server)
Responsável por atribuir automaticamente endereços IP e outras configurações de rede aos dispositivos conectados.

**Configuração no Projeto:**
- Foi utilizado o **ISC DHCP Server** para a atribuição de IPs dentro da faixa `192.168.10.100` a `192.168.10.200`.
- O servidor também distribui informações adicionais como:
  - Gateway padrão (`192.168.10.1`)
  - Servidor DNS (`192.168.10.2`)
  - Domínio de pesquisa (`corp.local`)

**Infraestrutura em Docker:**
```dockerfile
FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y isc-dhcp-server

COPY dhcpd.conf /etc/dhcp/dhcpd.conf

RUN sed -i 's/INTERFACESv4=""/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server

EXPOSE 67/udp

CMD ["dhcpd", "-4", "-f", "-d"]
```

**Arquivo de configuração `dhcpd.conf`:**
```conf
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.168.10.0 netmask 255.255.255.0 {
    range 192.168.10.100 192.168.10.200;
    option routers 192.168.10.1;
    option domain-name-servers 192.168.10.2;
    option domain-name "corp.local";
}
```

**Observações importantes:**
- O servidor DHCP foi configurado como **authoritative**, assumindo controle sobre a rede `192.168.10.0/24`.
- Ele escuta na interface `eth0`, que deve ser corretamente configurada no ambiente Docker.
- O tempo padrão de concessão de IPs é de 600 segundos, podendo ser estendido até 7200 segundos.
  
- **Firewall (iptables/nftables ou UFW):**
  - Filtro de tráfego.
  - Permitir apenas serviços essenciais.
- **LDAP (OpenLDAP ou 389 Directory Server):**
  - Autenticação centralizada.
  - Criação de usuários e grupos.
- **SAMBA:**
  - Compartilhamento de arquivos.
  - Autenticação integrada com LDAP.
- **FTP (vsftpd ou ProFTPD):**
  - FTP seguro (SFTP/FTPS).
- **Web Server (Apache ou NGINX):**
  - Página interna e virtual hosts.

### 2. Requisitos Técnicos
- Docker obrigatório
- Duas sub-redes (ex: 192.168.1.0/24 e 192.168.2.0/24)
- Container roteador entre sub-redes e internet
- Sugestão: uso de Ansible para automação

---

## Etapas do Projeto

### Fase 1: Planejamento
- Análise dos requisitos
- Definição da topologia, IPs, domínios, usuários
- Planejamento de scripts/automação (ex. Ansible)

### Fase 2: Configuração dos Serviços
- Cada serviço em container próprio
- Segurança e integração entre serviços

### Fase 3: Testes e Integração
- Comunicação entre containers e sub-redes
- Validação de DNS, DHCP, Firewall, LDAP, SAMBA, FTP, Web

### Fase 4: Documentação e Automação
- Relatório técnico com configurações e evidências
- Scripts de automação (executar com 1 comando)
- Diagrama de rede
- Publicação no GitHub
- Apresentação

---

## Topologia de Rede

### Sub-redes
- `192.168.10.0/24` - Servidores
- `192.168.20.0/24` - Clientes

### Containers Previstos
| Container        | Função                    | IP              | Rede        |
|------------------|----------------------------|------------------|-------------|
| router           | Roteador                  | 192.168.10.1 / 192.168.20.1 | Ambas |
| dns-server       | DNS interno               | 192.168.10.2     | Servidores  |
| dhcp-server      | DHCP                      | 192.168.10.3     | Servidores  |
| firewall         | Firewall                  | N/A              | N/A         |
| ldap-server      | Autenticação centralizada | 192.168.10.4     | Servidores  |
| samba-server     | Compartilhamento de arquivos | 192.168.10.5  | Servidores  |
| ftp-server       | FTP seguro                | 192.168.10.6     | Servidores  |
| web-server       | Web Server                | 192.168.10.7     | Servidores  |
| client01         | Cliente                   | DHCP (ex: .100)  | Clientes    |
| client02         | Cliente                   | DHCP (ex: .101)  | Clientes    |

---

## Domínio Interno e DNS
- Domínio: `corp.local`

| Nome   | FQDN                | IP             |
|--------|----------------------|----------------|
| DNS    | dns.corp.local      | 192.168.10.2   |
| DHCP   | dhcp.corp.local     | 192.168.10.3   |
| LDAP   | ldap.corp.local     | 192.168.10.4   |
| SAMBA  | files.corp.local    | 192.168.10.5   |
| FTP    | ftp.corp.local      | 192.168.10.6   |
| Web    | intranet.corp.local | 192.168.10.7   |

---

## Estrutura de Usuários (LDAP)
- **Base DN:** `dc=corp,dc=local`
- **Grupos:** `admins`, `developers`, `finance`, `guests`

| Nome  | UID   | Grupo      |
|--------|--------|------------|
| Alice  | alice  | admins     |
| Bob    | bob    | developers |
| Carol  | carol  | finance    |
| Dave   | dave   | guests     |

**Permissões:**
- Login via LDAP
- Acesso a SAMBA conforme grupo
- FTP se autorizado
- Autenticação no Web Server (opcional)

---

## Execução Final
O projeto deve ser implantável com **um único comando**, utilizando scripts ou playbooks para provisionamento automatizado da infraestrutura em Docker.
