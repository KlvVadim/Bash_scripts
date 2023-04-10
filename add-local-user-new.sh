#!/bin/bash
#
# This script creates a new user on the local system
# You must supply a username ac an argument to the script
# Optionally, you can also provide a comment for the account as argument
# A password will be automatically generated for the account
# The username, password and hostname for the account will be displayed


# Make sure the script is being executed with superuser privileges

if [[ "${UID}" -ne 0 ]]
then
	echo "You have to have root privileges to execute the script"
	exit 1
fi


# Make sure they supplied at least one argument

if [[ "${#}" -lt 1 ]]
then
	echo
	echo "You haven't supplied a username as an argument"
	echo
	echo "Usage: "${0}": USER_NAME [COMMENT] ... "
	echo
	exit 1
fi


# The first parametr is provided username

USER_NAME="${1}"


# The rest of the parameters are comment
# Will do that by using shift which will drop the first parameter and dealing with the rest (because for the rest we use  @)

shift
COMMENT="${@}"


# Generate a password

PASSWORD=$(date +%s%N{RANDOM})


# Create the user with the password

# useradd -m "${USER_NAME}" -c "${COMMENT}"
useradd "${USER_NAME}" -c "${COMMENT}"


# Check if useradd command succeeded

if [[ "${?}" -ne '0' ]]
then
	echo "User creation failed"
	exit 1
fi


# Set the password

echo "${PASSWORD}" | passwd --stdin ${USER_NAME}


# Check if passwd command succeeded 

if [["${?}" -ne '0']]
then
	echo "Password failed"
	exit 1
fi


# Force password change at first login

passwd -e "${USER_NAME}"


# Display userinfo

echo
echo 'username'
echo "${USER_NAME}"
echo
echo 'password'
echo "${PASSWORD}"
echo
echo 'server name'
echo "${HOSTNAME}"

exit 0






