# Mô hình Nginx Reverse Apache
Đầu tiên Proxy là gì?
Hiểu đơn giản Proxy là máy chủ đứng giữa người dùng và server. Nếu dùng để kiểm soát người dùng sẽ là forward proxy. Còn làm việc phía server sẽ là reverse proxy
Vậy Reverse Proxy là gì?
Reverse proxy là máy chủ được triển khai ở phía server, phục vụ cho server. Cách hoạt động sẽ nhận các yêu cầu và gửi đến các backend
Vậy Nginx reverse Apache dùng để làm gì. Tại sao lại là server nginx kết hợp với apache
Về hiệu năng nginx sẽ có hiệu năng cao hơn hẵn so với apache. Do về cơ chế xữ bất đồng bộ. Mặc dù apache cũng có mod worker và event nhưng hiệu xuất vẫn không bằng. Nên nginx đứng trước apache là lựa chọn rất hợp lí. Tránh được quá tải backend hay Dos
Khả năng giữ SSL tốt tránh được quá trình bắt tay (hand shake giữ người dùng là server làm hao tốn băng thông hiệu năng)
Khả năng cache file tĩnh. Tuy nhiên nổi trội vẫn là hiệu suất tốt.

Vậy tại sao không sử dụng nginx để là web server chính cho website mà lại dùng là reverse proxy. Lí do chính là khả năng tùy chính thấp hơn do với apache. Trên môi trường hosting hay người quản trị server và phát triển website khác nhau thì apache lại có ưu thế hơn hẵn do có thể dùng htaccess để cấu hình ở phía client thay thì phải thay đổi cấu hình của server điều này giúp thuận tiện cho người deploy code nhưng không làm ảnh hưởng tới server hoặc tới những người dùng khác (ví dụ trong môi trường share hosting)

Ở trên là một chút ưu điểm và nhước điểm của 2 web server trên. Thì đã sinh ra Litespeed server khả năng chịu tại như nginx và có thể dễ dàng tùy chỉnh như apache. Tuy nhiên sẽ tính phí, có phiên bản miễn phí nhưng sẽ hạn chết vài tính năng


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
Bật PHP
  Enable moudle
