FROM jahroots/java
MAINTAINER Jahroots "Jahroots@gmail.com"

RUN apt-get update && apt-get install -y unzip openssh-server supervisor
RUN mkdir -p /var/run/sshd
RUN chmod 755 /var/run/sshd
RUN mkdir -p /var/log/supervisor

### Configure ssh
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

#RUN curl -O http://dist.sonar.codehaus.org/sonarqube-4.5.zip
RUN curl -O http://192.168.1.25/sonarqube-4.5.zip
RUN unzip sonarqube-4.5.zip -d /opt
RUN	rm sonarqube-4.5.zip

### Clean
RUN apt-get -y autoclean
RUN apt-get -y clean
RUN apt-get -y autoremove

VOLUME ["/opt/sonarqube-4.5"]
EXPOSE 22 9000

###
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]