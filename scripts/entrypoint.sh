#!/bin/bash

# Compile php ini config
envsubst < /opt/uploads.tmpl > /usr/local/etc/php/conf.d/uploads.ini

# Disable Strict Host checking for non interactive git clones

mkdir -p -m 0700 ~/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config

if [ ! -z "$SSH_KEY" ]; then
  echo $SSH_KEY > ~/.ssh/id_rsa.base64
  base64 -d ~/.ssh/id_rsa.base64 > ~/.ssh/id_rsa
  chmod 600 ~/.ssh/id_rsa
fi

# Setup git variables
if [ ! -z "$GIT_EMAIL" ]; then
  git config --global user.email "$GIT_EMAIL"
fi
if [ ! -z "$GIT_NAME" ]; then
  git config --global user.name "$GIT_NAME"
  git config --global push.default simple
fi

# Dont pull code down if the .git folder exists
if [ -d "/var/www/html/.git" ]; then
  # Clone code from git for our site!
  if [ ! -z "$GIT_REPO" ]; then
    rm -Rf /var/www/html/*
    if [ ! -z "$GIT_BRANCH" ]; then
      git clone -b $GIT_BRANCH $GIT_REPO /var/www/html
    else
      git clone $GIT_REPO /var/www/html
    fi
  fi
else
  # Pull down code from git for our site!
  git pull
fi

# Install composer dependenncies
if [ -f "/var/www/html/composer.json" ]; then
  if [ -d "/var/www/html/vendor" ]; then
    composer update
  else
    composer install
  fi 
fi

exec "$@"
