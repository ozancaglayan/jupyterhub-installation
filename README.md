# JupyterHub Installation Guide

This document explains all the steps for a working JupyterHub installation on Ubuntu 16.04 LTS. The machine used for this purpose is a Virtual Machine on VMWare ESX server in our university. The VM has 6 CPU's, 32GB of RAM and 100GB of disk space partitioned into 25GB `rootfs` and 75GB `/home` folder.

After installing Ubuntu 16.04 LTS x86_64, here's what I did to create a fully working JupyterHub server :)

## Installing system dependencies

The following packages are needed in order for the JupyterHub and their components to work flawlessly. `pandoc` and `texlive-*` packages are necessary for saving a Jupyter notebook as PDF. I also installed `octave` as I'll provide an `octave` kernel for the users besides Python.

```
# apt install libsm6 libxrender1 libfontconfig1 build-essential gcc-multilib
# apt install npm nodejs-legacy octave
# apt install pandoc dvipng
# apt install texlive-latex-base dvipng texlive-latex-recommended \
              texlive-fonts-recommended cm-super texlive-latex-extra

# npm install -g configurable-http-proxy
```

Normally we should be fine with the above packages but if you have something to add, feel free to send a pull request!

## Other system modifications

I didn't want to clutter each login and also JupyterHub's log files with Ubuntu MOTD messages so I removed them all:

```
# rm /etc/update-motd.d/*
```

## Installation of Anaconda

I decided to use the Anaconda distribution for Python to ease management of the Python ecosystem. Go [download](https://www.continuum.io/downloads) the latest Anaconda Python 3 installer from  and install it under `/opt/anaconda3`. Change `PATH` globally so that every user starts to use the new anaconda distribution for their default Python environment:

```
# echo 'export PATH=/opt/anaconda3/bin:$PATH' > /etc/profile.d/anaconda.sh
```

Since JupyterHub requires a Python >= 3.3, we're using Python 3.x as our default Anaconda environment. Note that this won't prevent us from serving Python 2.x notebooks to users.

Next let's create a Python 2.7 environment and install anaconda distribution to that environment as well:

```
# conda create --name py27 python=2.7
# conda install -n py27 anaconda
```

Now when you logout and login back, your shell will default to the python3 environment:

```
# python
Python 3.5.1 |Anaconda 4.0.0 (64-bit)| (default, Dec  7 2015, 11:16:01) 
...
```

At any time you can switch to the 2.7 environment called `py27` with the following command:

```
# source activate py27
# python
Python 2.7.11 |Anaconda 4.0.0 (64-bit)| (default, Dec  6 2015, 18:08:32) 
...
```

Finally for going back to the default Python 3 environment, you can type `source deactivate`.

## Installation of JupyterHub and the kernels

Now we can proceed with the installation of Jupyter packages. First let's install JupyterHub and Jupyter kernels for `bash` and `octave`. Please be sure that you are in the default Python 3.x environment before proceeding the following steps:

```
# pip install jupyterhub
# pip install bash_kernel octave_kernel
# python -m bash_kernel.install
# python -m octave_kernel.install
```

We also need to install python 2.7 kernel for serving Python 2 notebooks. For this, let's first switch to our Python 2.x conda environment then install the kernel:

```
# source activate py27
# ipython kernel install
```

## Testing the bare minimum

You may want to try if everything went smoothly by running the JupyterHub with default configuration:

```
# jupyterhub --no-ssl
```

Now visit `http://<ip address>:8000` and login with your UNIX credentials. Check whether the **New** menu contains `bash`, `octave`, `Python 2` and `Python 3`. Create some notebooks, execute cells to catch possible problems.

## JupyterHub configuration

Here I provide the shell commands that I used to create a JupyterHub configuration that suits my needs. For further configuration details, you may want to visit the related [website](https://jupyterhub.readthedocs.io/en/latest/getting-started.html).

Note that since our server will only be used for educational purposes and will not be accessible from outside of the university, I choosed to go with plain HTTP which is normally **not recommended**. For supporting HTTPS, please [check here](https://jupyterhub.readthedocs.io/en/latest/getting-started.html#ssl-encryption).

```bash
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
chmod 600 ${SERVDIR}/cookie_secret

# Generate proxy auth token
PROXY_TOKEN=`openssl rand -hex 32`

# Setup configuration
echo "c.JupyterHub.proxy_auth_token = '$PROXY_TOKEN'" >> $CONF
echo "c.JupyterHub.cookie_secret_file = '${SERVDIR}/cookie_secret'" >> $CONF
echo "c.JupyterHub.cookie_max_age_days = 1" >> $CONF
echo "c.JupyterHub.db_url = '${SERVDIR}/jupyterhub.sqlite'" >> $CONF
echo "c.JupyterHub.extra_log_file = '${LOGFILE}'" >> $CONF
echo "c.JupyterHub.logo_file = '${SERVDIR}/logo.png'" >> $CONF
echo "c.Spawner.notebook_dir = '~/notebooks'" >> $CONF
```

 - Proceed to the instructions at http://www.akadia.com/services/ssh_test_certificate.html to create a self-signed SSL certificate or even better use a CA-certified SSL certificate. Put your SSL related files under `/etc/jupyterhub`
 - Proceed to the installation instructions at https://github.com/jupyter/jupyterhub
