FROM debian:jessie
MAINTAINER AJ Bowen <aj@soulshake.net>

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    golang \
    python-pip \
    s3cmd \
    vim \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

#RUN pip install Pygments

ENV HUGO_VERSION 0.15
RUN curl -sSL https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux_amd64.tar.gz | tar -v -C /usr/local/bin -xz --strip-components 1 && \
    mv /usr/local/bin/hugo_${HUGO_VERSION}_linux_amd64 /usr/local/bin/hugo

#ENV GOPATH=$HOME/go
#RUN go get -v github.com/spf13/hugo
# add files
#RUN mkdir -p /usr/src/blog/themes
#WORKDIR /usr/src/blog/themes
#RUN git clone https://github.com/yoshiharuyamashita/blackburn.git
ENV HOME /home/hugo
ENV VIRTUAL_HOST "blog.soulshake.net, *.blog.soulshake.net"
RUN useradd --create-home --home-dir $HOME hugo \
    && chown -R hugo:hugo $HOME

COPY . /usr/src/blog
WORKDIR /usr/src/blog
# make sure files are owned by hugo user
RUN chown -R hugo:hugo /usr/src/blog
EXPOSE 80
EXPOSE 1313

USER hugo

RUN hugo
ENTRYPOINT [ "hugo", "-v", "serve", "--bind=0.0.0.0" ]
