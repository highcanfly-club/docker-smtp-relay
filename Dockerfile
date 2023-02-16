FROM boky/postfix
LABEL maintainer="Ronan Le Meillat <ronan@parapente.cf>"
RUN apk --no-cache add curl &&\
    echo "*/2     *       *       *       *       /update-cloudflare-dns.sh" >> /etc/crontabs/root
ADD scripts/dkim-parsing.sh /docker-init.db/
ADD scripts/init-cloudflare.sh /docker-init.db/
ADD scripts/update-cloudflare-dns.sh /
