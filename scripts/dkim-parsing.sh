#!/bin/bash
. /scripts/common.sh
. /scripts/common-run.sh
if [[ $USE_DKIM_PARSING -eq '1' ]]; then
    echo $DKIM_PRIVATE_KEY | sed 's/|/\n/g' >/etc/opendkim/keys/master.key
    openssl rsa -in /etc/opendkim/keys/master.key -pubout -outform der 2>/dev/null | openssl base64 -A >/etc/opendkim/keys/pubkey.txt
    PUBLIC_KEY=$(cat /etc/opendkim/keys/pubkey.txt)
    for DOMAIN in $ALLOWED_SENDER_DOMAINS; do
        echo $DOMAIN
        cp /etc/opendkim/keys/master.key /etc/opendkim/keys/$DOMAIN.private
        cat >/etc/opendkim/keys/$DOMAIN.txt <<EOF
$DKIM_SELECTOR._domainkey	IN	TXT	( "v=DKIM1; h=sha256; k=rsa; s=email; p=${PUBLIC_KEY}" )  ; ----- DKIM key mail for $DOMAIN
EOF
        echo "*****************************************************************************************************"
        echo "Please make sure to update your DNS records for $DOMAIN! You need to add the following details:"
        fold -w 80 /etc/opendkim/keys/$DOMAIN.txt
    done
    postfix_setup_dkim
fi
