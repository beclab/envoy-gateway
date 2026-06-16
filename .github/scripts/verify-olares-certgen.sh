#!/usr/bin/env bash
# Olares EG fork gate: patch must sit on upstream v1.8.0 and use 100y certgen lifetime.
set -euo pipefail

UPSTREAM_COMMIT="${UPSTREAM_COMMIT:-f7306b38f1ec3551cdbcb33ea01ad0903f9157fa}"

HEAD="$(git rev-parse HEAD)"
git merge-base --is-ancestor "${UPSTREAM_COMMIT}" HEAD

if ! grep -qE 'DefaultCertificateLifetime = 365 \* 100' internal/crypto/certgen.go; then
  echo "FAIL: expected DefaultCertificateLifetime = 365 * 100 in internal/crypto/certgen.go" >&2
  exit 1
fi

if grep -v '^[[:space:]]*//' internal/crypto/certgen.go | grep -qE 'DefaultCertificateLifetime = 365 \* 5'; then
  echo "FAIL: upstream 5y lifetime assignment still present" >&2
  exit 1
fi

echo "OK: olares certgen patch verified"
echo "  head=${HEAD}"
echo "  upstream_base=${UPSTREAM_COMMIT}"
