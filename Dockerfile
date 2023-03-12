FROM boky/postfix
LABEL maintainer="Ronan Le Meillat <ronan.le_meillat@ismo-group.co.uk>"
RUN apk --no-cache add curl acme.sh &&\
    echo "*/10     *       *       *       *       sleep \$((\`od -vAn -N2 -tu2 < /dev/urandom\` %300)) ; /update-cloudflare-dns.sh" >> /etc/crontabs/root &&\
    echo "0        0       *       *       0       sleep \$((\`od -vAn -N2 -tu2 < /dev/urandom\` %14400)) ; acme.sh --renew-all --config-home /var/www/dolidock/documents/certs/config" >> /etc/crontabs/root 
ADD scripts/dkim-parsing.sh /docker-init.db/
ADD scripts/init-cloudflare.sh /docker-init.db/
ADD scripts/init-letsencrypt.sh /docker-init.db/
ADD scripts/update-cloudflare-dns.sh /
