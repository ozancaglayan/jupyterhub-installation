# jupyter-server

## System dependencies

```
# apt-get install libsm6 libxrender1 libfontconfig1 build-essential gcc-multilib
```

## Installation of Anaconda

Go download anaconda Python 3 installer from https://www.continuum.io/downloads and install it under `/opt/anaconda3`. Change `PATH` globally so that users start to use the new anaconda distribution:

```
# echo 'export PATH=/opt/anaconda3/bin:$PATH' > /etc/profile.d/anaconda.sh
```

Next create a Python 2.7 environment and anaconda distribution to that environment:

```
# conda create --name py27 python=3
# conda install -n py27 anaconda
```

Install python 2.7 kernel for serving python2 notebooks as well:
```
# source activate py27
# ipython kernel install
```

Now when you logout and login back, your shell will default to the python3 environment:

```
# python
Python 3.5.1 |Anaconda 4.0.0 (64-bit)| (default, Dec  7 2015, 11:16:01) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

At any time you can switch to the 2.7 environment called `py27` with the following command:

```
# source activate py27
# python
Python 2.7.11 |Anaconda 4.0.0 (64-bit)| (default, Dec  6 2015, 18:08:32) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

Finally for going back to the default Python 3 environment, you can type `source deactivate`.

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
