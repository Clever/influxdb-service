FROM debian:jessie

RUN apt-get update && apt-get install -y wget

ENV INFLUXDB_VERSION 0.13.0
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm -fr influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

ADD config.toml /etc/influxdb/influxdb.conf
ADD collectd_types.db /usr/share/collectd/types.db

RUN echo "influxdb soft nofile unlimited" >> /etc/security/limits.conf
RUN echo "influxdb riak hard nofile unlimited" >> /etc/security/limits.conf
# required for collectd UDP
RUN echo "net.core.rmem_max=8388608" >> /etc/sysctl.conf

# admin http
EXPOSE 83 86

VOLUME ["/influxdb"]
CMD ["influxd", "--config=/etc/influxdb/influxdb.conf", "--pidfile=/tmp/influxdb.pid"]
