#!/bin/bash
# Backup tables from remote mysql server via ssh to current dir
# one gzip compressed file per database
SSH='/usr/bin/ssh'
SSH_USER='user'
SSH_HOST='host.tld'

MYSQL='/usr/bin/mysql'
MYSQL_USER='mysqluser'
MYSQL_PASS='mysqlpass'
MYSQL_HOST='localhost'

MYSQLDUMP='/usr/bin/mysqldump'
MYSQLDAMP_CMD="$MYSQLDUMP -u $MYSQL_USER -p$MYSQL_PASS -h $MYSQL_HOST"

SSH_CMD="$SSH $SSH_USER@$SSH_HOST"
MYSQL_CMD="$MYSQL -u $MYSQL_USER -p$MYSQL_PASS -h $MYSQL_HOST"

GZIP='/bin/gzip'
GZIP_CMD="$GZIP -6"

EXCLUDE="mysql performance_schema information_schema"

DBS="$($SSH_CMD $MYSQL_CMD -B --disable-column-names -e 'show databases')"
for db in $DBS
do
    skipdb=-1
    for i in $EXCLUDE
    do
        [ "$db" == "$i" ] && skipdb=1 || :
    done


    if [ "$skipdb" == "-1" ] ; then
        FILE="$db.gz"
        $SSH_CMD "$MYSQLDAMP_CMD $db | $GZIP_CMD" > $FILE
    fi
done