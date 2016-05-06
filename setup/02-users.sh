#!/bin/bash

# Add lecturers group
addgroup lecturers

# Add lecturer users
while IFS=, read USER PW; do
    echo "Creating lecturer $USER"
    if [ -z $PW ]; then
        useradd -s "/bin/bash" -m -N -g users -G sudo,adm,lecturers $user
    else
        useradd -s "/bin/bash" -m -N -g users -G sudo,adm,lecturers -p "$PW" $user
    fi
done < <(egrep -v '^#' lecturers.list)

# Add some admin users, add them to SSHD allowed list
ADMINS=`tr -d "\n" "" < admins.list`
echo "Administrators with SSH access: $ADMINS"
echo "AllowUsers $ADMINS" >> /etc/ssh/sshd_config
systemctl reload ssh.service

# Add regular users
while IFS=, read USER PW; do
    echo "Creating student $USER"
    if [ -z $PW ]; then
        useradd -s "/bin/bash" -m -N -g users $user
    else
        useradd -s "/bin/bash" -m -N -g users -p "$PW" $user
    fi
done < <(egrep -v '^#' users.list)

# Create fontconfig-cache
echo "Creating fontconfig cache in HOME folders..."
for u in $(ls /home/); do
  sudo -H -u $u fc-cache
done
