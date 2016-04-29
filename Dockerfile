FROM alpine:latest
MAINTAINER AJ Bowen <aj@soulshake.net>

ENV HUGO_VERSION=0.15

RUN apk add --update wget ca-certificates python py-pip && \
  wget --no-check-certificate https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  tar xzf hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  rm -r hugo_${HUGO_VERSION}_linux_amd64.tar.gz && \
  mv hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 /usr/bin/hugo && \
  rm -r hugo_${HUGO_VERSION}_linux_amd64 && \
  apk del wget ca-certificates && \
  rm /var/cache/apk/*

RUN pip install click
RUN pip install arrow

COPY ./src /src
WORKDIR /src
EXPOSE 80

# delete old public files
RUN rm -rf /data/www
RUN rm -rf /data/www-md

ENV HUGO_THEME=blackburn
ENV HUGO_BASEURL=blog.soulshake.net

# build the site
RUN hugo \
    --verbose \
    --log=true \
    --logFile=hugo.log \
    --theme=${HUGO_THEME} \
    --baseUrl=${HUGO_BASEURL} \
    --ignoreCache=true \
    --source=/src \
    --destination=/data/www \
    --config=/src/config.toml


#COPY /output/ /data/www
RUN /make-markdown.py > /src/content/index.md
COPY ./make-markdown.py /make-markdown.py
COPY ./src/content/ /data/www-md

ENTRYPOINT hugo server \
    --verbose \
    --renderToDisk=true \
    --source=/src \
    --destination=/data/www \
    --watch=true \
    --config=/src/config.toml \
    --theme=${HUGO_THEME} \
    --baseUrl=${HUGO_BASEURL} \
    --bind=0.0.0.0 \
    --appendPort=false \
    --port=80
#--log=true \
#--logFile=hugo.log \
#--verboseLog=true \
#--ignoreCache=true \

VOLUME /data/www
VOLUME /data/www-md
