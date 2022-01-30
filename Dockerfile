FROM openjdk:8-jre-alpine

MAINTAINER test@xxx.com

VOLUME /tmp

RUN mkdir -p /opt/sfbn-server

WORKDIR /opt/sfbn-server

EXPOSE 8051

ADD ./target/jenkins-one.jar ./app.jar

ENV JAVA_OPTS = " -Xms128m -Xmx512m -Duser.timezone=PRC "

ENTRYPOINT ["java", "-jar", "-Xms128m", "-Xmx512m", "-Duser.timezone=PRC", "app.jar"]