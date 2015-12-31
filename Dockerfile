# VERSION 0.3
FROM centos:centos7.2.1511
MAINTAINER "John Siegrist" <john.siegrist@complects.com>
ENV REFRESHED_AT 2015-12-30

RUN yum -y updateinfo \
    && yum -y install \
      epel-release \
      https://repo.cloudrouter.org/centos/7.2/x86_64/cloudrouter-centos-repo-latest.noarch.rpm \
      rpm-build \
      rpmdevtools \
      yum-utils \
      vim \
      curl \
      wget \
    && yum -y swap -- remove systemd-container-libs -- install systemd-libs \
    && yum -y upgrade \
    && yum clean all

ENV TARGET /target
ENV RPM_BUILD_DIR /rpmbuild
ENV SOURCES /sources
ENV WORKSPACE /workspace

WORKDIR ${WORKSPACE}

RUN mkdir -p \
    ${TARGET} \
    ${RPM_BUILD_DIR} \
    ${SOURCES} \
    ${WORKSPACE}

RUN ln -sf ${RPM_BUILD_DIR} /root/rpmbuild \
    && rpmdev-setuptree

ADD ./assets/buildrpm /usr/bin/buildrpm
RUN chmod +x /usr/bin/buildrpm

VOLUME [ "${TARGET}", "${RPM_BUILD_DIR}", "${SOURCES}", "${WORKSPACE}" ]

CMD ["buildrpm"]
