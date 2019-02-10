#!/bin/bash

[ -f /root/.profile ] && source /root/.profile

start_dockerd() {
    /usr/bin/dockerd \
    	--host=unix:///var/run/docker.sock \
    	--host=tcp://127.0.0.1:2375 \
    	--storage-driver=vfs &>/var/log/docker.log &
    tries=0
    d_timeout=60
    until docker info >/dev/null 2>&1
    do
    	if [ "$tries" -gt "$d_timeout" ]; then
                    cat /var/log/docker.log
    		echo 'Timed out trying to connect to internal docker host.' >&2
    		exit 1
    	fi
            tries=$(( $tries + 1 ))
    	sleep 1
    done    
}

echo "$DOMAIN" > /etc/Caddyfile
echo "tls $EMAIL" >> /etc/Caddyfile
cat /tmp/Caddyfile.tmp >> /etc/Caddyfile

sed -i -e s/{USERNAME}/$MYUSERNAME/g /etc/supervisor.d/cloud9.ini
sed -i -e s/{PASSWORD}/$MYPASSWORD/g /etc/supervisor.d/cloud9.ini

start_dockerd
supervisord -n -c /etc/supervisord.conf --pidfile /var/run/supervisord.pid
