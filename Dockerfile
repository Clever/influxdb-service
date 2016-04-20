FROM google/debian:wheezy

RUN apt-get update && apt-get install -y wget

ENV INFLUXDB_VERSION 0.8.9
RUN wget http://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm -fr influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

ADD config.toml /opt/influxdb/shared/config.toml

RUN echo "influxdb soft nofile unlimited" >> /etc/security/limits.conf
RUN echo "influxdb riak hard nofile unlimited" >> /etc/security/limits.conf

# Admin http-api raft protobuf
EXPOSE 8083 8086 8090 8099

VOLUME ["/data"]
CMD ["/usr/bin/influxdb", "--config=/opt/influxdb/shared/config.toml", "--pidfile=/tmp/influxdb.pid"]
