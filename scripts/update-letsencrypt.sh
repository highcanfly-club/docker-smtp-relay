#!/bin/bash
if [[ $USE_LETSENCRYPT -eq '1' ]]; then
    acme.sh --renew-all --config-home /etc/ssl/certs/config
fi
