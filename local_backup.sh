#!/bin/bash

USER=
PASS=
DB=
GZIP=$(whereis gzip | cut -d ' ' -f 2)
TIME=$(date +'%d%m%Y')
###DST=/home/backup/
LOGFILE=/var/log/backup.log
DST=/home/backup/BACKUP/
BACKUP_SERVER=

cd /home/backup/

echo >> $LOGFILE
echo "// BEGIN -- $TIME"  >> $LOGFILE

#mysqldump -u $USER -p$PASS $DB | ${GZIP} -c > ${DB}.${TIME}.sql.gz

# Дамп БД
echo "[*-----] dumping '$DB' database..." >> $LOGFILE
mysqldump -u $USER -p$PASS $DB > ${DB}.${TIME}.sql
if [[ $? != 0 ]]; then
    echo "[*-----] dumping failed!" >> $LOGFILE
    exit 1
else
    echo "[**----] done." >> $LOGFILE
fi

# Создание tar-бокса
echo "[***---] creating gz file..." >> $LOGFILE
${GZIP} -f ${DB}.${TIME}.sql
if [[ $? != 0 ]]; then
    echo "[***---] FAILED!" >> $LOGFILE
    exit 1
else
    echo "[****--] done." >> $LOGFILE
fi

# Копирование БД на сервер бэкапа
##echo "[*****-] copying database to backup server..." >> $LOGFILE
##scp ${DB}.${TIME}.sql.gz $BACKUP_SERVER:$DST &>> $LOGFILE
##if [[ $? != 0 ]]; then
##    echo "[*****-] FAILED!" >> $LOGFILE
##    exit 1
##else
##    echo "[******] done." >> $LOGFILE
##fi

echo "// END -- $TIME"  >> $LOGFILE



