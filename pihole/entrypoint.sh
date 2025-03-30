#!/bin/bash
echo "Starting Squid container..."

# Ensure cache directory exists and is writable
if [ ! -w /var/spool/squid ]; then
  echo "Fixing cache directory permissions..."
  chown squid:squid /var/spool/squid
fi

# Remove stale PID file if it exists
if [ -f /var/run/squid.pid ]; then
  echo "Removing stale PID file..."
  rm -f /var/run/squid.pid
fi

# Initialize cache if not fully set up (check for all expected dirs)
if [ ! -d /var/spool/squid/00 ] || [ ! -d /var/spool/squid/0F ]; then
  echo "Initializing Squid cache..."
  squid -z -f /etc/squid/squid.conf
  if [ $? -ne 0 ]; then
    echo "Failed to initialize cache. Check config or permissions."
    exit 1
  fi
  # Ensure no PID file remains after initialization
  if [ -f /var/run/squid.pid ]; then
    echo "Cleaning up PID file after initialization..."
    rm -f /var/run/squid.pid
  fi
else
  echo "Cache already initialized."
fi

# Start Squid
echo "Starting Squid..."
exec squid -N -d 1 -f /etc/squid/squid.conf