FROM dockerfile/mysql:latest
MAINTAINER Jahroots "Jahroots@gmail.com"

RUN apt-get update
RUN apt-get -y install curl unzip openssh-server supervisor 

### Installation Java
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 20
ENV JAVA_VERSION_BUILD 26
ENV JAVA_PACKAGE       server-jre

RUN curl -kLOH "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"\
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz
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

### Configure ssh
RUN mkdir -p /var/run/sshd
RUN chmod 755 /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

### Installation and configuration of SonarQube
RUN curl -O http://dist.sonar.codehaus.org/sonarqube-4.5.zip
RUN unzip sonarqube-4.5.zip -d /opt
RUN	rm sonarqube-4.5.zip
RUN rm -rf /opt/sonarqube-4.5/bin/linux-ppc-64 \
           /opt/sonarqube-4.5/bin/linux-x86-32 \
           /opt/sonarqube-4.5/bin/macosx-universal-64 \
           /opt/sonarqube-4.5/bin/solaris-sparc-32 \
           /opt/sonarqube-4.5/bin/solaris-sparc-64 \
           /opt/sonarqube-4.5/bin/solaris-x86-32 \
           /opt/sonarqube-4.5/bin/windows-x86-32 \
           /opt/sonarqube-4.5/bin/windows-x86-64
ADD startSonar.sh /opt/startSonar.sh
RUN chmod +x /opt/startSonar.sh

RUN sed -e 's/^#sonar.jdbc.url=jdbc:mysql/sonar.jdbc.url=jdbc:mysql/' -e 's/^#sonar.jdbc.username/sonar.jdbc.username/' -e 's/^#sonar.jdbc.password/sonar.jdbc.password/' /opt/sonarqube-4.5/conf/sonar.properties > /opt/sonarqube-4.5/conf/sonar.properties.new
RUN mv /opt/sonarqube-4.5/conf/sonar.properties /opt/sonarqube-4.5/conf/sonar.properties.bak
RUN mv /opt/sonarqube-4.5/conf/sonar.properties.new /opt/sonarqube-4.5/conf/sonar.properties

### Clean
RUN apt-get -y autoclean
RUN apt-get -y clean
RUN apt-get -y autoremove

### Configure Supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

### Configure volumes
VOLUME ["/opt/sonarqube-4.5"]

###Expose ports
EXPOSE 22 9000

### Start Supervisor
CMD ["/usr/bin/supervisord","-n"]