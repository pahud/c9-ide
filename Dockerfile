FROM alpine:3.5 as builder

RUN apk add --update --no-cache tmux curl nodejs bash openssh-client

RUN apk add --update --no-cache --virtual mypacks g++ make python  git py-pip python-dev  \
&& rm -rf /var/cache/apk/*

RUN git clone -b master --single-branch git://github.com/c9/core.git /opt/cloud9 \
&& curl -s -L https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
&& /opt/cloud9/scripts/install-sdk.sh \
&& rm -rf /opt/cloud9/.git \
&& rm -rf /tmp/* \
&& npm cache clean

RUN apk del mypacks

#
# Caddy
#
FROM abiosoft/caddy as caddy


#
# prepare the runtime
#
FROM alpine:3.5 as runtime


# Let's Encrypt Agreement
ENV ACME_AGREE="true"

COPY --from=builder /opt/cloud9 /opt/cloud9
COPY --from=builder /root /root


VOLUME /root/.caddy /srv
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=caddy /etc/Caddyfile /etc/Caddyfile
COPY --from=caddy /srv/index.html /srv/index.html
COPY --from=caddy /bin/parent /bin/parent


RUN apk add --update --no-cache tmux curl nodejs bash supervisor

ADD cloud9.conf /etc/supervisor.d/cloud9.ini
ADD caddy.conf /etc/supervisor.d/caddy.ini
ADD Caddyfile /tmp/Caddyfile.tmp
ADD entrypoint.sh /root/entrypoint.sh

ENV DOMAIN domain.com
ENV EMAIL admin@domain.com

RUN mkdir /workspace /var/log/supervisor

VOLUME /workspace

WORKDIR /workspace

ENV MYUSERNAME username
ENV MYPASSWORD password

EXPOSE 80 443 2015

ENTRYPOINT ["/root/entrypoint.sh"]
