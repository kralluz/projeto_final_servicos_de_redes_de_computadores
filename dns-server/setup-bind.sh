#!/usr/bin/env bash
set -e

# limpa configs padrão
rm -f /etc/bind/named.conf.options
rm -f /etc/bind/named.conf.local
mkdir -p /etc/bind/zones

# named.conf.options
cat << 'EOF' > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";
    recursion yes;
    allow-query { any; };
    forwarders { 8.8.8.8; 8.8.4.4; };
    dnssec-validation no;
    listen-on { any; };
};
EOF

# named.conf.local (forward + reverse)
cat << 'EOF' > /etc/bind/named.conf.local
zone "corp.local" {
    type master;
    file "/etc/bind/zones/db.corp.local";
};
zone "192.168.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.168.10";
};
EOF

# db.corp.local (forward zone)
cat << 'EOF' > /etc/bind/zones/db.corp.local
\$TTL 604800
@       IN      SOA     dns.corp.local. root.corp.local. (
                     2         ; Serial
                604800         ; Refresh
                 86400         ; Retry
               2419200         ; Expire
                604800 )       ; Negative Cache TTL

@       IN      NS      dns.corp.local.
router  IN      A       192.168.10.4
firewall IN     A       192.168.10.5
dhcp    IN      A       192.168.10.2
dns     IN      A       192.168.10.3
ldap    IN      A       192.168.10.6
files   IN      A       192.168.10.7
ftp     IN      A       192.168.10.8
intranet IN     A       192.168.10.9
EOF

# db.192.168.10 (reverse zone)
cat << 'EOF' > /etc/bind/zones/db.192.168.10
\$TTL 604800
@       IN      SOA     dns.corp.local. root.corp.local. (
                     1         ; Serial
                604800         ; Refresh
                 86400         ; Retry
               2419200         ; Expire
                604800 )       ; Negative Cache TTL

@       IN      NS      dns.corp.local.
2       IN      PTR     dhcp.corp.local.
3       IN      PTR     dns.corp.local.
4       IN      PTR     router.corp.local.
5       IN      PTR     firewall.corp.local.
6       IN      PTR     ldap.corp.local.
7       IN      PTR     files.corp.local.
8       IN      PTR     ftp.corp.local.
9       IN      PTR     intranet.corp.local.
EOF
