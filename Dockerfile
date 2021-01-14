FROM caddy:2.3.0-alpine

MAINTAINER SPT simon.temple@amalto.com

# Patch in our new image
COPY ./bin/caddy /usr/bin/

RUN apk update
RUN apk upgrade

# Needed for certutils (required for self signed generation for localhost)
RUN apk add nss-tools

# Add fail2ban
ENV FAIL2BAN_VERSION="0.11.1" \
    TZ="UTC"

RUN apk --update --no-cache add \
    curl \
    ipset \
    iptables \
    ip6tables \
    kmod \
    nftables \
    python3 \
    py3-setuptools \
    ssmtp \
    tzdata \
    wget \
    whois \
  && apk --update --no-cache add -t build-dependencies \
    build-base \
    py3-pip \
    python3-dev \
  && pip3 install --upgrade pip \
  && pip3 install dnspython3 pyinotify \
  && cd /tmp \
  && curl -SsOL https://github.com/fail2ban/fail2ban/archive/${FAIL2BAN_VERSION}.zip \
  && unzip ${FAIL2BAN_VERSION}.zip \
  && cd fail2ban-${FAIL2BAN_VERSION} \
  && 2to3 -w --no-diffs bin/* fail2ban \
  && python3 setup.py install \
  && apk del build-dependencies \
  && rm -rf /etc/fail2ban/jail.d /var/cache/apk/* /tmp/*

COPY entrypoint1.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

VOLUME [ "/f2bdata" ]

ENTRYPOINT [ "/entrypoint.sh" ]