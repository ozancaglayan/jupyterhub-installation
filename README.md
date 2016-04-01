# jupyter-server

## Installation of Anaconda

Go download anaconda python distribution from https://www.continuum.io/downloads and install it under `/opt`. Change `PATH` globally so that users start to use the new anaconda distribution:

```
# echo 'export PATH=/opt/anaconda2/bin:$PATH' > /etc/profile.d/anaconda.sh
```

## Setup a send-only mail server

Proceed through the tutorial https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-ubuntu-14-04

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

## Automatically create student users

Obtain the list of students from your department and automatically create users for them on the system.
