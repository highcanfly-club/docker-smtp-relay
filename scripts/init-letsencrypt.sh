#!/bin/bash
. /scripts/common.sh
. /scripts/common-run.sh
if [[ $USE_LETSENCRYPT -eq '1' ]]; then
    CERT_DIR=/etc/ssl
    if [ ! -f $CERT_DIR/$POSTFIX_HOSTNAME.key ]; then
        sleep $(($(od -vAn -N2 -tu2 </dev/urandom) % 60))
        mkdir -p $CERT_DIR/acme.config
        export CF_Token="$CLOUDFLARE_API_KEY"
        acme.sh --issue -d $POSTFIX_HOSTNAME --dns dns_cf --ocsp-must-staple --config-home $CERT_DIR/config \
            --keylength 4096 --server letsencrypt \
            --cert-file $CERT_DIR/certs/$POSTFIX_HOSTNAME.pem --key-file $CERT_DIR/private/$POSTFIX_HOSTNAME.key \
            --fullchain-file $CERT_DIR/cert/$POSTFIX_HOSTNAME-full.pem
    else
        echo "CERT: $POSTFIX_HOSTNAME.pem exists…"
        acme.sh --renew-all --config-home $CERT_DIR/acme.config
        postconf -e "smtpd_tls_cert_file=$CERT_DIR/certs/$POSTFIX_HOSTNAME-full.pem"
        postconf -e "smtpd_tls_key_file=$CERT_DIR/private/$POSTFIX_HOSTNAME.key"
        postconf -e "smtp_tls_cert_file=$CERT_DIR/certs/$POSTFIX_HOSTNAME-full.pem"
        postconf -e "smtp_tls_key_file=$CERT_DIR/private/$POSTFIX_HOSTNAME.key"
        postconf -P submission/inet/smtpd_tls_wrappermode=yes
    fi
fi
