# docker-smtp-relay
Our adaptation of boky/postfix

## What differs ?
We need to set ddns with a cloudflare record.  
Note that you need an existing record before running. 
We need to provide a unique RSA dkim private key for all our domains.  
At start a script will generate a dkim key for each ALLOWED_SENDER_DOMAINS , the selector will be mail or if DKIM_SELECTOR is the selector will be those in this environment variable.
  
For generating the there is many solutions ex:  
```sh
openssl genrsa -out /dev/stdout 2048 | tr '\n' '|' | sed 's/.$//'
```
and store in in DKIM_PRIVATE_KEY  
```sh
CLOUDFLARE_API_KEY="YCUENIMPORh8Lx0g72d"  \
CLOUDFLARE_ZONE_ID="554d………………c400fc" \
CLOUDFLARE_DNS_RECORDS="smtpd.example.org, smtpd2.example.org" \
ALLOWED_SENDER_DOMAINS="example.org example.com example.net" \
DKIM_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----|MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDLkJAAw7tffhHu|yXW5kfN1IBvbfrFV9ZyavzrMMeh/WhZ4T7zto5x3n1KsTtHdYYV5f7O4i92QrXev|mCQjzawOI2o2OQ0uNSe7M8/ySYmyz8LvfLcA1/vRKluJ/+0WKvr2Rz5VkjTeH3qv|mJGjrFNvwkjzYPw1nzy+Vd9u/RLO0MHToLvCr9cOByJi4w9sj/nbusi83dEwfkW0|qiypWgbCK9ylLJfhJvV/kXlBFIjHog8WMJ6VLWF1SFCUB1wU2PBi1mwQX8rS18et|Td+qf+eDoMWFrHYsfTSVq8K6ZruarEpW87AmLT5ueYf6UpWFZyiuaNMHwSOXwQdE|F9Omiwl5AgMBAAECggEATHp9f6wJw3Cr8BiEQDnTS9fKX4aTvYXPVlwuDPVbMi14|b68VffqQGGklOFNMiW3QJbuSm+0ASxDA/JmeSk1FLPKlPsXka83QpYZrw81ZDHL9|+9fRMWHz27ucNJaQTlnLe6d8hc2uSx1sjHg3j1R47G4D1lxDpSm0OpYsoZg27rfX|qpjjfMfJCYP0cd+qGdS3Rkfo+R8FAlZFW9jUWkfIpJrshSGR/EJ8lthS1Jt3iCyt|85QKMKPC79x1AP3H5CsnVJ3xieLsKuECEcdfH76ISryNES/gelD/d8Tlz9stpA+V|RRWIvGIqxXWRAqTAdo/dD7douDOd/FQP2JfQ89xk2QKBgQDxslckA/XONe+prl0s|nZKY4jZ4jp0cSxQ2FoYLYVLRBTJ5CJDdpfRwVgyT+86qqyA/tIDee4uTIHSMMVT7|j8dGq3u3PGwjBo1c2SpAdUHNKYxSt06UNKvqWZtmIOfGPv5cudMaQJbKBhE/Xw2L|W5ctSHOT/EchQvobcWLX1OntlwKBgQDXnIe5v1EGUIB2gLPCOpz25FtLKJNyPGeh|l+FLcN3xtzKlLQucT1JJAspaMBni0Ir6pu6X8GWxmO9qKhDA8arW/PCh6CNrbxPy|Zmmwj0k070qz/9OqbJVngVOIMphKj4x6GAjhvCKThSmauLI9ja9BatxPKh/CaOJ+|JYOKDlXDbwKBgQCSgdZMoJHpc8xZALa+Cq4IOmdmYJxfwCr6NmD+mPoIdawIreaS|VLx9M8vgEC1QSvb7ZsEPG7iZcHz1Vhn7e0YCUoRlqByshpY+B+2SsQE4Cc1jfnYF|ZIApSDPojl2wUBMDxihuq2Q8Bb2Cum2NYfGbo2Vb+Pps8RqGdA7EYe2C9QKBgHBb|eb8qG6cWvFsEpqhIsxNV3N1Fv9B/+eETrKwLnR0hQpsg5jQGgfLaKWjmOBciZcpI|w30aIWRzNhA065YgWc6+8QbuWcbak6J2DA2eHaAgMuWqIztkalcN5eHLu+De/W2C|qN45lCsb8ZpXNUsuUm3cqgH3CaXd0mm6UtnWroqxAoGAY4FK7yt4Y+Y6MVx3kKUO|rxSPI0KqL9mH2JyWFexZziV3RuE7DIf+IFVPLsrxSrfsZqYOFuBamfPVLVHNx+Ma|dbDPH+KzOc5sMNDkLebWg+qddpTm6Zy0mUACRbFijF1TjPRiwnpEpScGUSS+Cs8U|Coe+cQBuoTsIHpowYjVbps4=|-----END PRIVATE KEY-----"\
DKIM_SELECTOR="hcfmailer" \
docker run -e DKIM_PRIVATE_KEY -e highcanfly/smtp-relay:latest
```
later in the log you will see the DNS proposal record.  
```log
hcfmailer._domainkey IN      TXT     ( "v=DKIM1; h=sha256; k=rsa; s=email; "        "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy5CQAMO7X34R7sl1uZHzdSAb236xVfWcmr86zDHof1oWeE+87aOcd59SrE7R3WGFeX+zuIvdkK13r5gkI82sDiNqNjkNLjUnuzPP8kmJss/C73y3ANf70Spbif/tFir69kc+VZI03h96r5iRo6xTb8JI82D8NZ88vlXfbv0SztDB06C7wq/XDgciYuMPbI/527rIvN3RMH5FtK"
       "osqVoGwivcpSyX4Sb1f5F5QRSIx6IPFjCelS1hdUhQlAdcFNjwYtZsEF/K0tfHrU3fqn/ng6DFhax2LH00lavCuma7mqxKVvOwJi0+bnmH+lKVhWcormjTB8Ejl8EHRBfTposJeQIDAQAB" )  ; ----- DKIM key mail for example.org
```
If you want to compute the TXT value locally, having DKIM_PRIVATE_KEY correctly setted:  
```sh
echo $DKIM_PRIVATE_KEY | tr '|' '\n' | openssl rsa -pubout 2> /dev/null | sed -e '1d' -e '$d' | tr -d '\n' | echo "v=DKIM1; h=sha256; k=rsa; s=email; p=$(</dev/stdin)"
```

## Deployment Options

## Docker Deployment
Get image at [highcanfly/smtp-relay:latest](https://hub.docker.com/r/highcanfly/smtp-relay)
```sh
docker pull highcanfly/smtp-relay:latest
```

### Kubernetes Deployment with Helm

The project includes a Helm chart (`flex-smtpd`) that makes it easy to deploy the SMTP relay service in a Kubernetes environment.

#### Prerequisites
- Kubernetes cluster
- Helm installed
- If using TLS certificates: cert-manager installed (for automatic certificate management)

#### Installing the Chart

1. Create a values file with your configuration (e.g., `my-values.yaml`):

```yaml
config:
  useCloudflareDDNS: "1"
  useLetsEncrypt: "1"
  useDKIMParsing: "1"
  postfixHostname: "smtp-relay.yourdomain.com"
  allowedSenderDomains: "yourdomain.com yourbusiness.com"
  dkimSelector: "mail"
  dkimPrivateKey: "-----BEGIN PRIVATE KEY-----|YOUR_PRIVATE_KEY_HERE|-----END PRIVATE KEY-----"
  
  # If using CloudFlare for DNS and DDNS
  cloudflareDnsRecords: "smtp-relay.yourdomain.com"
  cloudflareApiKey: "your-cloudflare-api-key"
  cloudflareZoneId: "your-cloudflare-zone-id"
  
  # For TLS with cert-manager
  certificateSecretName: "smtp-relay-tls"
  certificateIssuer: "letsencrypt-prod"
  certificateIssuerKind: "ClusterIssuer"
  
  # If relaying to another SMTP server
  relayHost: "[smtp.provider.com]:587"
  relayHostUser: "your-username"
  relayHostPassword: "your-password"
```

2. Install the chart:

```sh
helm install smtp-relay ./helm/flex-smtpd --values my-values.yaml --namespace mail --create-namespace
```

#### Key Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.useCloudflareDDNS` | Enable CloudFlare DDNS update | "0" |
| `config.useLetsEncrypt` | Use Let's Encrypt for TLS certificates | "0" |
| `config.useDKIMParsing` | Enable DKIM key parsing | "1" |
| `config.postfixHostname` | The hostname for your SMTP server | "smtp-relay.domain.com" |
| `config.allowedSenderDomains` | Space-separated list of domains allowed to send mail | "domain.com" |
| `config.dkimSelector` | The DKIM selector to use | "dkim-flex-smtpd" |
| `config.certificateSecretName` | Name of the TLS certificate secret | "" |

#### Using Cert-Manager Integration

When `config.certificateSecretName` is set, the chart will create a Certificate resource using cert-manager. Make sure you have a valid issuer configured in your cluster.

#### Resource Limits

The chart comes with default resource limits that can be adjusted:

```yaml
resources:
  limits:
    cpu: 900m
    memory: 256Mi
  requests:
    cpu: 10m
    memory: 40Mi
```

For more configuration options, see [bokysan/docker-postfix repository](https://github.com/bokysan/docker-postfix)
