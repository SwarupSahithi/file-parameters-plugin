
FROM jenkins/jenkins:lts

USER root

RUN apt-get update \
    && apt-get install -y maven \
    && rm -rf /var/lib/apt/lists/*

ENV MAVEN_HOME=/usr/share/maven \
    JAVA_HOME=/usr/local/openjdk-17 \
    PATH=$MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH

USER jenkins
