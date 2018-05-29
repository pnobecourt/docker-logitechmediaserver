#!/bin/bash

# Set $S_UID and $S_GID to 1000, if not already set
: ${S_UID:=1000}
: ${S_GID:=1000}
echo "Starting with UID $S_UID and GID $S_GID"

# Create squeezeboxserver user and group
groupadd -g $S_GID squeezeboxserver
useradd --shell /bin/bash -o -u $S_UID -g $S_GID -m -d $SQUEEZE_VOL -c 'Logitech Media Server' squeezeboxserver
export HOME=$SQUEEZE_VOL

# Check that squeezebox folders exist, then create them
if [ "$SQUEEZE_VOL" ] && [ -d "$SQUEEZE_VOL" ]; then
	for subdir in prefs logs cache; do
		mkdir -p $SQUEEZE_VOL/$subdir
	done
fi

# Chown squeezebox folders
chown -R squeezeboxserver:squeezeboxserver $SQUEEZE_VOL
chown -R squeezeboxserver:squeezeboxserver /usr/share/squeezeboxserver/

# Run supervisord
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

