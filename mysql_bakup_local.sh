#!/bin/bash
# Backup databases from local mysql server to current dir
# one gzip comressed file per database
MYSQL='/usr/bin/mysql'
MYSQL_USER='mysqluser'
MYSQL_PASS='msqlpass'
MYSQL_HOST='localhost'

MYSQLDUMP='/usr/bin/mysqldump'
MYSQLDAMP_CMD="$MYSQLDUMP -u $MYSQL_USER -p$MYSQL_PASS -h $MYSQL_HOST"
MYSQL_CMD="$MYSQL -u $MYSQL_USER -p$MYSQL_PASS -h $MYSQL_HOST"

GZIP='/bin/gzip'
GZIP_CMD="$GZIP -6"

EXCLUDE="performance_schema information_schema"

DBS="$($MYSQL_CMD -B --disable-column-names -e 'show databases')"

for db in $DBS
do
    skipdb=-1
    if [ "$EXCLUDE" != "" ];
    then
        for i in $EXCLUDE
        do
            [ "$db" == "$i" ] && skipdb=1 || :
        done
    fi

    if [ "$skipdb" == "-1" ] ; then
        FILE="$db.gz"
        $MYSQLDAMP_CMD $db | $GZIP_CMD > $FILE
    fi
done
