FROM debian:jessie

MAINTAINER Henrik Sachse <t3x7m3@posteo.de>

#############################################
# ApacheDS installation
#############################################

ENV APACHEDS_VERSION=2.0.0-M24 \
APACHEDS_ARCH=amd64 \
APACHEDS_ARCHIVE=apacheds-${APACHEDS_VERSION}-${APACHEDS_ARCH}.deb \
APACHEDS_DATA=/var/lib/apacheds-${APACHEDS_VERSION} \
APACHEDS_USER=apacheds \
APACHEDS_GROUP=apacheds \
APACHEDS_INSTANCE=default \
APACHEDS_BOOTSTRAP=/bootstrap \
KERBEROS_REALM=EXAMPLE.COM \
KERBEROS_HOST=example.com


VOLUME ${APACHEDS_DATA}

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update \
    && apt-get install -y ldap-utils procps openjdk-7-jre-headless curl \
    && curl http://www.eu.apache.org/dist//directory/apacheds/dist/${APACHEDS_VERSION}/${APACHEDS_ARCHIVE} > ${APACHEDS_ARCHIVE} \
    && dpkg -i ${APACHEDS_ARCHIVE} \
    && rm ${APACHEDS_ARCHIVE} \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -Rf /var/lib/apt/lists/*

#############################################
# ApacheDS bootstrap configuration
#############################################


ADD instance/* ${APACHEDS_BOOTSTRAP}/conf/
RUN mkdir ${APACHEDS_BOOTSTRAP}/cache \
    && mkdir ${APACHEDS_BOOTSTRAP}/run \
    && mkdir ${APACHEDS_BOOTSTRAP}/log \
    && mkdir ${APACHEDS_BOOTSTRAP}/partitions \
    && chown -R ${APACHEDS_USER}:${APACHEDS_GROUP} ${APACHEDS_BOOTSTRAP}

ADD scripts/run.sh /run.sh
RUN chown ${APACHEDS_USER}:${APACHEDS_GROUP} /run.sh \
    && chmod u+rx /run.sh

#############################################
# ApacheDS wrapper command
#############################################
CMD ["/run.sh"]

