ARG IMAGE_MAJOR_VERSION=39
ARG BASE_IMAGE_URL=ghcr.io/ublue-os/silverblue-main

FROM ${BASE_IMAGE_URL}:${IMAGE_MAJOR_VERSION}

ARG RECIPE=recipe.yml
ARG IMAGE_REGISTRY=ghcr.io/ublue-os

COPY cosign.pub /usr/share/ublue-os/cosign.pub

# Copy bling
COPY --from=ghcr.io/ublue-os/bling:latest /rpms /tmp/bling/rpms
COPY --from=ghcr.io/ublue-os/bling:latest /files /tmp/bling/files

# Copy build scripts & configuration
COPY build.sh /tmp/build.sh
COPY config /tmp/config/

# Copy modules
COPY --from=ghcr.io/ublue-os/bling:latest /modules /tmp/modules/

# `yq` is used for parsing the yaml configuration
# It is copied from the official container image since it's not available as an RPM.
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

RUN chmod +x /tmp/build.sh && /tmp/build.sh && \
    sed -i '/^PRETTY_NAME/s/Silverblue/Darkblue/' /usr/lib/os-release && \
    rm -rf /tmp/* /var/* && \
    ostree container commit
