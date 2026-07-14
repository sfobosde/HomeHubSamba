#!/usr/bin/env bash
set -e

REALM="${SAMBA_REALM}"
DOMAIN="${SAMBA_DOMAIN}"
HOSTNAME="${SAMBA_HOSTNAME}"
PASSWORD="${SAMBA_ADMIN_PASSWORD}"
DNS_BACKEND="${SAMBA_DNS_BACKEND:-SAMBA_INTERNAL}"

if [ ! -f /var/lib/samba/private/secrets.ldb ]; then
    rm -f /etc/samba/smb.conf

    samba-tool domain provision \
        --realm="$REALM" \
        --domain="$DOMAIN" \
        --host-name="$HOSTNAME" \
        --server-role=dc \
        --dns-backend="$DNS_BACKEND" \
        --adminpass="$PASSWORD"
fi

exec samba --foreground --debug-stdout