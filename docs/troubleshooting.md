# Troubleshooting Guide

## nginx returns 502 Bad Gateway

**Symptoms:** `curl http://localhost:8080/api/info` returns 502.

**Checks:**

1. Backend health: `docker compose ps` — backend should be `healthy`.
2. Upstream name: nginx resolves `backend` via Docker DNS on `app-net`.
3. Logs: `docker compose logs backend nginx`

**Common causes:**

- Backend not listening on `0.0.0.0:5000`
- Wrong upstream port in `nginx.conf`
- Backend still starting (wait for healthcheck)

## Connection refused on port 8080

- Confirm nginx is up: `docker compose ps nginx`
- Port conflict: another process may use 8080 — change mapping in `docker-compose.yml`

## DNS resolution inside containers

```bash
docker compose exec nginx getent hosts backend
docker compose exec backend getent hosts nginx
```

If resolution fails, verify both services share `app-net`.

## Headers missing downstream

The backend reads `X-Real-IP`, `X-Forwarded-For`, and `X-Forwarded-Proto`. If empty:

- Confirm requests go through nginx, not directly to backend
- Check `proxy_set_header` directives in `nginx.conf`

## Script issues on Windows

Run `dns-check.sh` and `http-debug.sh` in Git Bash or WSL:

```bash
bash scripts/http-debug.sh http://localhost:8080/health
```

## Healthcheck failures

Backend healthcheck uses Python `urllib`. If it fails repeatedly:

```bash
docker compose exec backend python -c "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:5000/health').read())"
```
