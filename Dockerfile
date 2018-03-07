# jhipster-centos7
FROM openshift/base-centos7

LABEL maintainer="Jiri Kremser <jkremser@redhat.com>"

ENV JHIPSTER_BUILDER_VERSION 1.0.0
ENV MAVEN_VERSION 3.5.2

LABEL io.k8s.description="Application created by jHipster" \
      io.k8s.display-name="jhipster-builder $JHIPSTER_BUILDER_VERSION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="jhipster"

# Maven 3.1.0 and higher is required, but there is only 3.0.5 in the yum repo
#MD5 chech-sum available at: 
#https://www.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz.md5
RUN yum install -y java-1.8.0-openjdk && yum clean all -y && \
    cd /opt/app-root/ && \
    curl -s http://www-us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    echo "948110de4aab290033c23bf4894f7d9a `ls apache-maven-$MAVEN_VERSION-bin.tar.gz`" | md5sum -c && \
    tar -xzf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    rm -rf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    ln -s apache-maven-$MAVEN_VERSION apache-maven && \
    ln -s /opt/app-root/apache-maven/bin/mvn /usr/bin/mvn

COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 8080
CMD ["/usr/libexec/s2i/usage"]
