#!/bin/bash
#
# This script pings a list of remote servers and reports their status

SERVER_LIST=${1}

if [[ ! -e "${SERVER_LIST}" ]]
then
	echo "The server list not provided" >&2
	exit 1
fi


for SERVER in $(cat ${SERVER_LIST})
do
	echo "Pinging ${SERVER}"
	ping -c 2 ${SERVER} &> /dev/null
	if [[ ${?} -ne '0' ]]
	then
		echo "$SERVER is not pingable"
	else
		echo "$SERVER is UP"
	fi
done
