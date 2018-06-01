#!/bin/sh
set -e

phpextensions="pdo_mysql gd mcrypt mbstring zip intl xsl soap"
buildDeps="libmcrypt-dev libcurl3-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev libicu-dev libxslt1-dev"
requirements="libxslt1.1 libmcrypt4 libfreetype6 libjpeg62-turbo vim git wget colordiff curl rsync ssh mysql-client zip ssmtp cron netcat nodejs $buildDeps"
apt-get update

apt-get install -y gnupg
curl -sL https://deb.nodesource.com/setup_6.x | bash -

apt-get install --no-install-recommends -y $requirements && rm -rf /var/lib/apt/lists/*


for ext in $phpextensions; do
    if [ "$ext" = "gd" ]; then
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
    fi

    docker-php-ext-install $ext
done;
pecl install xdebug-2.5.0

a2enmod rewrite expires

npm install grunt-cli -g

chsh -s /bin/bash www-data
rm -rf /var/www/html/*
chown -R www-data:www-data /var/www

# add Magento cronjob
chmod 0644 /etc/cron.d/magento2-cron
crontab -u www-data /etc/cron.d/magento2-cron

# add composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
composer global require hirak/prestissimo

# add n98-magerun
wget -P /usr/local/bin/ https://files.magerun.net/n98-magerun2.phar
wget -P /usr/local/bin/ https://github.com/steverobbins/magedownload-cli/releases/download/opnv2.1.0/magedownload.phar

chmod +x /usr/local/bin/*

mkdir /var/magento
chown -R www-data: /var/magento
cd /var/magento

# clean up
#apt-get purge --auto-remove -y $buildDeps
