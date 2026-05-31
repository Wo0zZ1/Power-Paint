#!/bin/sh
set -eu

if [ -z "${DOMAIN:-}" ]; then
  echo "[bootstrap-cert] DOMAIN is not set, skip fallback certificate bootstrap"
  exit 0
fi

CERT_DIR="/etc/letsencrypt/live/${DOMAIN}"
FULLCHAIN_PATH="${CERT_DIR}/fullchain.pem"
PRIVKEY_PATH="${CERT_DIR}/privkey.pem"

if [ -s "$FULLCHAIN_PATH" ] && [ -s "$PRIVKEY_PATH" ]; then
  echo "[bootstrap-cert] Certificate files already exist for ${DOMAIN}"
  exit 0
fi

echo "[bootstrap-cert] Certificate files not found for ${DOMAIN}, generating temporary self-signed certificate"

apk add --no-cache openssl >/dev/null
mkdir -p "$CERT_DIR"

openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
  -subj "/CN=${DOMAIN}" \
  -keyout "$PRIVKEY_PATH" \
  -out "$FULLCHAIN_PATH"

echo "[bootstrap-cert] Temporary certificate created for ${DOMAIN}"