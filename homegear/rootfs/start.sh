#!/usr/bin/env bashio

_term() {
	HOMEGEAR_PID="$(cat /var/run/homegear/homegear.pid)"
	kill "$(cat /var/run/homegear/homegear-management.pid)"
	kill "$(cat /var/run/homegear/homegear-influxdb.pid)"
	kill "$HOMEGEAR_PID"
	wait "$HOMEGEAR_PID"
	/etc/homegear/homegear-stop.sh
	exit 0
}

trap _term SIGTERM

USER="$(bashio::config 'homegear_user')"

echo "Initializing homegear as user ${USER}"

mkdir -p /config/homegear \
	/share/homegear/lib \
	/share/homegear/log \
	/usr/share/homegear/firmware

chown homegear:homegear /config/homegear \
	/share/homegear/lib \
	/share/homegear/log

rm -Rf /etc/homegear \
	/var/lib/homegear \
	/var/log/homegear

ln -nfs /config/homegear     /etc/homegear
ln -nfs /share/homegear/lib /var/lib/homegear
ln -nfs /share/homegear/log /var/log/homegear

if ! [ "$(ls -A /etc/homegear)" ]; then
	cp -a /etc/homegear.config/* /etc/homegear/
else
	cp -a /etc/homegear.config/devices/* /etc/homegear/devices/
fi

if test ! -e /etc/homegear/nodeBlueCredentialKey.txt; then
        tr -dc A-Za-z0-9 < /dev/urandom | head -c 43 > /etc/homegear/nodeBlueCredentialKey.txt
        chmod 400 /etc/homegear/nodeBlueCredentialKey.txt
fi

if ! [ "$(ls -A /var/lib/homegear)" ]; then
	cp -a /var/lib/homegear.data/* /var/lib/homegear/
else
	rm -Rf /var/lib/homegear/modules/*
	mkdir -p /var/lib/homegear.data/modules
	cp -a /var/lib/homegear.data/modules/* /var/lib/homegear/modules/ || echo "Could not copy modules to \"homegear.data/modules/\". Please check the permissions on this directory and make sure it is writeable."

	rm -Rf /var/lib/homegear/flows/nodes/*
	mkdir -p /var/lib/homegear.data/node-blue/nodes
	cp -a /var/lib/homegear.data/node-blue/nodes/* /var/lib/homegear/node-blue/nodes/ || echo "Could not copy nodes to \"homegear.data/node-blue/nodes\". Please check the permissions on this directory and make sure it is writeable."

	rm -Rf /var/lib/homegear/node-blue/www
	cp -a /var/lib/homegear.data/node-blue/www /var/lib/homegear/node-blue/ || echo "Could not copy Node-BLUE frontend to \"homegear.data/node-blue/www\". Please check the permissions on this directory and make sure it is writeable."

	cd /var/lib/homegear/admin-ui || echo "Directory /var/lib/homegear/admin-ui not found."
	# shellcheck disable=SC2010
	ls /var/lib/homegear/admin-ui/ | grep -v translations  | xargs rm -Rf
	mkdir -p /var/lib/homegear.data/admin-ui
	cp -a /var/lib/homegear.data/admin-ui/* /var/lib/homegear/admin-ui/
	[ ! -f /var/lib/homegear/admin-ui/.env ] && cp -a /var/lib/homegear.data/admin-ui/.env /var/lib/homegear/admin-ui/
	cp -a /var/lib/homegear.data/admin-ui/.version /var/lib/homegear/admin-ui/ || echo "Could not copy admin UI to \"homegear.data/admin-ui\". Please check the permissions on this directory and make sure it is writeable."

fi

rm -f /var/lib/homegear/homegear_updated

if [[ -d /var/lib/homegear/node-blue/node-red ]]; then
    echo "Preparing NodeBlue"
	cd /var/lib/homegear/node-blue/node-red  || echo "Directory /var/lib/homegear/node-blue/node-red not found."
	npm install
fi

if ! [ -f /var/log/homegear/homegear.log ]; then
	touch /var/log/homegear/homegear.log
	touch /var/log/homegear/homegear-flows.log
	touch /var/log/homegear/homegear-scriptengine.log
	touch /var/log/homegear/homegear-management.log
	touch /var/log/homegear/homegear-influxdb.log
fi

if ! [ -f /etc/homegear/dh1024.pem ]; then
	echo "Generating homegear certificates"
	openssl genrsa -out /etc/homegear/homegear.key 2048
	openssl req -batch -new -key /etc/homegear/homegear.key -out /etc/homegear/homegear.csr
	openssl x509 -req -in /etc/homegear/homegear.csr -signkey /etc/homegear/homegear.key -out /etc/homegear/homegear.crt
	rm /etc/homegear/homegear.csr
	chown homegear:homegear /etc/homegear/homegear.key
	chmod 400 /etc/homegear/homegear.key
	openssl dhparam -check -text -5 -out /etc/homegear/dh1024.pem 1024
	chown homegear:homegear /etc/homegear/dh1024.pem
	chmod 400 /etc/homegear/dh1024.pem
fi

chown -R root:root /etc/homegear
chown "${USER}":"${USER}" /etc/homegear/*.key
chown "${USER}":"${USER}" /etc/homegear/*.pem
chown "${USER}":"${USER}" /etc/homegear/nodeBlueCredentialKey.txt
find /etc/homegear -type d -exec chmod 755 {} \;
chown -R "${USER}":"${USER}" /var/log/homegear /var/lib/homegear
find /var/log/homegear -type d -exec chmod 750 {} \;
find /var/log/homegear -type f -exec chmod 640 {} \;
find /var/lib/homegear -type d -exec chmod 750 {} \;
find /var/lib/homegear -type f -exec chmod 640 {} \;
find /var/lib/homegear/scripts -type f -exec chmod 550 {} \;

TZ=$(echo "$TZ" | tr -d '"') # Some users report quotes around the string - remove them
if [[ -n $TZ ]]; then
	ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone
fi

mkdir -p /var/run/homegear
chown "${USER}":"${USER}" /var/run/homegear

printf "\nAttached ttyUSB devices:\n%s\n" "$(ls -al /dev/ttyUSB* 2> /dev/null)"
printf "Attached ttyAMA devices:\n%s\n" "$(ls -al /dev/ttyAMA* 2> /dev/null)"
printf "Attached spidev devices:\n%s\n" "$(ls -al /dev/spidev* 2> /dev/null)"

# Add user to the group of all /dev/ttyUSB and /devttyAMA devices so that they are usable
echo "Adding group of the devices to homegear user ${USER}"
DEVICE_GROUPS=$({ stat -c '%g' /dev/ttyUSB* 2> /dev/null || : ; stat -c '%g' /dev/ttyAMA* 2> /dev/null || : ; } | sort | uniq)
echo "${DEVICE_GROUPS}" | while read -r line ; do
    echo "Found group id: ${line}"
	if [ -n "${line}" ]
	then
	    echo "Detecting group name"
		GROUP_NAME=$(id -gn "${line}" 2> /dev/null || true)
		echo "Group name is: ${GROUP_NAME}"

		# Create a dummy group with id of device if none exists
		if [ -z "${GROUP_NAME}" ]
		then
			echo "Group for id ${line} does not exist. Creating one."
			GROUP_NAME="${USER}-${line}"
			groupadd -g "${line}" "${GROUP_NAME}"
		fi

		echo "Adding group ${GROUP_NAME} to user ${USER}"
		usermod -a -G "${GROUP_NAME}" "${USER}"
	fi
done

echo "Adding group root to user ${USER}"
usermod -a -G "root" "${USER}" # for usb and gpio

echo "Starting Homegear (/usr/bin/homegear -u ${USER} -g ${USER})"

# Set permissions on interfaces and directories, export GPIOs.
/usr/bin/homegear -u "${USER}" -g "${USER}" -p /var/run/homegear/homegear.pid -pre >> /dev/null 2>&1

/usr/bin/homegear -u "${USER}" -g "${USER}" -p /var/run/homegear/homegear.pid &
sleep 5
/usr/bin/homegear-management -p /var/run/homegear/homegear-management.pid &
/usr/bin/homegear-influxdb -u "${USER}" -g "${USER}" -p /var/run/homegear/homegear-influxdb.pid &
tail -f /var/log/homegear/homegear-flows.log &
tail -f /var/log/homegear/homegear-scriptengine.log &
tail -f /var/log/homegear/homegear-management.log &
tail -f /var/log/homegear/homegear-influxdb.log &
tail -f /var/log/homegear/homegear.log &
child=$!
wait "$child"