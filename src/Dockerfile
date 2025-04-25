#
# {{generated_by_builder}}
#

FROM <?php printf("php:%s-%s\n", $version, $flavour) ?>

MAINTAINER Nick Jones <nick@nicksays.co.uk>
<?php
    $versionSpecificPackages = [];

    if (version_compare($version, '7.3', '>=')) {
        $versionSpecificPackages[] = 'libzip-dev';
    }

    if (version_compare($version, '7.4', '>=')) {
        $versionSpecificPackages[] = 'libonig-dev';
    }

    $packages = array_merge([
		'libfreetype6-dev',
        'libicu-dev',
        'libjpeg62-turbo-dev',
        'libmcrypt-dev',
        'libpng-dev',
        'libxslt1-dev',
        'libxml2-dev',
        'libssl-dev',
        'sudo',
        'unzip',
        'vim',
        'libgtk2.0-0',
        'libgtk-3-0',
        'libnotify-dev',
        'libgconf-2-4',
        'libnss3',
        'libxss1',
        'libasound2',
        'libxtst6',
        'xauth',
        'xvfb',
        'nodejs',
        'npm',
        'git',
        'default-mysql-client'
    ], $imageSpecificPackages ?? [], $versionSpecificPackages ?? []);
?>

# Install dependencies
RUN apt-get update \
  && apt-get install -y ca-certificates curl gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && NODE_MAJOR=20 echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
  && apt-get install --no-install-recommends -y \
    <?php echo join(" \\ \n    ", $packages) ?> \
  && rm -rf /var/lib/apt/lists/* \
  && npm install -g grunt-cli

# Configure the gd library
<?php if (version_compare($version, '7.3', '<=')): ?>
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
<?php else: ?>
RUN docker-php-ext-configure \
  gd --with-freetype --with-jpeg
<?php endif ?>

# Install required PHP extensions
<?php $phpExtensions = array_merge([
  'dom',
  'gd',
  'intl',
  'mbstring',
  'pdo_mysql',
  'xsl',
  'zip',
  'soap',
  'bcmath',
  'pcntl',
  'sockets',
  'mysqli'
], $imageSpecificPhpExtensions ?? []);
?>

RUN docker-php-ext-install \
  <?php echo join(" \\ \n  ", $phpExtensions) ?>


# Install Xdebug (but don't enable)
<?php $xdebugVersion = ($xdebugVersion == 'latest' || $xdebugVersion == '') ? '' : '-' . $xdebugVersion; ?>
RUN pecl install -o -f <?php printf("xdebug%s\n", $xdebugVersion) ?>

ENV PHP_MEMORY_LIMIT 2G
ENV PHP_ENABLE_XDEBUG false
ENV MAGENTO_ROOT /var/www/magento

ENV DEBUG false
ENV UPDATE_UID_GID false

ADD etc/php-xdebug.ini /usr/local/etc/php/conf.d/zz-xdebug-settings.ini
ADD etc/mail.ini /usr/local/etc/php/conf.d/zz-mail.ini

ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

ENTRYPOINT ["/docker-entrypoint.sh"]
