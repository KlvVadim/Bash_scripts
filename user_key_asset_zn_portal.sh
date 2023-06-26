
#
#!/bin/bash
# ----------------------------------------------------------------------------------------------
#    Name:         all_user_key_asset_zn.sh
#    Description:  This script will create local user zn-admin with previously defined password,
#    add the user to sudoers file, copy pub key to authorized_keys 
# ----------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------
#
#  NOTE!!! This script should run only on RHEL distribution
#
# -------------------------------------------------------------------------

#Declare Variables:
SUDO_FILE='/etc/sudoers.d/zn-admin'
USER_NAME='zn-admin'
PASS_WORD='6jUU5O!43!pX'
SSH_DIR='/home/zn-admin/.ssh/'

#Make sure the script is being executed with superuser privileges

if [[ "${UID}" -ne 0 ]]
then
 echo "You have to have root privileges to execute the script"
 exit 1
fi

#Remove immutable attribute in /etc/passwd
chattr -i /etc/passwd

##Checking if User already exists and creating one if not
id $USER_NAME >/dev/null 2>&1
if [[ $? -ne  0 ]] ; then
   ##Adding user and creating home dir
   useradd -m $USER_NAME  >/dev/null 2>&1
fi
 ## Check if useradd command succeeded
if [[ "${?}" -ne '0' ]]
then
 echo "User creation failed"
 exit 1
fi

#Assign a password to the user
echo "$PASS_WORD" | passwd --stdin  $USER_NAME  >/dev/null 2>&1
 ## Check if passwd command succeeded
if [[ "${?}" -ne '0' ]]
then
 echo "Password failed"
 exit 1
fi

#Configure a user account so that the password will never expire
chage -M -1 $USER_NAME

#Create /ssh dir if not exist
if [ ! -d $SSH_DIR ]
then
    mkdir -p -m 600 $SSH_DIR
fi

##Create authorized_keys file if not exist
if [ ! -e "$SSH_DIR/authorized_keys" ]
then
    install -m 600 <(echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDW59gHn6JTYa7q/ZaPsuiUQ563ji56cTNeM02IulzNSyvZQBN9EfweQ0WFaSmug3xstW37ge/moiZDUUxP3qBfXVCX/ktN2wfOhaRV6yTJFXsBFhT9qbrYQtuLGEnrooZl6TOGXVxTWoJU+scr4S7zqIGZqghNhHFu+BwlNURR8FE6EAucNanL1KF7eo1O8cIsIvgDH5qADbCUS9gkFT2gBaOlAAvEfseke0K2Ka7LMOOoB0QnY0JXfpdIt3U0GssH7td4MmZDxBTmv2wEQorh9H4nZ1TGO3hjXWEV/S/T7PcFo4woc8mvJdDv8vSNCnVU7TaZ4XfDrvkZ48HmHclLP9cJsJ9e7ayIee1hVxj4QaSbFJVlhs+3wu539oSxxzExC9zb65yzB4E2JtC7GOKjYvqllrM01vaqAAYqcGlO6DqRvpZoZGioQY6oaXrmdGnNTAZCqf58Lp4G13N8+Fb2D8kz96L/XnIgPMVWHwqdHggdS/+NikcrzifR89/oXA4cDLNV4zFUzBcdgltETUiFW6OmydB0NMC3m/O7vPw6hMoiFV6obcwnUoUoN+DsPBQn69XpzWtxFc1bb91DbOi+WbXNdR4DkMD6lROXgpTm1ypR47dM2+I1pxWnOrFXdfBBzmoXXKRw1nWwswMb27DjqPaIYJDQFbs/eWfvi9dLtQ==") "$SSH_DIR/authorized_keys"
fi

#Set owner
chown -R zn-admin.zn-admin $SSH_DIR

##Create sudoers file of $USER_NAME if not exist
if [ ! -e $SUDO_FILE ]
then
    install -m 440 <(echo "zn-admin ALL=(ALL) NOPASSWD: ALL") $SUDO_FILE
fi
exit 0


===========================================================================================================================================
===========================================================================================================================================
===========================================================================================================================================
#
#!/bin/bash
#
## This 2nd script should be running on our Jump server and will add server to asset in Zero Network portal
#

for HOST in $(cat /home/vadimkol/ansible_scripts/ansible_zero_net/inventory)
do curl -k -X 'POST' 'https://portal.zeronetworks.com/api/v1/assets/linux' -H 'accept: */*' -H 'Authorization: eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJtOmU1MWRkYWViM2M0NTM1ZGU2MDUzZTExNWMwMTBjZTg1ZDY4Y2VmZGEiLCJuYW1lIjoiem4tYWRtaW4iLCJlaWQiOiI3N2U1ZmM3Yy0wZjU2LTQ4NGMtOWU1Zi1jZTBjNTg5ODFkM2QiLCJzY29wZSI6NCwiZV9uYW1lIjoiSGFyZWwtZ3JvdXAiLCJ2IjoxLCJpYXQiOjE2ODMxMDkwMjksImV4cCI6MTc0NjI2NzQyNywiYXVkIjoicG9ydGFsLnplcm9uZXR3b3Jrcy5jb20iLCJpc3MiOiJ6ZXJvbmV0d29ya3MuY29tL2FwaS92MS9hY2Nlc3MtdG9rZW4ifQ.cFXdNtowMXoQHUEEhVK-2vYkjbVfVo05HjcxtGCXQjNl9mVz3-wZa8zXePlKBfe3pQE8JuPtAtLMC2CZDIphCznYJd7T1u3iWhLoImjO6S6W-JXyepGwor_yu7WdgLAH9S-PU4FMmhGE3a3F1G-0_tTMcetHv31ngQf3zPHtkBRtOnw2Hzpqifaf0kdCbWikncE9NUkbHuy9LA1eShEPSsD5PC-gVu1zmVueqVcV5AUhoUB4dcDkRCJAOatkH5jzmr0Mvp3wBXpFqqoUlXV0L84yDzlSkN7-dBHnoYkGhLGmAUttIRhPb_5Mpbe_TQoo6kmHFGFwv3qkonMzVIBS7w' -H 'Content-Type: application/json' -d '{ "displayName": "'$HOST'", "fqdn": "'$HOST'" }'
done

exit 0


===========================================================================================================================================
===========================================================================================================================================

#TEST!!! Trying to get short hostname from FQDN - doesn't work with json (in curl command), it will be read as a text string

for HOST in $(cat /home/vadimkol/ansible_scripts/ansible_zero_net/inventory)
do echo "$HOST | cut -d'.' -f1"
done