FROM jboss/wildfly:10.0.0.Final

RUN mvn clean verify

ADD target/postgresql.jar /opt/jboss/wildfly/standalone/deployments/

ADD target/wildfly-demo-app.war /opt/jboss/wildfly/standalone/deployments/
