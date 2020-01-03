FROM openjdk:8u212-jre

WORKDIR /opt

ARG HADOOP_VERSION=3.1.2
ARG HIVE_VERSION=3.1.2

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-${HIVE_VERSION}-bin

COPY lib/hadoop-${HADOOP_VERSION}.tar.gz /opt/hadoop-${HADOOP_VERSION}.tar.gz
COPY lib/apache-hive-${HIVE_VERSION}-bin.tar.gz /opt/apache-hive-${HIVE_VERSION}-bin.tar.gz
RUN tar zxf /opt/hadoop-${HADOOP_VERSION}.tar.gz && tar zxf /opt/apache-hive-${HIVE_VERSION}-bin.tar.gz
RUN mv ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-${HADOOP_VERSION}.jar ${HIVE_HOME}/lib/ && \
    mv ${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-*.jar ${HIVE_HOME}/lib/ && \
    rm *.tar.gz
RUN apt-get update && apt-get install -qq -y python libpostgresql-jdbc-java

COPY conf ${HIVE_HOME}/conf
COPY conf/core-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY start.sh .
RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME}

USER hive
WORKDIR $HIVE_HOME
ENV PYTHON_CMD=/usr/bin/python
ENTRYPOINT ["/opt/start.sh"]
