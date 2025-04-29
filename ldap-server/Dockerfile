FROM osixia/openldap:1.5.0

ENV LDAP_ORGANISATION="corp" \
    LDAP_DOMAIN="corp.local" \
    LDAP_ADMIN_PASSWORD="adminpassword"

COPY bootstrap.ldif /container/service/slapd/assets/bootstrap/bootstrap.ldif
