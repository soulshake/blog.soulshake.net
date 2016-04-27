FROM alpine:latest
MAINTAINER AJ Bowen <aj@soulshake.net>

ENV HUGO_VERSION=0.15

RUN apk add --update wget ca-certificates && \
  wget --no-check-certificate https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  tar xzf hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  rm -r hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  mv hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 /usr/bin/hugo && \
  rm -r hugo_${HUGO_VERSION}_linux_amd64 && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

COPY ./src /src
WORKDIR /src
EXPOSE 80

# delete old public files
RUN rm -rf /src/public
RUN rm -rf /data/www

ENV HUGO_THEME=blackburn
ENV HUGO_BASEURL=blog.soulshake.net

# build the site
RUN hugo \
    --verbose \
    --log=true \
    --logFile=hugo.log \
    --theme=${HUGO_THEME} \
    --baseUrl=${HUGO_BASEURL} \
    #--ignoreCache=true \
    --source=/src \
    --destination=/data/www \
    --config=/src/config.toml

#COPY /output/ /data/www
COPY ./src/content/ /data/www-md
VOLUME /data

ENTRYPOINT hugo server \
    --verbose \
    --log=true \
    --logFile=hugo.log \
    --verboseLog=true \
    --renderToDisk=true \
    #--ignoreCache=true \
    --source=/src \
    --destination=/data/www \
    --watch=true \
    --config=/src/config.toml \
    --theme=${HUGO_THEME} \
    --baseUrl=${HUGO_BASEURL} \
    --bind=0.0.0.0 \
    --port=80
