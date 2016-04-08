#!/bin/bash

set -e

if [ -f /volume/shared/is_leader ]; then
    bin/rake db:migrate
fi

if [ -n "$DNS_HOST" ]; then
    DNS_IP=$( getent hosts $DNS_HOST | awk '{ print $1 }' )
    if [[ $DNS_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        TEMP_FILE=$( mktemp /tmp/docker-cmd.XXXXXX )
        trap 'rm -f $TEMP_FILE' EXIT
        sed "s/^nameserver .*/nameserver $DNS_IP/" /etc/resolv.conf > $TEMP_FILE
        cp -f $TEMP_FILE /etc/resolv.conf
    fi
fi

exec  bin/rails server -p 3030 -b 0.0.0.0
