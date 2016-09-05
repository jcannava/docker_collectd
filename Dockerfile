FROM debian:latest
MAINTAINER jason@cannavale.com

RUN apt-get update
RUN apt-get install -y build-essential curl libcurl4-gnutls-dev \
                       libmysqlclient-dev libhiredis-dev liboping-dev \
                       libyajl-dev libpq-dev

RUN curl https://collectd.org/files/collectd-5.5.2.tar.gz | tar zxf -
RUN cd collectd*
RUN ./configure --prefix=/usr --sysconfdir=/etc/collectd --localstatedir=/var \
     --enable-debug
RUN grep -rl /proc/ . | xargs sed -i "s/\/proc\//\/host\/proc\//g"
RUN make all install
RUN make clean

WORKDIR /root
COPY configure.sh /root/configure.sh
RUN chmod +x /root/configure.sh
RUN mkdir -p /host
