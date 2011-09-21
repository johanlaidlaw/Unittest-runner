#!/bin/bash
NOW=$(date +"%Y-%m-%d %T")
LOGFILE="commit-$NOW.log"
TMP_FILE="/var/log/unittest/tmp_file"
MAIL_BODY="/var/log/unittest/mail_body"
ALL_TEST="/var/log/unittest/all_tests.log"

php /var/www-testing/http/tests/AllTests.php > "$TMP_FILE"
EXIT_CODE=$?

cd /var/www/http
SVN_INFO=$(svn info)

echo "$SVN_INFO" | while read line
do 
if [[ $line == Last* ]]
	then
	echo "$line" >> "$MAIL_BODY"
fi
done 

echo -e "\n" >> "$MAIL_BODY"
cat "$TMP_FILE" >> "$MAIL_BODY"
echo -e "\n-------------------------------\n" >> "$ALL_TEST"
cat "$MAIL_BODY" >> "$ALL_TEST"

if [ $EXIT_CODE -eq 1 ]
then
	mail -s "Unit test failed" developers@company.com < "$MAIL_BODY"
fi

#Cleanup
rm "$TMP_FILE"
rm "$MAIL_BODY"