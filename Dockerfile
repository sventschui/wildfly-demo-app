FROM jboss/wildfly:10.0.0.Final

RUN http_proxy=http://default-http-proxy.default.svc.cluster.local:8080 https_proxy=http://default-http-proxy.default.svc.cluster.local:8080 curl -O "http://www.pirbot.com/mirrors/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
RUN echo "516923b3955b6035ba6b0a5b031fbd8b  apache-maven-3.3.9-bin.tar.gz" > MD5SUM
RUN md5sum -c MD5SUM
RUN tar -xvfc apache-maven-3.3.9-bin.tar.gz /opt/maven
RUN rm -f MD5SUM

RUN M2_HOME=/opt/maven \
    M2=/opt/maven$M2_HOME/bin \
    PATH=$M2:$PATH \
    mvn clean verify

ADD conf/standalone.xml /opt/jboss/wildfly/standalone/configuration/

ADD target/postgresql.jar /opt/jboss/wildfly/standalone/deployments/

ADD target/wildfly-demo-app.war /opt/jboss/wildfly/standalone/deployments/
