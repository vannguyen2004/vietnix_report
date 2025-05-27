# Linux Command 

### Ping

``` ping vietnix.vn```

![image](https://github.com/user-attachments/assets/2d30056b-f230-4986-ba05-afe2654b7220)

ttl: *time to live*: thời gian dùng để kiểm sóat vòng đời của một gói tin. Trên linux ttl của gói IPv4 mặc định là 64 và sẽ bị giamr đi khi qua 1 hop/router. ttl trả về càng cao chứng tỏ số lượng router chuyển tiếp gói tin càng ít.  

time: là độ trể của gói tin khi đi từ nguồn đến đích và trở lại. Độ trể càng thấp chứng tỏ tốc độ đi đến đích càng nhanh


### SSH Command 
Kết nối sử dụng mật khẩu:
```ssh user_name@ip_or_domain```

Kết nối sử dụng khóa riêng:
```ssh -i /path/private_key username@ip_or_domain```

Kết nối sử dụng cổng tùy chỉnh:
```ssh -p PORT user_name@ip_or_domain```

### SCP
(Copy từ server về nếu ngược lai ta thay đổi source des)   
Sao chép một tệp tin duy nhất:
```scp /path/file username@remote_host:/path_remote  /destination```

Sao chép một thư mục:
```scp -r /path/folder/ username@remote_host:/path_to /remote/destination```

### RSYNC
(Copy từ server về nếu ngược lai ta thay đổi source des)  
Lệnh hay dùng để đồng bộ một tệp tin:
```rsync -avzhe ssh root@x.x.x.x:/path/file.txt /path```

Đồng bộ một thư mục (thêm -r cho đệ quy):
```rsync -avzhe ssh -r root@x.x.x.x:/path/folder /path```


### Cat
Hiển thị nội dung tệp tin:
```cat file.txt```

Hiển thị với số dòng và lọc dòng cụ thể:
```cat -n hello.txt | grep n```

Ghi nhiều dòng vào tệp tin sử dụng EOF:
```
cat > abc.txt << EOF 
Hello
Hi
EOF
```

### Echo
Thêm một dòng vào cuối tệp tin:
```echo "New line" >> file.txt```

Ghi đè nội dung tệp tin:
```echo "New content" > file.txt```

### Tail / Head
Hiển thị phần cuối của tệp tin:
```tail file.txt```

Hiển thị cập nhật theo thời gian thực:
```tailf file.txt```

### Sed
Tìm và thay thế một chuỗi trong tệp tin:
```sed -i 's/old_string/new_string/g' file.txt```

### Traceroute
Lệnh traceroute dùng để xem thông tin quảng đường mà gói tin đi đến đích 

![image](https://github.com/user-attachments/assets/247842c5-e6b7-4481-afee-a0d454dfa3cb)


### Cp
Sao chép một tệp tin:
```cp /path/file /path/destination/```

Sao chép một thư mục:
```cp -r /source /destination```

### Mv
Di chuyển tệp tin hoặc thư mục:
```mv /source /destination```

### Cut
Trích xuất ký tự thứ 3: 
``` cut -c3 <<< "abcd"```

Trích xuất từ ký tự thứ 4 trở đi:
```cut -c4- <<< "abcdxyz"```

Trích xuất phạm vi ký tự từ 3 trở về trước:
```cut -c1-3 <<< "abcdxyz"```

### Chmod
Đặt quyền (chủ sở hữu: đầy đủ, nhóm: đọc/ghi, người khác: đọc):
```chmod 764 file.txt```
Kiểu chữ: 
``` chmod u=rwx,g=rw,o=r file.txt```

### Chown
Thay đổi chủ sở hữu và nhóm:
```chown user:group file.txt```

### Chattr
Đặt thuộc tính không thể thay đổi:
```chattr +i filename```


### Find
Tìm các tệp tin có phần mở rộng .log:
```find /root -type f -name "*.log"```

Tìm thư mục có tên abc:
```find /root -type d -name "abc"```

Tìm tệp tin có tên abc:
```find /root -type f -name "abc"```

Tìm tệp tin có tên abc và đặt quyền chỉ đọc:
```find /root -type f -name "abc" -exec chmod 444 {} \;```

### Sort
Sắp xếp dòng theo thứ tự tăng dần:
```sort filename```

Sắp xếp số theo thứ tự tăng dần:
```sort -n filename```

Sắp xếp theo thứ tự giảm dần:
```sort -r filename```

Sắp xếp số theo thứ tự giảm dần:
```sort -nr filename```

Sắp xếp theo cột:
```sort -k cột filename```

### Uniq
Lọc các dòng trùng lặp liền kề:
```uniq -d filename```

Đếm và hiển thị các dòng trùng lặp:
```uniq -dc filename```

### Wc
Đếm số dòng trong tệp tin:
```wc -l filename```

Đếm số ký tự trong tệp tin:
```wc -c filename```


Traceroute
Theo dõi đường đi đến máy chủ đích:
traceroute destination

Phân tích kết quả để xác định các nút trung gian và độ trễ.

### Netstat
Hiển thị các socket đang lắng nghe:
```netstat -ntlp```

Hiển thị mà không phân giải hostname:
```netstat -n```

Hiển thị mà không phân giải tên cổng:
```netstat -n```

Hiển thị tên tiến trình và PID:
```netstat -p```

Hiển thị chỉ socket TCP:
```netstat -t```

Hiển thị chỉ socket UDP:
```netstat -u```

### Dig
Truy vấn DNS cho bản ghi A:
```dig vietnix.vn A```

Truy vấn DNS cho bản ghi MX:
```dig vietnix.vn MX```

Truy vấn DNS cho bản ghi NS:
```dig vietnix.vn NS```

Truy vấn với máy chủ DNS tùy chỉnh:
```dig vietnix.vn Type_record @ip_resolver```


### Tar
Tạo kho lưu trữ tar:
```tar -cvf file.tar file.txt```

Giải nén kho lưu trữ tar:
```tar -xvf file.tar```

### Zip
Nén tệp tin:
```zip file.zip file.txt```

Giải nén tệp tin:
```unzip file.zip```


Mount / Umount
Liệt kê các đĩa khả dụng:
```lsblk```

Lắp đĩa vào /mnt/test:
```mount /dev/sdb1 /mnt/test```

Tháo đĩa:
```umount /mnt/test```

### Symbolic Links, Hard Links command

Symbolic Link: Là một file đặc biệt chứa đường dẫn tới file hoặc thư mục khác, link gốc hỏng thì Sym Link cũng hỏng theo.    
Hard Link: là một liên kết trực tiếp tới inode của file gốc, file gốc bị xóa thì vẫn có thể truy cập cho link tới inode.  
VDL 
- Sym Link: thư mục domain đầu tiên của một user trên directadmin có một sym link tới public_html của account đó
- 

### Df
Kiểm tra dung lượng đĩa:
```df -hT```

Lưu ý: Phân vùng / là phân vùng gốc của hệ thống.


### Process
Xem tất cả các tiến trình trên hệ thống
```ps aux```
Kết thúc tiến trình bằng PID:
```kill PID```
```kill -9 PID```

### Free
Kiểm tra dung lượng bộ nhớ:
free -h

![image](https://github.com/user-attachments/assets/cc98a8ed-86c8-4edd-b719-02a0d4e9d45d)

- Total: Tổng RAM vật lý. 
- used: Tổng số RAM đã sử dụng
- Free: Tổng số RAM trống
- Share: Số RAM được share cho các tiến trình dùng chung
- Buff/Cache: Số RAM cache I/O được đọc từ đĩa
- Avaliable: Số RAM tối đa mà kernel có thể lấy để bắt đầu process mới
- swap: RAM ảo là RAM được dùng khi phần trăm  RAM vật lí sử dụng chạm đến swappiness. Tránh tình trang kill tiến trinh không cần thiết khi hệ thống hết RAM vật lí (em thấy máy em nhiều RAM nên chưa có thêm vào :> )

### Top
Theo dõi tài nguyên hệ thống:
```top```

Là lệnh xem các thông tin của hệ thống hiện tại: 

Các chỉ số chính: tải trung bình, us (người dùng), sy (hệ thống), ni (nice), id (nhàn rỗi), wa (chờ), hi (ngắt phần cứng), si (ngắt phần mềm), st (thời gian bị đánh cắp), zombie, và tiến trình ngủ. 

![image](https://github.com/user-attachments/assets/ac484b99-fa89-4479-9c66-c99e676ff0cb)

- Load Average: là chỉ số dùng để đo lường mức tải trung bình của hệ thống trong ba khoảng thời gian: 1, 5 và 15 phút.
- Sleeping: tiến trình đang ngủ
- Stopped: Tiến trình bị dừng chờ được kích hoạt 
- Zombie: Tiến trình đã dừng nhưng chưa được dọn dẹp
- us: Tỷ lệ phần trăm CPU đang được sử dụng bởi các tiến trình người dùng.
- sy: Tỷ lệ phần trăm CPU đang được sử dụng bởi các tiến trình hệ thống.
- ni: Tỷ lệ phần trăm CPU dành cho các tiến trình có mức độ ưu tiên.
- id: Tỷ lệ CPU ở trạng thái không hoạt động.
- wa: Tỷ lệ phần trăm CPU đang đợi I/O.
- hi: Tỷ lệ phần trăm CPU dành thời gian ngắt phần cứng.
- si: Tỷ lệ phần trăm CPU dành thời gian ngắt phần mềm.
- st: Tỷ lệ phần trăm CPU bị "đánh cắp" bởi máy ảo (stolen).
