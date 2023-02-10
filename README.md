# docker-smtp-relay
Our adaptation of boky/postfix

# What differs ?
We need to provie a unique RSA dkim private key for all our domains.  
At start a script will generate a dkim key for each ALLOWED_SENDER_DOMAINS , the selector will be hcfmailer
  
For generating the there is many solutions ex:  
```sh
openssl genrsa -out dkim_private.pem 2048
```
next replace all the \n (new line) with a |  and store in in DKIM_PRIVATE_KEY  
```sh
ALLOWED_SENDER_DOMAINS="example.org example.com example.net" DKIM_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----|MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC6VtJoI7dkG9Pl|QkKPQKbVQ7g0+FiQEnNoHU0=|-----END PRIVATE KEY-----" docker run -e DKIM_PRIVATE_KEY -e highcanfly/smtp-relay:latest
```
# deploy
Get image at highcanfly/smtp-relay:latest

# configuration
see https://github.com/bokysan/docker-postfix
