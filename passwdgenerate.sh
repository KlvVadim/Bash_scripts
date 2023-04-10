#!/bin/bash
#
# This script generates a list of random passwords
#
# A random number as a password
#
PASSWORD="${RANDOM}"
echo "${PASSWORD}"
#
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"
#
#
# Use the current date/time as the basis for the password
#
PASSWORD=$(date +%s)
echo "${PASSWORD}"
#
#
# Use nanoseconds to randomize
#
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"
#
#
# A better password
PASSWORD=$(date +%s%N |sha256sum | head -c32)
echo "${PASSWORD}"
#
#
PASSWORD=$(date +%s%N${RANDOM}{RANDOM} |sha256sum | head -c32)
echo "${PASSWORD}"
#
#
# Append a special character to the password
SPECIAL_CHARACTER=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
echo "${PASSWORD}${SPECIAL_CHARACTER}"
