/usr/sbin/php-fpm7
mkdir www/wordpress 
chown -R www www www/wordpress
envsubst '${AUTHOR} ${DB_NAME} ${DB_USER}  ${DB_PASS} ${MYSQL_SERVICE_HOST}' < /tmp/wp-config.php > www/wordpress/wp-config.php
su www -c "/usr/bin/wp-cli core download --path=/www/wordpress/"
chmod -R 777 www/wordpress
nginx
su www -c "/usr/bin/wp-cli core is-installed --path=/www/wordpress/"
while [ $? == 1 ]; do
sleep 5
su www -c "/usr/bin/wp-cli core is-installed --path=/www/wordpress/"
done
su www -c "/usr/bin/wp-cli user create alice alicer@example.com --role=editor --user_pass=editor --path=/www/wordpress/"
su www -c "/usr/bin/wp-cli user create bob bob@example.com --role=author --user_pass=author --path=/www/wordpress/"
nginx -s reload
tail -f /dev/null

