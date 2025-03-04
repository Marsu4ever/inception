#!/bin/sh

echo "Script: Give more memory for php installation"
echo "memory_limit = 512M" >> /etc/php83/php.ini

echo "Script: Go to Wordpress Working Directory (/var/www/html)"
cd /var/www/html

echo "Script: Download Wordpress Client (rename: wp-cli.phar -> wp)"
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp

echo "Script: Make wp executable"
chmod +x /usr/local/bin/wp

echo "Script: Check if mariadb is running before proceeding"
mariadb-admin ping --protocol=tcp --host=mariadb -u $WP_DATABASE_USER --password=$WP_DATABASE_USER_PASSWORD --wait=300

if [ ! -f /var/www/html/wp-config.php ]; then

	echo "Script: Download Wordpress files (the very essentials of a wordpress site)"
	wp core download --allow-root

	echo "Script: Create essential wordpress configuration file (wp-config.php)"
	wp config create \
		--dbname=$WP_DATABASE_NAME \
		--dbuser=$WP_DATABASE_USER \
		--dbpass=$WP_DATABASE_USER_PASSWORD \
		--dbhost=mariadb \
		--force

	echo "Script: Install Wordpress with Configurations"
	wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" \
		--admin_user="$WP_ADMIN" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--allow-root \
		--skip-email \
		--path=/var/www/html

	echo "Script: Create a (normal) Wordpress user"
	wp user create \
		--allow-root \
		$WP_USER $WP_USER_EMAIL \
		--user_pass=$WP_USER_PASSWORD
else
	echo "Script: Wordpress already Downloaded, Installed and Configured."

fi


echo "Script: Change ownership of wordpress directory (/var/www/html) for user with minimum permissions (www-data)"
chown -R www-data:www-data /var/www/html

echo "Script: Give permissions to user"
chmod -R 755 /var/www/html/


echo "Script: Run php server (FPM) in Foreground (background would make server process end, hence docker container would stop)"
php-fpm83 -F
