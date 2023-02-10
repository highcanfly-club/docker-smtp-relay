FROM boky/postfix
LABEL maintainer="Ronan Le Meillat <ronan@parapente.cf>"
ADD scripts/dkim-parsing.sh /docker-init.db/