

#!/bin/bash

##### Make sure user has root privileges

if [[ "${UID}" -ne "0" ]]
    then
    echo
    echo "You have to be a root user to execute the script!"
    echo

    exit 1
fi



##### Create a new group

# Enter new group name
echo
read -p "Enter new group name: " NEW_GROUP
echo

# Check if an argument NEW_GROUP was placed

if [[ -n $NEW_GROUP ]]      #### "-n" Testing the length of string - nonzero ####

    then
    echo
    echo "New group $NEW_GROUP is creating"

    else
    echo
    echo "You have not provided a new group name!"
    echo

    exit 1

fi


# Checks if this group name is already exists in /etc/group

if grep -q $NEW_GROUP /etc/group
    then
    echo
    echo "Group $NEW_GROUP already exists! The script is not executed!"
    echo

    exit 1

# Create new group

    else
    /usr/sbin/groupadd $NEW_GROUP
    echo
    echo "A new group $NEW_GROUP is added!"
    echo
fi



##### Generate a password for a new user

PASSWORD=$RANDOM$RANDOM




##### Create new user and add to $NEW_GROUP group


# Enter new username

echo
read -p "Enter new username: " NEW_USER
echo


# Check if an argument NEW_USER was placed

if [[ -n $NEW_USER ]]      #### "-n" Testing the length of string - nonzero ####

    then
    echo
    echo "New user $NEW_USER is creating"

    else
    echo
    echo "You have not provided a new user name! The script is not executed!"
    echo
    echo "WARNING! This new  usergroup $NEW_GROUP will be deleted now"
    echo
    groupdel $NEW_GROUP

    exit 1

fi



# Create new user

useradd "$NEW_USER" -g "$NEW_GROUP"  &>/dev/null

if [[ $? -ne 0 ]]

    then
    echo
    echo "User already exists or user's HOME dir already exists and that's what bother to create a new user with this name"
    echo

# Delete NEW_GROUP if entered username already exists

    echo "WARNING! This new group $NEW_GROUP will be deleted now"
    echo
    groupdel $NEW_GROUP

    exit 1


    else
    echo
    echo "User $NEW_USER created"
    echo
 fi


# Assign the password to user

echo "${PASSWORD}" | passwd --stdin ${NEW_USER}



##### Create a new dir for NEW_USER and NEW_GROUP

# Check if no dir with NEW_USER name exists under root dir "/"

if [[ -d  "/$NEW_USER" ]]

    then
    echo
    echo
    echo
    echo "WARNING! A directory with such name $NEW_USER already exists under root dir '/'"
    echo
    echo
    echo "Here are details of your new group and user:"
    echo
    echo "group name"
    echo "$NEW_GROUP"
    echo
    echo "user name"
    echo "$NEW_USER"
    echo
    echo "password"
    echo "$PASSWORD"
    echo
    echo

    exit 1
fi

# Create a new dir under root dir "/"

FOLDER=$(mkdir /$NEW_USER)


# Make the user and the group owners of this folder

install -d -m 0774 -o $NEW_USER -g $NEW_GROUP "/$NEW_USER"



# Display userinfo

echo
echo "group name"
echo "$NEW_GROUP"
echo
echo "user name"
echo "$NEW_USER"
echo
echo "password"
echo "$PASSWORD"
echo
echo "folder"
echo "/$NEW_USER"

