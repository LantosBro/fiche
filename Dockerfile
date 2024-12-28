ARG ALPINE_VERSION="3"
# Stage 1 · builder
FROM alpine:${ALPINE_VERSION} AS builder

WORKDIR /usr/src/fiche
COPY . .

RUN apk update && apk add \
    make \
    gcc \
    g++ && \
    make && \
    make install && \
    make clean

# Stage 2 · app
FROM alpine:${ALPINE_VERSION} AS app

RUN apk update && apk add nginx
RUN mkdir -p /www
RUN chown -R nginx: /var/lib/nginx
RUN chown -R nginx: /www
COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /opt/fiche
COPY --from=builder /usr/local/bin/fiche /usr/local/bin/fiche
COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /opt/fiche/code

ENTRYPOINT ["/docker-entrypoint.sh"]
