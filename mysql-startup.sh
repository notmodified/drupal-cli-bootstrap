#!/bin/bash

if [ ! -f /var/lib/mysql/ibdata1 ]; then
	echo 'Initializing database'
  mysqld --initialize-insecure
  echo 'Database initialized'
fi

mysqld &

mysql=( mysql --protocol=socket -uroot )

for i in {30..0}; do
  if echo 'SELECT 1' | "mysql" &> /dev/null; then
    break
  fi
  echo 'MySQL init process in progress...'
  sleep 1
done

if [ "$i" = 0 ]; then
  echo >&2 'MySQL init process failed.'
  exit 1
fi

mysql <<-EOSQL
SET @@SESSION.SQL_LOG_BIN=0;

DELETE FROM mysql.user ;
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOSQL
