#!/bin/bash

#######################################################################################
#Script Name    :rhel_centos_7_8_check_003.sh
#Description    :Hardening Check for Red Hat/CentOS 7.x and 8.x
#Version       : 003
#Last Update Data : 14/01/2023
# Use following command to run this scipt 
# chmod u+x rhel_centos_7_8_check_003.sh
# ./rhel_centos_7_8_check_003.sh
#######################################################################################

# Create assessment directory for files export

host=$(hostname)
date_stamp=$(date +"%F")
my_dir="${host}.${date_stamp}"

# Create directory and set permissions
mkdir -p $my_dir
chmod 1777 $my_dir

echo "=================================================================================="
echo -e "\e[33m>>>>> Get OS Info <<<<<\e[0m"

hostnamectl > $my_dir/hostname.txt
hostname -I | awk '{print $1}' > $my_dir/IP.txt
ip addr > $my_dir/ip_addr.txt
for i in $(ls /etc/*release); do echo ===$i===; cat $i; done > $my_dir/os-release.txt
uname -a > $my_dir/uname-a.txt
cat /etc/redhat-release > $my_dir/redhat-release.txt
cat /proc/version > $my_dir/version.txt
rpm -q bash > $my_dir/bash.txt
rpm -qa > $my_dir/rpm-qa.txt

# Check if yum or dnf is installed
if command -v yum > /dev/null 2>&1; then
    yum_cmd=yum
elif command -v dnf > /dev/null 2>&1; then
    yum_cmd=dnf
else
    echo "yum or dnf not found"
    exit 1
fi

$yum_cmd list installed > $my_dir/yum.installed.txt
$yum_cmd history list > $my_dir/yum.history.txt
$yum_cmd list kernel > $my_dir/yum.kernel.txt

echo "=================================================================================="
echo -e "\e[33m>>>>> Get OS Services <<<<<\e[0m"

services_to_check=(
    "telnet-server" 
    "telnet" 
    "rsh-server" 
    "rsh" 
    "ypbind" 
    "ypserv" 
    "tftp" 
    "tftp-server" 
    "talk" 
    "talk-server" 
    "xinetd" 
    "dhcp" 
    "openldap-servers" 
    "openldap-clients" 
    "bind" 
    "vsftpd" 
    "httpd" 
    "dovecot" 
    "samba" 
    "squid" 
    "net-snmp"
)

for service in "${services_to_check[@]}"
do
    rpm -q $service >> $my_dir/services.txt
done

echo "=================================================================================="
echo -e "\e[33m>>>>> Get Files Output <<<<<\e[0m"

files=(
    /etc/selinux/config
    /etc/security/limits.conf
    /etc/security/limits.d/*
    /etc/motd
    /etc/issue
    /etc/issue.net
    /etc/hosts.allow
    /etc/hosts.deny
    /etc/ssh/sshd_config
    /etc/ssh/ssh_config
    /etc/pam.d/password-auth
    /etc/pam.d/system-auth
    /etc/security/pwquality.conf
    /etc/login.defs
    /etc/security/*
    /etc/securetty
    /etc/pam.d/su
    /etc/bashrc
    /etc/profile
    /etc/audit/audit.rules
    /etc/audit/auditd.conf
    /etc/passwd
	/etc/passwd-
    /etc/shadow
    /etc/group
    /etc/gshadow
    /etc/exports
    /etc/fstab
    /etc/sysconfig/network
    /etc/sysconfig/network-scripts/ifcfg-*
    /etc/resolv.conf
    /etc/yum.conf
    /etc/resolv.conf
    /etc/inetd.conf
    /etc/ntp.conf
    /etc/sudoers
    /etc/rsyslog.conf
    /etc/default/useradd
    /etc/sysctl.conf
    /etc/cron.deny
    /etc/logrotate.conf
)

for file in "${files[@]}"; do
    cat "$file" > "$my_dir/$(basename "$file").txt" 2>/dev/null
done

echo "=================================================================================="
echo -e "\e[33m>>>>> Get files permissions <<<<<\e[0m"

files=(
    /var/log
	/var/log/*
    /etc/passwd
	/etc/passwd-
    /etc/shadow
	/etc/shadow-
    /etc/group
	/etc/group-
    /etc/gshadow
	/etc/gshadow-
    /etc/pam.d/su
    /etc/hosts.allow
    /etc/hosts.deny
    /etc/crontab
    /etc/cron*
    /etc/securetty
    /etc/ssh/sshd_config
    /etc/login.defs
    /etc/motd
    /etc/issue
    /etc/issue.net
    /boot/grub2/grub.cfg
    /etc/security/*
)

for file in "${files[@]}"; do
    stat "$file" >> "$my_dir/permissions.txt"
done

echo "=================================================================================="
echo -e "\e[33m>>>>> Get File Permissions for /bin/su and /var/log <<<<<\e[0m"

stat /bin/su > $my_dir/bin.su.permissions.txt
ls -la /bin/su >> $my_dir/bin.su.permissions.txt
stat /var/log > $my_dir/var.log.permissions.txt
ls -l /var/log/ >> $my_dir/var.log.permissions.txt

echo "=================================================================================="
echo -e "\e[33m>>>>> Get Login Info <<<<<\e[0m"

awk -F':' '{ system("echo " $1 " && chage -l " $1) }' /etc/passwd > $my_dir/login.txt
awk -F: '($3 == "0") {print}' /etc/passwd >> $my_dir/login.txt
awk -F":" '{print "Login:" $1 "\tName:" $5 "\tHome:" $6}' /etc/passwd >> $my_dir/login.txt

echo "=================================================================================="
echo -e "\e[33m>>>>> Find and List all files with no owner <<<<<\e[0m"

find /usr/ -type f \( -perm -4000 -o -perm -2000 \) -exec ls -la {} \; > $my_dir/find.nouser.txt

##########################################################################################
echo "=================================================================================="
echo "The hardening check is complete..."
tar -cf ${host}.${date_stamp}.tar $my_dir

echo "=================================================================================="
echo the output files are located: 
echo -e "\e[32m${host}.${date_stamp}.tar \e[0m" 
echo "=================================================================================="
echo Thank you for your time...
rm -rf $my_dir
