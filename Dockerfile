FROM centos:centos7.2.1511
MAINTAINER "John Siegrist" <john.siegrist@complects.com>
ENV REFRESHED_AT=2016-10-12

ENV TARGET=/target
ENV RPM_BUILD_DIR=/rpmbuild
ENV SOURCES=/sources
ENV WORKSPACE=/workspace

# copy dependencies file
COPY ./assets/dependencies /var/run/docker-build-deps

RUN yum -y updateinfo \
    && yum -y install $(cat /var/run/docker-build-deps) \
    && yum -y swap -- remove systemd-container-libs -- install systemd-libs \
    && yum -y upgrade \
    && yum clean all

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

CMD ["/usr/bin/buildrpm"]
