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
  echo "config email"
  git config --global user.email "$GIT_EMAIL"
fi
if [ ! -z "$GIT_NAME" ]; then
  echo "config name"
   git config --global user.name "$GIT_NAME"
   git config --global push.default simple
fi

# Dont pull code down if the .git folder exists
if [ ! -d "/var/www/html/.git" ]; then
  # Clone code from git for our site!
  if [ ! -z "$GIT_SOURCE" ]; then
    echo "git source variable found"
    rm -Rf /var/www/html/*
    if [ ! -z "$GIT_BRANCH" ]; then
      echo "cloning branch"
      git clone -b $GIT_BRANCH $GIT_SOURCE /var/www/html
    else
      echo "cloning without branch"
      git clone $GIT_SOURCE /var/www/html
    fi
  fi
else
  # Pull down code from git for our site!
  echo "pulling"
  cd /var/www/html && git pull
fi

chown -R www-data:www-data /var/www

# Install composer dependenncies
if [ -f "/var/www/html/composer.json" ]; then
   echo "found composer json"
  if [ -d "/var/www/html/vendor" ]; then
    echo "found vendor dir, doing update"
    sudo -u www-data composer update
  else
    echo "doing composer install"
    sudo -u www-data composer install
  fi 
fi

exec "$@"
