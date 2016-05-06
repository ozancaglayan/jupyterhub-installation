#!/bin/bash

apt-get update

# Install system dependencies
apt-get install -y  libsm6 libxrender1 libfontconfig1 build-essential gcc-multilib \
                    npm nodejs-legacy octave \
                    pandoc dvipng \
                    texlive-latex-base dvipng texlive-latex-recommended \
                    texlive-fonts-recommended cm-super texlive-latex-extra

# Install configurable-http-proxy
npm install -g configurable-http-proxy

# Remove MOTD files
rm /etc/update-motd.d/* &> /dev/null

# Create notebooks folder in each new user's home folder
mkdir -p /etc/skel/notebooks &> /dev/null
if [ ! -d /etc/skel/notebooks ]; then
  mkdir /etc/skel/notebooks
fi
