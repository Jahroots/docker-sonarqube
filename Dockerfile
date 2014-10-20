#FROM jahroots/java
#MAINTAINER Jahroots "Jahroots@gmail.com"

FROM debian:latest
MAINTAINER Jahroots "Jahroots@gmail.com"

RUN apt-get update
RUN apt-get -y install curl unzip openssh-server supervisor

ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 20
ENV JAVA_VERSION_BUILD 26
ENV JAVA_PACKAGE       server-jre

#RUN curl -kLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"\
#  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz
RUN curl -O http://192.168.1.25/dockerTmp/server-jre-8u20-linux-x64.tar.gz
RUN gunzip ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz &&\
    tar -xf ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar -C /opt &&\
    rm ${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar &&\
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk &&\
    rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /opt/jdk/lib/*javafx* \
           /opt/jdk/jre/lib/plugin.jar \
           /opt/jdk/jre/lib/ext/jfxrt.jar \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/plugin \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/jre/lib/amd64/libprism_*.so \
           /opt/jdk/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/jre/lib/amd64/libglass.so \
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/jre/lib/amd64/libjfx*.so  


# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin

#RUN apt-get update && apt-get install -y unzip openssh-server supervisor
RUN mkdir -p /var/run/sshd
RUN chmod 755 /var/run/sshd
RUN mkdir -p /var/log/supervisor

### Configure ssh
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

#RUN curl -O http://dist.sonar.codehaus.org/sonarqube-4.5.zip
RUN curl -O http://192.168.1.25/dockerTmp/sonarqube-4.5.zip
RUN unzip sonarqube-4.5.zip -d /opt
RUN	rm sonarqube-4.5.zip

### Clean
RUN apt-get -y autoclean
RUN apt-get -y clean
RUN apt-get -y autoremove

### Configure Supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/opt/sonarqube-4.5"]
EXPOSE 22 9000

###
CMD ["/usr/bin/supervisord","-n"]