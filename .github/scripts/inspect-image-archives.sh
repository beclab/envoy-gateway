#!/usr/bin/env bash
# Read docker-archive tar(s) built by CI; emit digests and file checksums for release notes.
set -euo pipefail

DIST_DIR="${1:?dist dir}"
TAG="${2:?tag}"

AMD64_TAR="${DIST_DIR}/envoy-gateway-${TAG}-linux-amd64.tar"
ARM64_TAR="${DIST_DIR}/envoy-gateway-${TAG}-linux-arm64.tar"

for f in "${AMD64_TAR}" "${ARM64_TAR}"; do
  test -s "${f}" || { echo "missing ${f}" >&2; exit 1; }
done

AMD64_SHA256="$(sha256sum "${AMD64_TAR}" | awk '{print $1}')"
ARM64_SHA256="$(sha256sum "${ARM64_TAR}" | awk '{print $1}')"

if command -v skopeo >/dev/null 2>&1; then
  AMD64_DIGEST="$(skopeo inspect docker-archive:"${AMD64_TAR}" --format '{{.Digest}}')"
  ARM64_DIGEST="$(skopeo inspect docker-archive:"${ARM64_TAR}" --format '{{.Digest}}')"
else
  AMD64_DIGEST="sha256:${AMD64_SHA256}"
  ARM64_DIGEST="sha256:${ARM64_SHA256}"
  echo "WARN: skopeo not found; using file sha256 as digest placeholder" >&2
fi

{
  echo "amd64_digest=${AMD64_DIGEST}"
  echo "arm64_digest=${ARM64_DIGEST}"
  echo "amd64_sha256=${AMD64_SHA256}"
  echo "arm64_sha256=${ARM64_SHA256}"
} >> "${GITHUB_OUTPUT}"

echo "amd64 ${AMD64_DIGEST} (${AMD64_SHA256})"
echo "arm64 ${ARM64_DIGEST} (${ARM64_SHA256})"
