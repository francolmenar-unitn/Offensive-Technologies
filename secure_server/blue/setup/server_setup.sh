#!/bin/bash

echo "Installing LAMP stack..."
/proj/OffTech/cctf_secureserver/install_server

echo "Installation finished. Proceeding with mysql setup..."
user=$(whoami)
TEMP_PATH="/users/$user/blue"

echo "Changing mysql root password..."
sudo mysql -u'root' -p'rootmysql' < $TEMP_PATH/db/root.sql

echo "Creating user for web application..."
mysql -u"root" -p"iamrootbitch1984" < $TEMP_PATH/db/user.sql

echo "Cleaning up records on the db..."
mysql -u"root" -p"iamrootbitch1984" < $TEMP_PATH/db/cleanup.sql

echo "Finished setting up secure mysql."

echo "Copying secure php scripts..."
sudo mv /var/www/html/process.php /var/www/html/process.php.old
sudo cp $TEMP_PATH/php/process_refactored.php /var/www/html/process.php
echo "Secure php scripts successfully copied."

echo "Adding users with improved passwords"
echo "Adding user Jelena"
psw=$(./random_psw.sh)
curl -o /dev/null "http://127.0.0.1/process.php?user=jelena&pass=${psw}&drop=register"
echo "Adding user John"
psw=$(./random_psw.sh)
curl -o /dev/null "http://127.0.0.1/process.php?user=john&pass=${psw}&drop=register"
echo "Adding user Kate"
psw=$(./random_psw.sh)
curl -o /dev/null "http://127.0.0.1/process.php?user=kate&pass=${psw}&drop=register"
