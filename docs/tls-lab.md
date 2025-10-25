# TLS Lab — Self-Signed HTTPS on nginx

This exercise adds TLS termination at the nginx reverse proxy using a self-signed certificate.

## Generate a self-signed certificate

```bash
mkdir -p nginx/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout nginx/certs/server.key \
  -out nginx/certs/server.crt \
  -subj "/CN=localhost/O=NetworkingLab/C=US"
```

**Never commit real private keys.** For the lab, use locally generated certs only.

## Update nginx for HTTPS

Add a `listen 443 ssl` server block (or extend the existing one):

```nginx
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate     /etc/nginx/certs/server.crt;
    ssl_certificate_key /etc/nginx/certs/server.key;
    ssl_protocols       TLSv1.2 TLSv1.3;

    location / {
        proxy_pass http://backend_app;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```

Mount certs in `docker-compose.yml`:

```yaml
volumes:
  - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
  - ./nginx/certs:/etc/nginx/certs:ro
ports:
  - "8443:443"
```

## Test

```bash
curl -k https://localhost:8443/health
openssl s_client -connect localhost:8443 -servername localhost </dev/null 2>/dev/null | openssl x509 -noout -subject -dates
```

## Learning goals

- Understand TLS termination vs passthrough
- Inspect certificate chain and cipher suites
- See how `X-Forwarded-Proto` affects downstream apps
