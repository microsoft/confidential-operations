ARG CCF_PLATFORM
ARG CCF_VERSION=5.0.0-dev10

FROM mcr.microsoft.com/ccf/app/dev:${CCF_VERSION}-${CCF_PLATFORM} as builder
FROM mcr.microsoft.com/ccf/app/run-js:${CCF_VERSION}-${CCF_PLATFORM}

ARG CCF_PLATFORM
# ARG CERTS_DIR
# ARG CCHOST_CONFIG

COPY --from=builder /opt/ccf_${CCF_PLATFORM}/lib/libjs_generic.${CCF_PLATFORM}.so /usr/lib/ccf
COPY --from=builder /opt/ccf_${CCF_PLATFORM}/bin/*.js /app/
COPY --from=builder /opt/ccf_${CCF_PLATFORM}/bin/keygenerator.sh /app/
# COPY ${CERTS_DIR} /app/certs
# COPY ${CCHOST_CONFIG} /app/cchost_config.json
WORKDIR /app/

ENV CCF_PLATFORM=${CCF_PLATFORM}
CMD ["/bin/bash", "-c", "/usr/bin/cchost --config /app/cchost_config.json"]