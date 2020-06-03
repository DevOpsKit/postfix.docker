ARG ALPINE_VERSION=3.12.0
ARG VERSION=0.0

FROM alpine:$ALPINE_VERSION

LABEL version=${VERSION}
LABEL description="Alpine based postfix image. Configurable from postfix command options."
LABEL maintainer="devopskit@gmail.com"

COPY ./entrypoint.sh /entrypoint.sh
RUN apk add --no-cache postfix=3.5.2-r1 bash
VOLUME /data

ENTRYPOINT ["/entrypoint.sh"]