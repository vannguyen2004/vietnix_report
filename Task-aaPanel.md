# Install aaPanel

Truy cập vào website chính thức của aaPanel để lấy script cài đặt: https://www.aapanel.com/new/download.html  

Có 2 phiên bản Pro và Free. Ta copy script của bản Free nhé  

![image](https://github.com/user-attachments/assets/fb5ff62c-e30f-4c68-b008-8508c0d1df51)

Ta copy vào command line VPS  
Port dưới đây sẽ là port để truy cập vào webpanel  

![image](https://github.com/user-attachments/assets/f3c81379-5b99-4961-9317-fd1707d49682)

Sẽ xuất hiện một số option để ta lựa chọn 
Trong thư mục để lưu aaPanel ta chọn y
```Do you want to install aaPanel to the /www directory now?(y/n): y```
Sau khi nhấn y quá trình cài đặt sẽ được tư động
![image](https://github.com/user-attachments/assets/4c1f5ca0-8c55-4b5b-845f-980aa905406a)

![image](https://github.com/user-attachments/assets/3d26fe86-4d9d-4006-96e1-afc2c1b49057)

Sau khi hoàn tất sẽ có thông tin đăng nhập vào Panel. Ta nên lưu lại để phục vụ cho lần đăng nhập tiếp theo nhé

![image](https://github.com/user-attachments/assets/c5ba58e7-1fbe-424d-b9c5-cf1ef926864a)

Sau đó ta truy cập là địa chỉ như trên hình đầu tiên nhé
**https://14.225.254.186:14399/e2e7ac4c**

![image](https://github.com/user-attachments/assets/190e2a50-226e-4423-bfb7-a221d30585c1)

![image](https://github.com/user-attachments/assets/9243c418-bd7a-4cbf-8b1f-f9b477d23545)

Ta nhập thông tin đăng nhập vào sau đó nhấn login

![image](https://github.com/user-attachments/assets/9d35e7ec-4504-45e0-a6a8-ab1a4498946d)

Sau khi đăng nhập hoàn tất

![image](https://github.com/user-attachments/assets/fc2dc425-bc00-42e9-823a-3b26b8d58cc6)


# Cài đặt wordpress trên domain: wp.nguyen.vietnix.tech

### Hướng dẫn này sẽ hướng dẫn cài Wordpress bằng tay từ đầu đến cuối, hoặc có thể dùng one-click deployment  trên aaPanel để cài tự động

### Cài đăng web server, ftp và mysql 
1. Cài đặt website. Ở đây mình chọn Apache 
![image](https://github.com/user-attachments/assets/1ebaa558-8c96-466d-a071-9a8d1a25a703)

![image](https://github.com/user-attachments/assets/b5baa1f4-b269-4a24-8a26-bacbf3b7fb92)

Sau khi tải xong sẽ có ký tự apache ở đây 
Ta chọn add site ở đây nhé. Chú ý Wordpress chạy trên PHP nên ta chọn PHP Project 
![image](https://github.com/user-attachments/assets/d35e5a6d-a696-4622-9540-43c608390c76)

Tải thêm FTP và DATABASE và PHP  nữa nhé 
![image](https://github.com/user-attachments/assets/7598785c-3025-405e-a073-13543459cef9)

![image](https://github.com/user-attachments/assets/3d5517f0-a6bf-4b6e-8a04-5120508f0a2b)

![image](https://github.com/user-attachments/assets/fa793477-cf56-4b5f-adc1-4a2921212410)

![image](https://github.com/user-attachments/assets/2d7e37e6-a9e9-42ba-a2c1-d116cc7c169b)




Ta chọn add site và điền các thông tin cần thiết như Domain, tài khoản FTP và Database. Sau đó nhấn Confirm 

![image](https://github.com/user-attachments/assets/d71d60f4-b84c-4a9f-b897-c4ca1bf316d6)



![image](https://github.com/user-attachments/assets/51653412-6326-4c75-a600-b548b8563657)


Sau khi cài đặt xong ta ấn vào phần document root của website sau đó up load source wordpres lên sau đó xả nhén nhé
![image](https://github.com/user-attachments/assets/d75f29b9-accd-49f4-baab-6b355a651f0a)

![image](https://github.com/user-attachments/assets/a2d53b66-ba65-40c3-8da5-3e3a3fb8944e)


Setup SSL cho website

![image](https://github.com/user-attachments/assets/3ffdb43d-d5ab-4516-bde0-262912fa621c)
![image](https://github.com/user-attachments/assets/fdf554b9-f747-4d79-b959-981be5b05b6b)

![image](https://github.com/user-attachments/assets/d2b1386c-e8d0-4c02-bccd-36fffe3d0f22)

## Setup Web với Lavarel
1. Tải 2 software:
   - one-click deployment 1.3
   - PHP-7.4
2. Tiến hành tạo web
- Ấn setting  one-click deployment 1.3
![image](https://github.com/user-attachments/assets/703d92c6-0328-4861-a69f-d713deb93924)
- Chọn lavarel7x
![image](https://github.com/user-attachments/assets/defc37e0-d9cc-4e1f-9e07-1ab5dd390cc5)

- Ta điền các thông số domain và thông tin database sao đó ấn submit
![image](https://github.com/user-attachments/assets/64cdbe7e-c3db-4c15-921b-8415ddc513bc)
- Đang trong quá trình cài đặt
![image](https://github.com/user-attachments/assets/6014db32-f336-4a95-8355-43c789fb22f8)
![image](https://github.com/user-attachments/assets/2bd72cbf-a655-43bc-a677-cf41e9f39d1a)

- Cài SSL như lúc cài SSL trên wordpress
![image](https://github.com/user-attachments/assets/57e654ad-597f-4a69-9d8b-eb1eb2b983e9)

![image](https://github.com/user-attachments/assets/a806e675-662e-42ac-85cf-7948b3d95858)



# Cài plugin wordpress
Ta truy cập vào domain: **wp.nguyen.vietnix.tech** sau đó setup các thông tin. Database  sẽ là thông số lúc tạo add site trước đó

![image](https://github.com/user-attachments/assets/5cb9b4d5-1bf8-4ffe-86a4-b78339568d8b)

![image](https://github.com/user-attachments/assets/7f964c65-1c5b-4af9-854a-7525d03f394c)

![image](https://github.com/user-attachments/assets/d056e241-9460-4328-aa98-7493b02653c9)

![image](https://github.com/user-attachments/assets/5ebd2e7a-ef4b-4e77-bf85-53efcb653ce2)

![image](https://github.com/user-attachments/assets/537b0e33-b1a7-4e22-afe8-205f44b8dbdb)

### Plugin

1. Plugin All-in-One
![image](https://github.com/user-attachments/assets/e36429ee-d818-4aa8-8ce4-cda2e670395f)

2. Cài đặt toàn bộ plugin có trong trang portal

Tiến hành upload các plugin 
![image](https://github.com/user-attachments/assets/7fc4cb27-4167-476e-879d-8d3f6e074c79)

![image](https://github.com/user-attachments/assets/a01a3c4d-d12d-4ab8-9c34-25e80ec45b62)

Sau khi upload và kích hoạt

![image](https://github.com/user-attachments/assets/98759b84-b3db-4f14-97e8-885363a6f094)
![image](https://github.com/user-attachments/assets/0b1f522c-6609-4a7d-9f4b-c11d96155cac)
![image](https://github.com/user-attachments/assets/b420c228-007a-4fe6-a8e9-e138f15df4cf)


# Tìm hiểu về plugin WP-Optimize – Cache và Litespeed Cache
Trước tiên ta tìm hiểu 2 plugin này là gì 

- WP-Optimize là plugin tối ưu hóa hiệu suất và cơ sở dữ liệu cho WordPress. Đây là một công cụ tất cả trong một với một bộ tính năng giải quyết các khía cạnh khác nhau của việc tối ưu hóa trang web, chủ yếu tập trung vào bộ nhớ đệm, dọn dẹp cơ sở dữ liệu và nén hình ảnh
- Litespeed Cache: là một plugin WordPress giúp tăng tốc trang web bằng cách sử dụng bộ nhớ đệm cấp máy chủ, do đó cải thiện hiệu suất và tốc độ tải trang. Nó là được những việc như: Lưu trữ đệm, Tăng tốc trang web, Tối ưu hóa hình ảnh,...

Về mục đính: Cả hai plugin này đều được dùng để tăng tốc độc website nhưng hoàn cảnh sử dụng có thể sẽ khác nhau
- WP-Optimize – Cache: Được sử dụng tất cả các website wordpress. Không 
- Litespeed Cache: Được sử dụng trên website wordpress chạy trên nền tảng webserver openlitespeed hoặc  LiteSpeed Web Server

So về tốc độ Litespeed Cache sẽ có tốc độ tốt hơn khi dữ liệu sẽ được cache trên webserver nghĩa là khi có yêu cầu gửi đến webserver thì sẽ dùng cache luôn không cần chuyển lưu lượng đến dữ liệu người dùng lấy cache







---------------------------------------------------------------------------------------










