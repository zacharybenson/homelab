#!/bin/bash
echo "Starting Squid container..."

# Remove stale PID file
if [ -f /var/run/squid.pid ]; then
  echo "Removing stale PID file..."
  rm -f /var/run/squid.pid
fi

# Start Squid
echo "Starting Squid..."
exec squid -N -d 1 -f /etc/squid/squid.conf
