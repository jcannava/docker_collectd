FROM debian:latest
MAINTAINER jason@cannavale.com

RUN apt-get update
RUN apt-get install -y build-essential curl libcurl4-gnutls-dev \
                       libmysqlclient-dev libhiredis-dev liboping-dev \
                       libyajl-dev libpq-dev
RUN apt-get install -y git

RUN git clone https://https://github.com/signalfx/docker-collectd-plugin.git /usr/share/collectd/docker-collectd-plugin
RUN pip install -r /usr/share/collectd/docker-collectd-plugin

RUN mkdir -p /opt/collectd
RUN curl -o /opt/collectd.tar.gz https://collectd.org/files/collectd-5.5.2.tar.gz
RUN tar -xvzf /opt/collectd.tar.gz -C /opt
WORKDIR /opt/collectd-5.5.2
RUN ./configure --prefix=/usr --sysconfdir=/etc/collectd --localstatedir=/var \
     --enable-debug
RUN grep -rl /proc/ . | xargs sed -i "s/\/proc\//\/host\/proc\//g"
RUN make all install
RUN make clean

RUN mkdir -p /host
