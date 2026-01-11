FROM adminer:latest

USER root

# Install MongoDB extension dependencies and the extension itself
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS openssl-dev \
    && pecl install mongodb     && docker-php-ext-enable mongodb     && apk del .build-deps     && apk add --no-cache libssl3 libcrypto3

# Copy Dracula theme
COPY --chown=adminer:adminer adminer.css /var/www/html/adminer.css

# Copy all plugins from the local directory to the container
COPY --chown=adminer:adminer plugins/ /var/www/html/plugins/

# Use the official environment variable for standard plugins.
# The entrypoint script will automatically generate the loaders for these.
ENV ADMINER_PLUGINS="config favorite-query foreign-system"

# Manually enable the MongoDB driver because the official plugin-loader.php 
# refuses to load files from subdirectories (like drivers/mongo.php).
# We MUST return an object (like stdClass) to avoid "TypeError" in Adminer's constructor.
RUN mkdir -p /var/www/html/plugins-enabled \
    && echo "<?php require_once('plugins/drivers/mongo.php'); return new stdClass();" > /var/www/html/plugins-enabled/000-mongo.php \
    && chown -R adminer:adminer /var/www/html/plugins-enabled

USER adminer
