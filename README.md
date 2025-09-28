# DevOps Networking Lab

Hands-on lab for reverse proxies, DNS resolution, HTTP debugging, and TLS termination patterns using Docker Compose.

## Architecture

```
Client → nginx (reverse proxy, :8080) → backend Flask app (:5000)
```

| Service | Port | Role |
|---------|------|------|
| `nginx` | 8080 | Reverse proxy, static headers, upstream routing |
| `backend` | 5000 (internal) | Flask API with health and debug endpoints |

## Quick Start

```bash
docker compose up --build
curl http://localhost:8080/health
curl http://localhost:8080/api/info
```

## Lab Exercises

1. **Reverse proxy** — Inspect `nginx/nginx.conf` upstream block and trace a request through both containers.
2. **DNS** — Run `scripts/dns-check.sh` against internal and external hostnames.
3. **HTTP debug** — Use `scripts/http-debug.sh` to compare headers, status codes, and timing.
4. **TLS** — Follow `docs/tls-lab.md` to add self-signed certificates and HTTPS on nginx.

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/dns-check.sh` | Resolve hostnames and compare A/CNAME records |
| `scripts/http-debug.sh` | Verbose curl with timing, headers, and body |

## Troubleshooting

See `docs/troubleshooting.md` for common proxy, DNS, and container networking issues.

## Requirements

- Docker 24+ and Docker Compose v2
- Bash (for helper scripts; Git Bash or WSL on Windows)
