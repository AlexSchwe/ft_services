cp /tmp/* /www/
chmod +x www/wp-config.php
cd /www
ls
wp core is-installed
if [ $? == 1 ]; then
    echo "wp core is-installed has exit status 1"
    wp core download
    wp core install --url=wordpress/ --path=/www --title="My site" --admin_user="aschwere" --admin_password="pass" --admin_email=aschwere@42.student.fr --skip-email
    :> /tmp/postid

    wp user create eddy editor@example.com --role=editor --user_pass=editor
    wp user create autist author@example.com --role=author --user_pass=author
    wp user create contenbonker contributor@example.com --role=contributor --user_pass=contributor
    wp user create simp subscriber@example.com --role=subscriber --user_pass=subscriber
else
    echo "wp core is-installed has exit status NOT 1"
    echo "Wordpress was already installed in the /www directory"
fi
