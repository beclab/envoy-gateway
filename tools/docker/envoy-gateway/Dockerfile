FROM busybox@sha256:dc2d74b28e4cf8984fa52af1f39bc7c3d9c73760b41a74d629f5d11b1ab28616 AS source
# Create the data directory for eg
RUN mkdir -p /var/lib/eg && chmod -R 0777 /var/lib/eg

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/base-nossl:nonroot@sha256:f71dcb6329ea025d9956d40bde83d4bbdc9e314dadf41742eb32575d7cd5cdda
ARG TARGETPLATFORM
COPY $TARGETPLATFORM/envoy-gateway /usr/local/bin/
COPY --from=source /var/lib /var/lib

USER 65532:65532

ENTRYPOINT ["/usr/local/bin/envoy-gateway"]
