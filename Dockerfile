FROM jboss/wildfly:10.0.0.Final

RUN sudo yum -y install wget && \
    wget "http://www.pirbot.com/mirrors/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz" && \
    echo "516923b3955b6035ba6b0a5b031fbd8b  apache-maven-3.3.9-bin.tar.gz" > MD5SUM && \
    md5sum -c MD5SUM && \
    tar -xvfc apache-maven-3.3.9-bin.tar.gz /opt/maven && \
    yum -y remove wget && \
    rm -f MD5SUM

RUN M2_HOME=/opt/maven \
    M2=/opt/maven$M2_HOME/bin \
    PATH=$M2:$PATH \
    mvn clean verify

ADD conf/standalone.xml /opt/jboss/wildfly/standalone/configuration/

ADD target/postgresql.jar /opt/jboss/wildfly/standalone/deployments/

ADD target/wildfly-demo-app.war /opt/jboss/wildfly/standalone/deployments/
