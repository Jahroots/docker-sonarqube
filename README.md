Docker-SonarQube
================

A simple container inspired by:

- [dockerfile/mysql](https://registry.hub.docker.com/u/dockerfile/mysql/)

- [jeanblanchard/busybox-java](https://registry.hub.docker.com/u/jeanblanchard/busybox-java/)

The main purpose is to have a SonarQube server quickly and ready to be used, with a MySQL database.

Three services are running at startup:
- Open-Ssh Server on port 22
- MySQL on port 3306
- SonarQube on port 9000
