wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
tar -xzvf phpMyAdmin-5.0.1-english.tar.gz --strip-components=1 -C /www
envsubst '${DB_NAME} ${DB_USER} ${DB_PASS} ${DB_HOST}' < config.inc.php > /www/config.inc.php
/usr/sbin/php-fpm7 -D
nginx -g "daemon off;"
