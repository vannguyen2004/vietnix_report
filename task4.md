# Mô hình Nginx Reverse Apache
- Cài đặt nginx ```apt install -y nginx ```
- Cài đặt Apache ```apt install -y apache2```
- Cài đặt PHP ```apt install -y php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-curl php7.4-mbstring php7.4-xml```
- Cài MySQL ```apt -y install mysql-server```
- phpMyadmin downlòad tại trang chủ: https://www.phpmyadmin.net/downloads/
- 



#
Tạo database MySQL: 
- create database wordpress;
- create database laravel;
Tạo User: 
- create user 'wordpress'@'localhost' identified by 'wordpress';
- create user 'laravel'@'localhost' identified by 'laravel';

Gán quyền trên database
- GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
- GRANT ALL PRIVILEGES ON laravel.* TO 'laravel'@'localhost';

  Enable moudle
