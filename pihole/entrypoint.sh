#!/bin/sh
# Check if cache directory is initialized
if [ ! -d /var/spool/squid/00 ]; then
  echo "Initializing Squid cache directory..."
  squid -z -f /etc/squid/squid.conf
fi
# Start Squid
exec squid -N -d 1 -f /etc/squid/squid.conf
