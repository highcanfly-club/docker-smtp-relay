FROM boky/postfix
LABEL maintainer="Ronan Le Meillat <ronan@parapente.cf>"
ENV USE_LETSENCRYPT '1'
ENV USE_CLOUDFLARE_DDNS '1'
ENV USE_DKIM_PARSING '1'
RUN apk --no-cache add curl acme.sh &&\
    echo "*/10     *       *       *       *       sleep \$((\`od -vAn -N2 -tu2 < /dev/urandom\` %300)) ; /update-cloudflare-dns.sh" >> /etc/crontabs/root &&\
    echo "0        0       *       *       0       sleep \$((\`od -vAn -N2 -tu2 < /dev/urandom\` %14400)) ; /update-letsencrypt.sh" >> /etc/crontabs/root 
ADD scripts/dkim-parsing.sh /docker-init.db/
ADD scripts/init-cloudflare.sh /docker-init.db/
ADD scripts/init-letsencrypt.sh /docker-init.db/
ADD scripts/update-cloudflare-dns.sh /
ADD scripts/update-letsencrypt.sh /
RUN chmod ugo+x /update-cloudflare-dns.sh \
        && chmod ugo+x /update-letsencrypt.sh \
        && chmod ugo+x /update-cloudflare-dns.sh \
        && chmod ugo+x /docker-init.db/dkim-parsing.sh \
        && chmod ugo+x /docker-init.db/init-cloudflare.sh \
        && chmod ugo+x /docker-init.db/init-letsencrypt.sh
