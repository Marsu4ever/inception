#!/bin/sh

echo "Script: helllooo world"

#if [ ! -d  "/var/lib/mysql/mysql" ]; then
echo "Script: Create and Initialize MariaDB System Tables"
mariadb-install-db --basedir=/usr --user=mysql --datadir=/var/lib/mysql
#fi

echo "Script: Create directory for socket file"
mkdir -p /run/mysqld

echo "Script: Give permission to mysql in database directories"
chown -R mysql:mysql /var/lib/mysql /run/mysqld

echo "Script: Ready to run MariaDB"

exec mysqld --user=mysql
