#!/bin/sh
# 
# Dumps the database and adds it the current commit
# 11.28.2012 -- now supports overriding the working DB sql file
# You may need to chmod +x mysql_config

. ./mysql_config

echo "This script does a Find and Replace on the MySql in $fname.sql. You can use it when migrating WP URLs. The original file is left intact, the results are in REPLACED.sql."

. ./confirm_continue

read -e -p "Enter the string to find (e.g. original url): " URL_OLD
read -e -p "Enter the string to replace with (e.g. new url): " URL_NEW
read -e -p "Would you like to OVERRIDE the working db file after replacement? (y/n)" DB_OVERRIDE

echo "Finding occurrences of $URL_OLD and replacing with $URL_NEW..."

sed -e 's/'$URL_OLD'/'$URL_NEW'/g' $fname.sql > REPLACED.sql

echo "Done. See REPLACED.sql for the results."

if [ "$DB_OVERRIDE" == "y" ]; then
	echo "Performing DB Override (allows for easy importing) -- remember DO NOT commit an overridden database to the repository!"
	rm -f $fname.sql
	cp REPLACED.sql $fname.sql
fi
