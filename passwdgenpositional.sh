#!/bin/bash

# The script generates random password for each user specified on the command line (as positional parameter)
echo

echo "You executed bash script ${0}"


# Telling them how many arguments they passed in
# (arguments outside -> inside they are parameters)
echo
echo

NUM_OF_PARAM="${#}"
echo "You supplied ${NUM_OF_PARAM} argument(s) on the command line"
echo
echo
# Make sure that at least one argument was supplied

if [[ "${NUM_OF_PARAM}" -lt 1 ]]
then
	echo "Usage: ${0} USER_NAME [USER_NAME]... "
        echo
	echo
	exit 1
fi

# Generate and display a password for each parameter (doesn't matter how many - will use Special Parameter @)

for USERNAME in "${@}"
do
	PASSWORD="$(date +%s+%N)"
	echo "${USERNAME}: ${PASSWORD}"
done
echo
echo
