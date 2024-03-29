#!/bin/bash
. /scripts/common.sh
. /scripts/common-run.sh
if [[ $USE_LETSENCRYPT -eq '1' && ! -d /etc/postfix/certs ]]; then
    if [[ $USE_LETSENCRYPT_STAGING -eq '1' ]]; then
        echo "Using Let's Encrypt staging server"
        STAGING="--staging"
    fi
    CERT_DIR=/etc/ssl
    if [ ! -f $CERT_DIR/$POSTFIX_HOSTNAME.key ]; then
        sleep $(($(od -vAn -N2 -tu2 </dev/urandom) % 60))
        mkdir -p $CERT_DIR/acme.config
        export CF_Token="$CLOUDFLARE_API_KEY"
        acme.sh --issue -d $POSTFIX_HOSTNAME --dns dns_cf --ocsp-must-staple --config-home $CERT_DIR/config \
            --keylength 4096 --server letsencrypt $STAGING \
            --cert-file $CERT_DIR/certs/$POSTFIX_HOSTNAME.pem --key-file $CERT_DIR/private/$POSTFIX_HOSTNAME.key \
            --fullchain-file $CERT_DIR/certs/$POSTFIX_HOSTNAME-full.pem
    fi
    if [[ -f $CERT_DIR/certs/$POSTFIX_HOSTNAME-full.pem ]]; then
        postconf -e "smtpd_tls_cert_file=$CERT_DIR/certs/$POSTFIX_HOSTNAME-full.pem"
        postconf -e "smtpd_tls_key_file=$CERT_DIR/private/$POSTFIX_HOSTNAME.key"
        postconf -e "smtp_tls_cert_file=$CERT_DIR/certs/$POSTFIX_HOSTNAME-full.pem"
        postconf -e "smtp_tls_key_file=$CERT_DIR/private/$POSTFIX_HOSTNAME.key"
        postconf -P submission/inet/smtpd_tls_wrappermode=yes
    fi
fi

if [[ -d /etc/postfix/certs ]]; then
    CERT_DIR=/etc/postfix/certs
    EXTCERT_DIR=/etc/postfix/extcerts
    mkdir -p $EXTCERT_DIR
    cat $CERT_DIR/tls.key > $EXTCERT_DIR/$POSTFIX_HOSTNAME.key
    cat $CERT_DIR/tls.crt > $EXTCERT_DIR/$POSTFIX_HOSTNAME-full.pem
    if [[ -f $EXTCERT_DIR/$POSTFIX_HOSTNAME-full.pem ]]; then
        postconf -e "smtpd_tls_cert_file=$EXTCERT_DIR/$POSTFIX_HOSTNAME-full.pem"
        postconf -e "smtpd_tls_key_file=$EXTCERT_DIR/$POSTFIX_HOSTNAME.key"
        postconf -e "smtp_tls_cert_file=$EXTCERT_DIR/$POSTFIX_HOSTNAME-full.pem"
        postconf -e "smtp_tls_key_file=$EXTCERT_DIR/$POSTFIX_HOSTNAME.key"
        postconf -P submission/inet/smtpd_tls_wrappermode=yes
    fi
fi
