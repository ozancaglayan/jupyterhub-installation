#!/bin/bash

# Set the files and the folders
CONFDIR="/etc/jupyterhub"
SERVDIR="/srv/jupyterhub"
LOGFILE="/var/log/jupyterhub.log"
CONFFILE=${CONFDIR}/jupyterhub.py

# Create the folders
mkdir -p $CONFDIR ${SERVDIR}/ssl &> /dev/null

# Set permissions
chmod 700 $CONFDIR $SERVDIR

# Create default configuration
jupyterhub --generate-config -f $CONFFILE

# Generate cookie secret
openssl rand -base64 2048 > ${SERVDIR}/cookie_secret

# Generate proxy auth token
PROXY_TOKEN=`openssl rand -hex 32`

# Copy over logo
cp data/logo.png ${SERVDIR}

# Get admin users
ADMINS=`python -c 'print(set(open("admins.list").read().strip().split("\n")))'`

# Setup configuration
echo "c.JupyterHub.proxy_auth_token = '$PROXY_TOKEN'" >> $CONFFILE
echo "c.JupyterHub.cookie_secret_file = '${SERVDIR}/cookie_secret'" >> $CONFFILE
echo "c.JupyterHub.cookie_max_age_days = 1" >> $CONFFILE
echo "c.JupyterHub.db_url = '${SERVDIR}/jupyterhub.sqlite'" >> $CONFFILE
echo "c.JupyterHub.extra_log_file = '${LOGFILE}'" >> $CONFFILE
echo "c.JupyterHub.logo_file = '${SERVDIR}/logo.png'" >> $CONFFILE
echo "c.Spawner.notebook_dir = '~/notebooks'" >> $CONFFILE
echo "c.Authenticator.admin_users = $ADMINS" >> $CONFFILE

# Restrict permissions
chmod 600 ${CONFDIR}/*
chmod 600 ${SERVDIR}/*

# Install systemd services
cp data/jupyterhub.service /etc/systemd/system
systemctl daemon-reload
systemctl enable jupyterhub.service jupyterhub-idle-killer.service

# Optional: Install cull_idle_servers
wget http://raw.githubusercontent.com/jupyterhub/jupyterhub/master/examples/cull-idle/cull_idle_servers.py \
    -O ${SERVDIR}/cull-idle-servers
chmod +x ${SERVDIR}/cull-idle-servers

# Copy systemd file
cp data/jupyterhub-idle-killer.service /etc/systemd/system

# Generate API token
API_TOKEN=`openssl rand -hex 32`

# TODO: Pick an admin user here for the cull service
API_USER="lect1"

echo "c.JupyterHub.api_tokens = {'${API_TOKEN}' : '${API_USER}'}" >> $CONFFILE
sed -i "s/%%APITOKEN%%/${API_TOKEN}/" /etc/systemd/system/jupyterhub-idle-killer.service

systemctl enable jupyterhub-idle-killer.service
