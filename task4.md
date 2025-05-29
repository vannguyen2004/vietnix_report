# Mô hình Nginx Reverse Apache
1. Proxy là gì? Và Reverse Proxy là gì?
- Hiểu đơn giản Proxy là máy chủ trung gian đứng giữa người dùng và server. Nếu dùng để kiểm soát người dùng sẽ là forward proxy. Còn làm việc phía server sẽ là reverse proxy
- Reverse proxy là máy chủ được triển khai ở phía server, phục vụ cho server. Cách hoạt động sẽ nhận các yêu cầu và gửi đến các backend hoặc các web server khác
2. Nginx:
- Nginx Là phần mềm mã nguồn mỡ đa năng dành cho web server, reverse proxy, caching, load balancing, Media streaming
- Về các hoạt động: Nginx hoạt động theo kiến trúc hướng sự kiên, bất đồng bộ của Nginx, giúp xử lý hàng ngàn kết nối đồng thời hiệu quả và tiết kiệm được tài nguyên. Thay vì tao ra Thread cho mỗi yêu cầu thì Nginx quản lí worker connections trong một tiến trình gọi là worker process.
- Gia tăng tốc độ reverse proxy thông qua bộ nhớ đệm (cache)
- Ngoài ra Nginx phục vụ các file tĩnh tốt hơn apache nên yêu cầu gửi đến, nginx sẽ xử lí các file tĩnh và chuyển tiếp các yêu cầu động đến apache để sử lý giúp giảm tảm cho apache. Thay vì chuyển tiếp tất cả các lưu lượng cho apache xử lí

3 Khác nhau giữa Nginx và Apache
Đều là các web server phổ biến mã nguồn mở tuy nhiên cũng có một số khác biệt 
- Nginx: xử lí theo kiến trúc hướng sự kiện không đồng bộ. Giúp không tạo ra qua nhiều tiến trình để xử lí nên dạt được hiệu năng cao dù cấu hình phần cứng thấp. Vượt trội hơn so với sử lí các nội dung tĩnh do tích hợp cache
- Apache: Sử dụng kiến trúc phân luồng (threading) hoặc keep-alive. Khả năng chịu tải kém hơn Nginx cùng cấu hình phần cứng. Tuy nhiên Apache có hỗ trợ tùy chỉnh cấu hình thông qua htaccess và khả năng mở rộng cao với nhiều  module


Ở trên là một chút ưu điểm và nhước điểm của 2 web server trên. Thì đã sinh ra Litespeed server khả năng chịu tại như nginx và có thể dễ dàng tùy chỉnh như apache. Tuy nhiên sẽ tính phí, có phiên bản miễn phí nhưng sẽ không tốt bằng phiên bản trả phí


# Cài đặt Nginx reverse LAMP stack (wordpress và laravel)
### Các bước thực hiện
1. Tải các gói cài đặt cần thiết
- Cài đặt nginx ```apt install -y nginx ```
- Cài đặt Apache ```apt install -y apache2```
- Cài đặt PHP 7.4 và 8.1 và các module cần thiết
- Cài MySQL ```apt -y install mysql-server```
- phpMyadmin downlòad tại trang chủ: https://www.phpmyadmin.net/downloads/
2. Tạo User
allow root remote bằng mysql_installation_secure  hoặc đổi từ root@localhost thành root@% hoặc IP remote  
Tạo database MySQL: 
- CREATE DATABASE wordpress;
- CREATE DATABASE laravel;  
Tạo User: 
- CREATE USER 'wordpress'@'localhost'  IDENTIFIED BY  'wordpress';
- CREATE USER 'laravel'@'localhost' IDENTIFIED BY 'laravel';  
Gán quyền trên database
- GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
- GRANT ALL PRIVILEGES ON laravel.* TO 'laravel'@'localhost';
3. Cấu hình Proxy Pass trên Nginx và Vhost trên Apache
- Cấu hình Reverse Proxy trên wordpress
![image](https://github.com/user-attachments/assets/f7070ec6-3905-4a2d-ba31-a63b41544e14)

- Cấu hình Reverse Proxy trên laravel
![image](https://github.com/user-attachments/assets/c52c8246-dc88-4620-8be6-747c56967451)

- Cấu hình vHost cho wordpress
![image](https://github.com/user-attachments/assets/68b50d7b-adbd-4752-8aa8-2235ec01ccce)
- Cấu hình vHost cho laravel
![image](https://github.com/user-attachments/assets/7110bd96-55ca-4b8b-99a5-23329c920535)




4. Cài đặt phpMyadmin trên wp.nguyen.vietnix.tech  
Dùng gói đã chuẩn bị trước cho vào website và xả nén

### Kết quả

Truy cập bằng http và https trên ```wp.nguyen.vietnix.tech```
![image](https://github.com/user-attachments/assets/ba521f6c-f5bb-435b-a64b-343d33828d0c)
![image](https://github.com/user-attachments/assets/eeae65eb-7d6f-4245-b160-cbfe07f63064)

![image](https://github.com/user-attachments/assets/17f26d9c-8b2f-43f3-ad50-7237b70bddf2)

Truy cập phpMyadmin 
![image](https://github.com/user-attachments/assets/45c93892-215e-4224-9f8e-92784c4cd4af)
![image](https://github.com/user-attachments/assets/2a36405c-d341-4ba3-b16f-64128ca99137)


Truy cập bằng http và https trên ```laravel.nguyen.vietnix.tech```
![image](https://github.com/user-attachments/assets/27c76521-1300-455b-b708-4be570c412a2)
![image](https://github.com/user-attachments/assets/cde3df7d-5e18-4c0b-94f3-d71003dc3548)

Kiểm tra cache

![image](https://github.com/user-attachments/assets/dcc7089a-ec96-411e-850a-40d89518720b)
Nội dung cache được ghi bởi Nginx

![image](https://github.com/user-attachments/assets/b6adffe1-273c-4c67-a8f2-01dc4bef15f5)











