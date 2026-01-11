FROM adminer:latest

USER root

# Install MongoDB extension dependencies and the extension itself
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS openssl-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && apk del .build-deps \
    && apk add --no-cache libssl3 libcrypto3

# Copy Dracula theme
COPY --chown=adminer:adminer adminer.css /var/www/html/adminer.css

# Copy extra plugins
COPY --chown=adminer:adminer plugins/favorite-query.php /var/www/html/plugins/favorite-query.php

# Create plugins-enabled directory and manually enable plugins/drivers to ensure they load correctly.
# We load the MongoDB driver inside the first plugin loader to avoid adding invalid objects to the $plugins array.
RUN mkdir -p /var/www/html/plugins-enabled \
    && echo "<?php require_once('plugins/drivers/mongo.php'); require_once('plugins/config.php'); return new AdminerConfig();" > /var/www/html/plugins-enabled/001-config.php \
    && echo "<?php require_once('plugins/favorite-query.php'); return new AdminerFavoriteQuery();" > /var/www/html/plugins-enabled/002-favorite-query.php \
    && chown -R adminer:adminer /var/www/html/plugins-enabled

# Set ADMINER_PLUGINS empty because we load them manually
ENV ADMINER_PLUGINS=""

USER adminer
