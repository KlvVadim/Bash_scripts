
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
PASS_WORD='xxxxxxx'
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
    install -m 600 <(echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDW59gHn6JTYa7q/ZaPsuxxxxxxx==") "$SSH_DIR/authorized_keys"
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
do curl -k -X 'POST' 'https://portal.zeronetworks.com/api/v1/assets/linux' -H 'accept: */*' -H 'Authorization: eyJhbGciOiJSUzI1NiIsInxxxxxxxw' -H 'Content-Type: application/json' -d '{ "displayName": "'$HOST'", "fqdn": "'$HOST'" }'
done
exit 0
