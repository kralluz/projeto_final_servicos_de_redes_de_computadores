# Implementação de Serviços de Gestão de Redes de Computadores em Docker

## Instituto Federal Goiano – Câmpus Ceres
**Curso:** Bacharelado em Sistemas de Informação  
**Disciplina:** Gestão de Redes de Computadores  
**Autores:** Carlos Henrique Alves, Felipe Gomes, Iago José, Victor Augusto 
**Professor:** Roitier Campos Gonçalves  
**Semestre:** 2025/01  
**Turma:** Serviços de Redes de Computadores - 5° Período  
**Valor:** 5 Pontos  
**Data da Entrega:** 29/04/2025

---

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
- **DNS (Bind9 ou dnsmasq):**
  - Resolução de nomes local.
  - Zonas forward e reverse.
- **DHCP (ISC DHCP ou dhcpd):**
  - Atribuição automática de IPs.
  - Reservas de IPs fixos.
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
