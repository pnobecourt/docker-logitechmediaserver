#!/bin/sh

# Set $SUID and $SGID to 1000, if not already set
#: ${SUID:=1000}
#: ${SGID:=1000}

# Create squeezeboxserver user and group
groupadd -g 1000 squeezeboxserver
useradd -u 1000 -g 1000 -d /usr/share/squeezeboxserver/ -c 'Logitech Media Server' squeezeboxserver

# Check that squeezebox folders exist, then create them
if [ "$SQUEEZE_VOL" ] && [ -d "$SQUEEZE_VOL" ]; then
	for subdir in prefs logs cache; do
		mkdir -p $SQUEEZE_VOL/$subdir
	done
fi

# Chown squeezebox folders
chown -R squeezeboxserver:squeezeboxserver $SQUEEZE_VOL

# Run supervisord
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
