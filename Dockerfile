FROM bcit/alpine:3.9 as gocd-server-tarball
ADD https://download.gocd.org/binaries/19.5.0-9272/generic/go-server-19.5.0-9272.zip /go-server.zip
RUN unzip /go-server.zip \
 && mv /go-server-19.5.0 /go-server \
 && tar czf /go-server.tar.gz go-server -C /

FROM bcit/alpine:3.9
LABEL maintainer="jesse@weisner.ca"
LABEL gocd.version="19.5.0"
LABEL description="GoCD server based on alpine version 3.9"
LABEL url="https://www.gocd.org"
LABEL gocd.full.version="19.5.0-9272"
LABEL build_id="1567195587"

ENV RUNUSER go
ENV FULLVERSION 19.5.0-9272

# force encoding
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

EXPOSE 8153 8154

COPY --from=gocd-server-tarball /go-server.tar.gz /go-server.tar.gz

RUN mkdir /go-server /go-working-dir /godata \
 && chown 0:0 /go-server /go-working-dir /godata \
 && chmod 775 /go-server /go-working-dir /godata
VOLUME /go-server
VOLUME /go-working-dir
VOLUME /godata

COPY 20-go-server.sh /docker-entrypoint.d/

RUN apk add --no-cache \
        bash \
        curl \
        git \
        mercurial \
        nss \
        openjdk8-jre-base \
        openssh-client \
        subversion

COPY 30-logback-include.sh /docker-entrypoint.d/
COPY logback-include.xml /logback-include.xml
COPY install-gocd-plugins /usr/local/sbin/install-gocd-plugins
COPY 99-gocd.sh /docker-entrypoint.d/

CMD [ "/go-server/server.sh" ]
