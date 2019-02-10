FROM abiosoft/caddy as caddy
FROM pahud/c9-ide:alpine-base as alpine-base-ide
FROM amazonlinux:latest as builder

RUN yum update -y && yum install -y tmux curl pip python2-pip tar git which awscli
RUN yum groupinstall "Development Tools" -y
RUN amazon-linux-extras install epel -y && \
yum install -y nodejs npm

RUN git clone -b master --single-branch git://github.com/c9/core.git /opt/cloud9 \
&& curl -s -L https://raw.githubusercontent.com/c9/install/master/link.sh | bash \
&& /opt/cloud9/scripts/install-sdk.sh \
&& rm -rf /opt/cloud9/.git \
&& rm -rf /tmp/* \
&& npm cache clean


# Let's Encrypt Agreement
ENV ACME_AGREE="true"
# set default C9_USER as ec2-user
ENV C9_USER="ec2-user"

VOLUME /root/.caddy /srv
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY --from=caddy /etc/Caddyfile /etc/Caddyfile
COPY --from=caddy /srv/index.html /srv/index.html
COPY --from=caddy /bin/parent /bin/parent

#install docker and others
RUN amazon-linux-extras install docker -y

# install supervisor
RUN pip install supervisor
COPY --from=alpine-base-ide /etc/supervisord.conf /etc/supervisord.conf

ADD cloud9.conf /etc/supervisor.d/cloud9.ini
ADD caddy.conf /etc/supervisor.d/caddy.ini
ADD Caddyfile /tmp/Caddyfile.tmp
ADD entrypoint.sh /root/entrypoint.sh
ADD bashrc /root/.bash_profile

ENV DOMAIN domain.com
ENV EMAIL admin@domain.com

RUN mkdir /workspace /var/log/supervisor

VOLUME /workspace

WORKDIR /workspace

ENV MYUSERNAME username
ENV MYPASSWORD password

EXPOSE 80 443 2015

ENTRYPOINT ["/root/entrypoint.sh"]
