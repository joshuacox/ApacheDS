FROM openjdk:8-jre-alpine

MAINTAINER Henrik Sachse <t3x7m3@posteo.de>

#############################################
# ApacheDS installation
#############################################

ENV APACHEDS_VERSION=2.0.0-M24 \
APACHEDS_ARCH=amd64 \
APACHEDS_USER=apacheds \
APACHEDS_GROUP=apacheds \
APACHEDS_INSTANCE=default \
APACHEDS_BOOTSTRAP=/bootstrap \
KERBEROS_PORT=88 \
KERBEROS_REALM=EXAMPLE.COM \
KERBEROS_HOST=example.com

ENV APACHEDS_ARCHIVE=apacheds-${APACHEDS_VERSION}-${APACHEDS_ARCH}.tar.gz \
APACHEDS_DATA=/var/lib/apacheds-${APACHEDS_VERSION}

VOLUME ${APACHEDS_DATA}

RUN apk update \
  && apk upgrade \
  && apk add  --no-cache \
     openssl \
     bash \
     procps \
     curl \
     gettext \
  && mkdir /opt \
  && cd /opt \
  && curl http://www.eu.apache.org/dist//directory/apacheds/dist/${APACHEDS_VERSION}/${APACHEDS_ARCHIVE} > ${APACHEDS_ARCHIVE} \
  && tar zxf ${APACHEDS_ARCHIVE} \
  && rm ${APACHEDS_ARCHIVE} \
  && rm -rf /var/cache/apk/*

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

COPY templates /opt/templates

#############################################
# ApacheDS wrapper command
#############################################
CMD ["/run.sh"]
