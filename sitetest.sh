#!/bin/bash
[ -z "$1" ] && echo "usage: $0 <domain>" && exit 1
URL="https://$1"
RESPONSE=$(curl -so /dev/null -w "code=%{http_code} tcp=%{time_connect} ttr=%{time_starttransfer} time=%{time_total}
 dns=%{time_namelookup} eff=%{url_effective} ip=%{remote_ip}" "$URL")
ttr=$(echo "$RESPONSE" | grep -o "ttr=[0-9.]*" | cut -d= -f2 )
tcp=$(echo "$RESPONSE"   | grep -o "tcp=[0-9.]*" | cut -d= -f2)
code=$(echo "$RESPONSE" | grep -o "code=[0-9]*" | cut -d= -f2)
time=$(echo "$RESPONSE" | grep -o "time=[0-9.]*" | cut -d= -f2)
dns=$(echo "$RESPONSE" | grep -o "dns=[0-9.]*" | cut -d= -f2)
eff=$(echo "$RESPONSE" | grep -o "eff=[^ ]*" | cut -d= -f2)
ip=$(echo "$RESPONSE" | grep -o "ip=[^ ]*" | cut -d= -f2)

# Conditional logic
if [ "$code" -eq 404 ]; then
    echo " $URL is not responding"
else
    echo " Total-Time="$time"s   DNS-Delay="$dns"s  TCP-Time="$tcp"s  1st-Byte-Time="$ttr"s  FinalURL=$eff  IP=$ip"
fi
