FROM google/debian:jessie

RUN apt-get update && apt-get install -y wget

ENV INFLUXDB_VERSION 0.12.1-1
RUN wget http://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm -fr influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

ADD config.toml /etc/influxdb/influxdb.conf

RUN echo "influxdb soft nofile unlimited" >> /etc/security/limits.conf
RUN echo "influxdb riak hard nofile unlimited" >> /etc/security/limits.conf

# admin http
EXPOSE 83 86

VOLUME ["/influxdb"]
CMD ["influxd", "--config=/etc/influxdb/influxdb.conf", "--pidfile=/tmp/influxdb.pid"]
