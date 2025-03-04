#!/bin/sh

echo "Script: Set permissions to Mariadb directory"
chmod -R 755 /var/lib/mysql

echo "Script: Create directory for socket file"                                    
mkdir -p /run/mysqld 

echo "Script: Change ownership of Data Directories to mysql"
chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Script: Create MariaDB System Tables, Define Base directory (mariadb files) && Define Data Directry (Where site data will be saved)"
	mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql >/dev/null

	echo "Script: Create Wordpress Database, Master User and Define root user password"
	mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD";
CREATE DATABASE $WP_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER $WP_DATABASE_USER@'%' IDENTIFIED by "$WP_DATABASE_PASSWORD";
GRANT ALL PRIVILEGES ON $WP_DATABASE_NAME.* TO $WP_DATABASE_USER@'%';
FLUSH PRIVILEGES;
EOF

else
	echo "Script: Mariadb already Installed, Database Created and Configured with Users"
fi

echo "Script: Run Mariadb (wih mysqld) on a main process (exec) with Configuration File"

exec mysqld --defaults-file=/etc/my.cnf.d/mariadb_config
