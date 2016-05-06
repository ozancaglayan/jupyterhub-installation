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

Now we can proceed with the installation of Jupyter packages. First let's install JupyterHub and Jupyter kernels for `bash` and `octave`:

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

## Users and Groups

Let's add two groups for students and lecturers for further account and permission management:
```
# addgroup students
Adding group `students' (GID 1000) ...
Done.
# addgroup lecturers
Adding group `lecturers' (GID 1001) ...
Done.
```

### Automatically create student users

Obtain the list of students from your department and automatically create users for them on the system.

## Jupyter-hub installation

 - Create a folder called `/etc/jupyterhub` with permissions `700`
 - Proceed to the instructions at http://www.akadia.com/services/ssh_test_certificate.html to create a self-signed SSL certificate or even better use a CA-certified SSL certificate. Put your SSL related files under `/etc/jupyterhub`
 - Proceed to the installation instructions at https://github.com/jupyter/jupyterhub

```
# pip install jupyterhub
```
jupyterhub --generate-config -f /etc/jupyterhub/jupyterhub.py



## Setup a send-only mail server

Proceed through the tutorial https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-ubuntu-14-04
