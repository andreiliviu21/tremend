#!/bin/bash

#Check if root
check_if_root() {
        if [ "$EUID" -ne 0 ]; then
                echo "Please run as root"
                exit 1
        else
                echo "Script ran as root :)"
        fi
}

# Check if passwd exists in /etc
check_if_passwd() {
        if [ -f /etc/passwd ]; then
                echo "The passwd file was found at /etc."
        else
                echo "Cannot find the passwd file!"
                exit 2
        fi
}

# Print home directory
print_home_directory() {
        echo "Print the home directory:"
        ls /home
}

# List usernames from passwd
list_usernames() {
        echo "Users from passwd: "
        cut -d: -f1 /etc/passwd
}

# Count the users
count_users() {
        echo "User count: "
        wc -l /etc/passwd | cut -d" " -f1
}

# Find user specific home directory
find_user_home() {
        echo -n "Input the username to find the home directory: "
        read username
        home_dir=$(grep $username /etc/passwd | cut -d: -f6)
        if [[ -n $home_dir ]]; then
                echo "Home directory for $username is: $home_dir"
                ls $home_dir
        else
                echo "Username $username not found!"
                exit 3
        fi
}

# List users within UID range
list_users_by_uid_range() {
        echo -n "Enter the UID range: "
        echo "start = "
        read start
        echo "end= "
        read end
        echo "Users with UID between $start and $end: "
        awk -F: -v start=$start -v end=$end '{print $1}' /etc/passwd
}

# Find users with standard shell
find_users_with_shells() {
        echo "Users with /bin/bash or /bin/sh shell:"
        grep -E '/bin/bash|/bin/sh' /etc/passwd | cut -d: -f1
}

# Replace "/" with "\"
replace_slash() {
        echo "Replaced '/' with '\' in passwd and save the changed to new_passwd"
        #sed 's@// @\\ @g' /etc/passwd > new_passwd
        cat /etc/passwd | tr '//' '\\' > new_passwd
}


# Print private IP
private_ip() {
        lanIp="$(hostname -I | awk '{print $1}')"
        echo "Your private ip is: ${lanIp}"
}

# Print public IP
public_ip() {
        wanIp="$(curl https://ipinfo.io/ip 2>/dev/null)"
        echo "Your public ip is: ${wanIp}"
}

# Switch to John
switch_john() {
        su john
}

# Print home for John
home_john() {
        home_dir=$(grep john /etc/passwd | cut -d: -f6)
        echo "Print home for John: "
        ls $home_dir
}


# Funtion calls
check_if_root
check_if_passwd
print_home_directory
list_usernames
count_users
find_user_home
list_users_by_uid_range
find_users_with_shells
replace_slash
private_ip
public_ip
switch_john
home_john