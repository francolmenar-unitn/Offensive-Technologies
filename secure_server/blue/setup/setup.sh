#!/bin/bash

echo "Installing LAMP stack..."
/proj/OffTech/cctf_secureserver/install_server

echo "Installation finished. Proceeding with mysql setup..."
user=$(whoami)
TEMP_PATH="/users/$user/secure_server/blue"

echo "Changing mysql root password..."
sudo mysql -u'root' -p'rootmysql' < $TEMP_PATH/root.sql

echo "Creating user for web application..."
mysql -u"root" -p"iamrootbitch1984" < $TEMP_PATH/user.sql

echo "Cleaning up records on the db..."
mysql -u"root" -p"iamrootbitch1984" < $TEMP_PATH/cleanup.sql

echo "Finished setting up secure mysql."

#echo "Copying secure php scripts..."
#sudo cp $TEMP_PATH/process_refactored.php /var/www/html/process.php
#echo "Secure php scripts successfully copied."