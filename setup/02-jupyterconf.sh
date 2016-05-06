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

# Setup configuration
echo "c.JupyterHub.proxy_auth_token = '$PROXY_TOKEN'" >> $CONF
echo "c.JupyterHub.cookie_secret_file = '${SERVDIR}/cookie_secret'" >> $CONF
echo "c.JupyterHub.cookie_max_age_days = 1" >> $CONF
echo "c.JupyterHub.db_url = '${SERVDIR}/jupyterhub.sqlite'" >> $CONF
echo "c.JupyterHub.extra_log_file = '${LOGFILE}'" >> $CONF
echo "c.JupyterHub.logo_file = '${SERVDIR}/logo.png'" >> $CONF
echo "c.Spawner.notebook_dir = '~/notebooks'" >> $CONF

#echo "c.Authenticator.admin_users = {'ocaglayan', 'mlafond', 'dberthet'}" >> $CONF
#echo "c.JupyterHub.ssl_key = '/var/log/jupyterhub.log'" >> $CONF
#echo "c.JupyterHub.ssl_cert = '/var/log/jupyterhub.log'" >> $CONF

# Restrict permissions
chmod 600 ${CONFDIR}/*
chmod 600 ${SERVDIR}/*
