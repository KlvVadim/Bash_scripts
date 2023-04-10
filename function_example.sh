#!/bin/bash

log() {

  # This log function sends a message to syslog and to standard output

  local MESSAGE="${@}"
  logger -t vadimtag_script.sh "${MESSAGE}"

}


# You can check log function execution by running
# log "This a script message"
# and then checking this message in /var/log/messages


backup_file() {

  # This backup_file function creates a backup of a file. Returns non-zero status on error

  local FILE="${1}"

  # Make sure the file in FILE var exists

  if [[ -f "${FILE}" ]]
  then
	local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
	log "Backing up ${FILE} to ${BACKUP_FILE}"
	
	# The exit status of the function will be the exit status of the cp command

	cp -p ${FILE} ${BACKUP_FILE}

  else
	return 1
  fi

}


# Executing the backup_file function

backup_file '/etc/passwd'


# Checking exit status of the function using log function

if [[ "${?}" -eq '0' ]]
then
	log "File backup succeeded"

else
	log "File backup failed"
	exit 1
fi

