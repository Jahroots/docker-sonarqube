#!/bin/sh

MYSQL=`which mysql`
MYSQL_ADMIN=`which mysqladmin`
SONAR_BASE_NAME="sonar"
SONAR_BASE_EXIST=`${MYSQL} -uroot -e "show databases;" | grep ${SONAR_BASE_NAME}`
Q1="CREATE DATABASE IF NOT EXISTS sonar;"
Q2="CREATE USER 'sonar'@'localhost' IDENTIFIED BY 'sonar';"
Q3="CREATE USER 'sonar'@'%' IDENTIFIED BY 'sonar';"
Q4="GRANT ALL PRIVILEGES ON sonar.* TO 'sonar'@'localhost' WITH GRANT OPTION;"
Q5="GRANT ALL PRIVILEGES ON sonar.* TO 'sonar'@'%' WITH GRANT OPTION;"
Q6="GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;";
LQ="FLUSH PRIVILEGES;"
SQL="$Q1$Q2$Q3$Q4$Q5$Q6$LQ"

if [ "${SONAR_BASE_EXIST}" = "" ]; then
	$MYSQL_ADMIN --silent --wait=30 ping || exit 1
    $MYSQL -uroot -e "$SQL"
fi

export JAVA_HOME=/opt/jdk && export PATH=$PATH:$JAVA_HOME/bin
/opt/sonarqube/bin/linux-x86-64/sonar.sh start
