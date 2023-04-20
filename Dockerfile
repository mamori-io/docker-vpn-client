FROM alpine:3.17
MAINTAINER Daniel Parnell <dparnell@mamori.io>

RUN set -ex \
# 1. install pptpclient
    && echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk --update --no-progress upgrade \
    && apk add --no-progress ca-certificates pptpclient@testing \
# 2. build and install openconnect (ref: https://github.com/04n0/docker-openconnect-client)
## 2.1 install runtime and build dependencies
    && apk add --no-progress --virtual .openconnect-run-deps \
               gnutls gnutls-utils iptables libev libintl \
               libnl3 libseccomp linux-pam lz4-libs openssl \
               libxml2 nmap-ncat socat openssh-client \
               bash curl ip6tables iptables openvpn shadow \
               strongswan xl2tpd ppp openconnect\
## 2.2 download vpnc-script
    && mkdir -p /etc/vpnc \
    && curl https://gitlab.com/openconnect/vpnc-scripts/raw/master/vpnc-script -o /etc/vpnc/vpnc-script \
    && chmod 750 /etc/vpnc/vpnc-script \
## 2.5 install dependency packages for openconnect csd wrapper
    && apk add --no-progress bash curl xmlstarlet \
# 3. fix ip command location for the pptp client
    && ln -s "$(which ip)" /usr/sbin/ip \
# 3.1 set things up for ipsec
    && mkdir -p /var/run/xl2tpd \
    && touch /var/run/xl2tpd/l2tp-control\
# 4. cleanup
    && rm -rf /var/cache/apk/* /tmp/* ~/.gnupg

COPY content /

ENTRYPOINT ["/entrypoint.sh"]
