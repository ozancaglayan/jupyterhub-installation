#!/bin/bash

# Add lecturers group
addgroup lecturers

# Add some admin users, add them to SSHD allowed list
ADMINS="admin1 admin2 admin3"
echo "AllowUsers $ADMINS" >> /etc/ssh/sshd_config

for user in $ADMINS; do
  # NOTE: You may need to provide them some default passwords
  useradd -s "/bin/bash" -m -N -g users -G sudo,adm,lecturers $user
done

# Install systemd service
cp data/jupyterhub.service /etc/systemd/system
systemctl daemon-reload
systemctl enable jupyterhub.service

# Create fontconfig-cache
for u in $(ls /home/); do
  sudo -H -u $u fc-cache
done
