#!/bin/bash

echo "$DOMAIN" > /etc/Caddyfile
echo "tls $EMAIL" >> /etc/Caddyfile
cat /tmp/Caddyfile.tmp >> /etc/Caddyfile

sed -i -e s/{USERNAME}/$MYUSERNAME/g /etc/supervisor.d/cloud9.ini
sed -i -e s/{PASSWORD}/$MYPASSWORD/g /etc/supervisor.d/cloud9.ini

supervisord -n -c /etc/supervisord.conf
