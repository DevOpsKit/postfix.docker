ARG ALPINE_VERSION=3.9.5
ARG VERSION=0.0

FROM alpine:$ALPINE_VERSION

LABEL version=${VERSION}
LABEL description="Alpine based postfix image. Configurable from postfix command options."
LABEL maintainer="devopskit@gmail.com"

COPY ./entrypoint.sh /entrypoint.sh
RUN apk add --no-cache postfix bash

VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]