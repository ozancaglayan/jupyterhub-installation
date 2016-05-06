#!/bin/bash

# Add lecturers group
addgroup lecturers

# Add lecturer users
while IFS=, read NAME PW; do
    echo "Creating lecturer $NAME"
    if [ -z $PW ]; then
        useradd -s "/bin/bash" -m -N -g users -G sudo,adm,lecturers $NAME
    else
        useradd -s "/bin/bash" -m -N -g users -G sudo,adm,lecturers -p "$PW" $NAME
    fi
done < <(egrep -v '^#' lecturers.list)

# Add some admin users, add them to SSHD allowed list
ADMINS=`tr "\n" " " < admins.list`
echo "Administrators with SSH access: $ADMINS"
echo "AllowUsers $ADMINS" >> /etc/ssh/sshd_config
systemctl reload ssh.service

# Add regular users
while IFS=, read NAME PW; do
    echo "Creating student $NAME"
    if [ -z $PW ]; then
        useradd -s "/bin/bash" -m -N -g users $NAME
    else
        useradd -s "/bin/bash" -m -N -g users -p "$PW" $NAME
    fi
done < <(egrep -v '^#' students.list)

# Create fontconfig-cache
echo "Creating fontconfig cache in HOME folders..."
for u in $(ls /home/); do
  sudo -H -u $u fc-cache
done
