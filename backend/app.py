"""Simple Flask backend for the networking lab reverse-proxy exercises."""

import os
import socket
from datetime import datetime, timezone

from flask import Flask, jsonify, request

app = Flask(__name__)

APP_ENV = os.getenv("APP_ENV", "development")
HOSTNAME = socket.gethostname()


@app.get("/health")
def health():
    return jsonify(
        status="ok",
        service="networking-lab-backend",
        env=APP_ENV,
        hostname=HOSTNAME,
        timestamp=datetime.now(timezone.utc).isoformat(),
    )


@app.get("/api/info")
def info():
    return jsonify(
        service="networking-lab-backend",
        version="1.0.0",
        hostname=HOSTNAME,
        client_ip=request.headers.get("X-Real-IP", request.remote_addr),
        forwarded_for=request.headers.get("X-Forwarded-For"),
        forwarded_proto=request.headers.get("X-Forwarded-Proto"),
        path=request.path,
        method=request.method,
    )


@app.get("/api/headers")
def headers_dump():
    return jsonify(dict(request.headers))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
