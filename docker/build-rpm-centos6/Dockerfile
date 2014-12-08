FROM centos:centos6
RUN yum -y groupinstall "Development Tools" && \
    yum -y install tar && \
    yum -y clean all && rm -r -f /var/cache/yum/*

