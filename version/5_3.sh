#!/bin/bash

echo "=========== Installing dependencies ============"
apt-get update
apt-get install -y git wget cmake libmcrypt-dev libreadline-dev
apt-get build-dep -y php5-cli

echo "========== Installing libmemcached =========="
wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar xzf libmemcached-1.0.18.tar.gz && cd libmemcached-1.0.18
./configure --enable-sasl
make && make install
cd .. && rm -fr libmemcached-1.0.18*


echo "============ Installing phpenv ============="
git clone git://github.com/CHH/phpenv.git $HOME/phpenv
$HOME/phpenv/bin/phpenv-install.sh
echo 'export PATH=$HOME/.phpenv/bin:$PATH' >> $HOME/.bashrc
echo 'eval "$(phpenv init -)"' >> $HOME/.bashrc
rm -rf $HOME/phpenv

echo "============ Installing php-build =============="
git clone git://github.com/php-build/php-build.git $HOME/php-build
$HOME/php-build/install.sh
rm -rf $HOME/php-build

# Activate phpenv
export PATH=$HOME/.phpenv/bin:$PATH
eval "$(phpenv init -)"

echo "============ Building PHP 5.3.29 =============="
php-build -i development --pear 5.3.29 $HOME/.phpenv/versions/5.3.29
phpenv rehash 
phpenv global 5.3.29

echo "============ Installing PHPUnit ============="
wget https://phar.phpunit.de/phpunit.phar
chmod +x phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit

echo "============ Installing Composer ============"
curl -s http://getcomposer.org/installer | php
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer

echo "=========== Installing PHP extensions =============="
apt-get install -y libzmq-dev
printf '\n' | pecl install memcache
printf '\n' | pecl install memcached
printf '\n' | pecl install mongo
printf '\n' | pecl install amqp
printf '\n' | pecl install zmq-beta
printf '\n' | pecl install redis
