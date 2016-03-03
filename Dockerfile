FROM jboss/wildfly:10.0.0.Final

USER root

RUN curl -O "http://www.pirbot.com/mirrors/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
RUN echo "516923b3955b6035ba6b0a5b031fbd8b  apache-maven-3.3.9-bin.tar.gz" > MD5SUM
RUN md5sum -c MD5SUM
RUN mkdir /opt/jboss/maven
RUN tar -xf apache-maven-3.3.9-bin.tar.gz --strip-components=1 -C /opt/jboss/maven
RUN rm -f MD5SUM

ADD . /src

RUN cd /src && \
    M2_HOME=/opt/jboss/maven \
    M2=$M2_HOME/bin \
    PATH=$M2:$PATH \
    mvn clean verify $MAVEN_ARGS && \
    cp target/postgresql.jar /opt/jboss/wildfly/standalone/deployments/ && \
    cp target/wildfly-demo-app.war /opt/jboss/wildfly/standalone/deployments/

ADD conf/standalone.xml /opt/jboss/wildfly/standalone/configuration/

USER jboss

