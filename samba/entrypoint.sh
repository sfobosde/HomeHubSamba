#!/usr/bin/env bash
set -e

if [ ! -f /var/lib/samba/private/secrets.ldb ]; then
    rm -f /etc/samba/smb.conf

    samba-tool domain provision \
        --realm="$SAMBA_REALM" \
        --domain="$SAMBA_DOMAIN" \
        --host-name="$SAMBA_HOSTNAME" \
        --server-role=dc \
        --dns-backend="$SAMBA_DNS_BACKEND" \
        --adminpass="$SAMBA_ADMIN_PASSWORD"
fi

# Всегда используем krb5.conf, созданный Samba
ln -sf /var/lib/samba/private/krb5.conf /etc/krb5.conf

exec samba --foreground --debug-stdout