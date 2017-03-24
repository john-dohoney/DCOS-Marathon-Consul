FROM alpine:latest

MAINTAINER John Dohoney "john.dohoney@gmail.com"

RUN apk update &&\
  apk add --update curl &&\
  curl https://releases.hashicorp.com/consul/0.7.4/consul_0.7.4_linux_386.zip -o consul.zip &&\
  unzip consul.zip  &&\
  rm consul.zip &&\
  mv consul /bin/consul &&\
  chmod a+x /bin/consul &&\
  mkdir -p /opt/consul/server/conf.d /opt/consul/agent/conf.d &&\
  apk del openssl libssh2 curl

ADD scripts/setUpConsul.sh /setUpConsul.sh
RUN chmod 755 /setUpConsul.sh
# export ports for various purposes if needed
EXPOSE 8300 
EXPOSE 8301 
EXPOSE 8301/udp 
EXPOSE 8302 
EXPOSE 8302/udp 
EXPOSE 8400 
EXPOSE 8500 
EXPOSE 8600 
EXPOSE 8600/udp

ENTRYPOINT ["/bin/sh", "/setUpConsul.sh"]
