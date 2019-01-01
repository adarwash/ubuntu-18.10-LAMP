#!/bin/bash 
apt-get update -y &&  apt-get upgrade -y &&  apt-get install  expect apache2 php libapache2-mod-php php-common php-mbstring php-xmlrpc php-soap php-gd php-xml php-intl php-mysql php-cli php-zip php-curl php-gettext phpmyadmin mysql-server -y
read -s -p "Enter Password for MYSQL (MUST be same password you used for PhpMyAdmin): " MYSQL_ROOT_PASSWORD
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"plugin?\"
send \"y\r\"
expect \"Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:\"
send \"0\r\"
expect \"New password:\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Do you wish to continue with the password provided?\"
send \"y\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
echo "$SECURE_MYSQL"
mysql -u root <<-EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF
//Need to check what installed sucessfully and what has not
clear
echo 'Installed'
