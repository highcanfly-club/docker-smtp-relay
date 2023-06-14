#!/bin/sh
if [[ $USE_LETSENCRYPT -eq '1' ]]; then
    acme.sh --renew-all --config-home /listmonk/backups/certs/config
fi
