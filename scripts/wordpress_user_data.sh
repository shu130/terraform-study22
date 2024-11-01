#!/bin/bash
yum -y update
# Apache、PHPのインストール
amazon-linux-extras enable php7.4
yum install -y httpd php php-mysqlnd php-xml php-gd php-mbstring mysql

# Apacheの自動起動と開始
systemctl enable httpd
systemctl start httpd

# WordPressのダウンロードと配置
cd /var/www/html
wget https://ja.wordpress.org/latest-ja.tar.gz
tar -xzvf latest-ja.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest-ja.tar.gz

# WordPressディレクトリのパーミッション設定
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

# wp-config.phpの設定
cp wp-config-sample.php wp-config.php
chown apache:apache wp-config.php
sed -i "s/database_name_here/${rds_db_name}/" wp-config.php
sed -i "s/username_here/${rds_username}/" wp-config.php
sed -i "s/password_here/${rds_password}/" wp-config.php
sed -i "s/localhost/${rds_endpoint}/" wp-config.php