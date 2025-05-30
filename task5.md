# Thực hiện allow port, allow ip trên window fw
1. Allow port
Ấn New Rule  
![image](https://github.com/user-attachments/assets/38ef13e9-dc23-4547-8199-280c5aba72fc)  

Chọn Rule type là Port    

![image](https://github.com/user-attachments/assets/9d6700d3-6c2c-49ec-856c-82b577c48db1)  
Điền số port   
![image](https://github.com/user-attachments/assets/8c3143cb-8b0f-4e7b-8e7c-217f4b8c825a)  
Chọn Action match với Rule vừa tạo   
![image](https://github.com/user-attachments/assets/a713454c-6ed4-4761-91aa-3cb6fb3ae258)  
![image](https://github.com/user-attachments/assets/ed69d52e-25b9-44be-ac82-4e9ba6cb6384)
![image](https://github.com/user-attachments/assets/dc9fa964-6c8c-4b33-877d-8dbd760dc909)

3. Allow IP
Chọn New Rule   
Rule Type chọn custom  
![image](https://github.com/user-attachments/assets/3562d66a-77a4-4683-8261-5c7abd5077c8)

![image](https://github.com/user-attachments/assets/6ba3bf21-c723-4306-9a52-54e1cb3ac999)

![image](https://github.com/user-attachments/assets/a044732f-8f6b-4e1e-a58e-839c0aa3d3bc)  

Phần Scope thêm IP muốn allow   
![image](https://github.com/user-attachments/assets/ce63bcbf-6631-4b65-b4bf-872e4f3ef5fb)

![image](https://github.com/user-attachments/assets/d7fb5667-9d40-4ccf-bf74-d360817c3dbf)

![image](https://github.com/user-attachments/assets/1b8500d2-7702-4054-8a7e-61bcaa981311)  

Action chọn Allow   
![image](https://github.com/user-attachments/assets/9f08a1c8-8c60-4b73-bba3-1f7ec71b25bd)
![image](https://github.com/user-attachments/assets/f178210a-c809-40fa-bebd-e3934e0ea66a)
![image](https://github.com/user-attachments/assets/2f632b69-6ade-46c2-97bc-d2fb208031a7)

# Thực hiện block port, block ip trên window fw
Việc Block Port hay IP thao tác sẽ giống với Allow chỉ khác ở phần action chọn Block the connection

![image](https://github.com/user-attachments/assets/ff40446e-d269-4234-85cf-a38282aa38b9)

# Thực hiện giới hạn port, giới hạn ip trên window fw chỉ cho phép ip chỉ định truy cập
Giới hạn IP truy cập tới VPS
![image](https://github.com/user-attachments/assets/55b3c04a-ac98-4090-a119-82fec7b884f9)
![image](https://github.com/user-attachments/assets/b164e2a1-935d-40c3-90c7-3b4a26344250)
![image](https://github.com/user-attachments/assets/e7f4edee-0164-4427-9fda-63164c72a573)
![image](https://github.com/user-attachments/assets/907fcde1-f390-4e47-b127-e52e305c0a6a)

# Thực hành cài đặt 
- ISS đã được cài đặt mặt định trên window tại Vietnix  
- Cài thêm CGI và PHP manager tại https://github.com/picassio/PHPManagerForIIS-Versiones
- Cài đặt PHP: https://windows.php.net/download/
- MySQL https://www.mysql.com/downloads/ 

  + Cài đặt website wordpress mặc định
![image](https://github.com/user-attachments/assets/f165d970-33b0-4ef2-bff8-e08f135d5b1b)

  + Cài đặt SSL
Chuyển cert sang PFX sau đó vào server certificate tại IIS để add vào
![image](https://github.com/user-attachments/assets/49203e4c-2bc3-466a-8ac0-3a3be02c1bfc)

- SQL Server: 2016 
Link download: https://software.vietnix.tech/datastore/sources/SQL_Server/sql2016/
