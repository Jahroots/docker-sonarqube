Docker-SonarQube
================

[![](https://images.microbadger.com/badges/version/jahroots/sonarqube.svg)](https://microbadger.com/images/jahroots/sonarqube "Get your own version badge on microbadger.com")

A simple container based on:

- [dockerfile/mysql](https://registry.hub.docker.com/u/dockerfile/mysql/)

and inspired by:

- [jeanblanchard/busybox-java](https://registry.hub.docker.com/u/jeanblanchard/busybox-java/)

The main purpose is to have a SonarQube server quickly and ready to be used, with a MySQL database.

Three services are running at startup:
- Open-Ssh Server on port 22
- MySQL on port 3306
- SonarQube on port 9000

Username: root   Password: root   for ssh

Username: root 					  for mysql

Username: sonar  Password: sonar  for mysql
