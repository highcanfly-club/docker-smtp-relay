FROM boky/postfix
LABEL maintainer="Ronan Le Meillat <ronan@parapente.cf>"
RUN apk --no-cache add curl acme.sh &&\
    echo "*/10     *       *       *       *       sleep $((`od -vAn -N2 -tu2 < /dev/urandom` %300)) ; /update-cloudflare-dns.sh" >> /etc/crontabs/root &&\
    echo "0        0       *       *       0       acme.sh --renew-all --config-home /listmonk/backups/certs/config" >> /etc/crontabs/root 
ADD scripts/dkim-parsing.sh /docker-init.db/
ADD scripts/init-cloudflare.sh /docker-init.db/
ADD scripts/init-letsencrypt.sh /docker-init.db/
ADD scripts/update-cloudflare-dns.sh /
