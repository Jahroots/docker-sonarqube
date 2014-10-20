#!/bin/sh

export JAVA_HOME=/opt/jdk && export PATH=$PATH:$JAVA_HOME/bin
/opt/sonarqube-4.5/bin/linux-x86-64/sonar.sh start