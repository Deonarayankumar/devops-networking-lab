"""Simple Flask backend for the networking lab."""

from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/health")
def health():
    return jsonify(status="ok", service="networking-lab-backend")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
