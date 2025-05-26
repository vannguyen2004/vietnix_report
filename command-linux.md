### Linux Command 
### SSH Command 
Kết nối sử dụng mật khẩu:
```ssh user_name@ip_or_domain```

Kết nối sử dụng khóa riêng:
```ssh -i /path/private_key username@ip_or_domain```

Kết nối sử dụng cổng tùy chỉnh:
```ssh -p PORT user_name@ip_or_domain```

### SCP
Sao chép một tệp tin duy nhất:
```scp /path/file username@remote_host:/path/to/remote/destination```

Sao chép một thư mục:
```scp -r /path/folder/ username@remote_host:/path/to/remote/destination```

### RSYNC
Đồng bộ một tệp tin:
```rsync -avzhe ssh root@x.x.x.x:/path/file.txt /path```

Đồng bộ một thư mục (thêm -r cho đệ quy):
```rsync -avzhe ssh -r root@x.x.x.x:/path/folder /path```

Lưu ý: Sử dụng các tùy chọn phù hợp cho đồng bộ gia tăng.


### Cat
Hiển thị nội dung tệp tin:
```cat file.txt```

Hiển thị với số dòng và lọc dòng cụ thể:
```cat -n hello.txt | grep n```

Ghi nhiều dòng vào tệp tin sử dụng EOF:
```
cat << EOF > abc.txt
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

### Cp
Sao chép một tệp tin:
```cp /path/file /path/destination/```

Sao chép một thư mục:
```cp -r /source /destination```

### Mv
Di chuyển tệp tin hoặc thư mục:
```mv /source /destination```

### Cut
Trích xuất ký tự cụ thể:
``` cut -c3 <<< "abcd"```

Trích xuất từ ký tự cụ thể trở đi:
```cut -c4- <<< "abcdxyz"```

Trích xuất phạm vi ký tự:
```cut -c1-3 <<< "abcdxyz"```

### Chmod
Đặt quyền (chủ sở hữu: đầy đủ, nhóm: đọc/ghi, người khác: đọc):
```chmod 764 file.txt```

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
```sort -k filename```

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
```dig vietnix.vn NS @ip_resolver```


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
mount /dev/sdb1 /mnt/test

Tháo đĩa:
umount /mnt/test

### Df
Kiểm tra dung lượng đĩa:
```df -hT```

Lưu ý: Phân vùng / là phân vùng gốc của hệ thống.


### Symboliaux```

Kết thúc tiến trình bằng PID:
```kill PID```

### Top
Theo dõi tài nguyên hệ thống:
```top```

Các chỉ số chính: tải trung bình, us (người dùng), sy (hệ thống), ni (nice), id (nhàn rỗi), wa (chờ), hi (ngắt phần cứng), si (ngắt phần mềm), st (thời gian bị đánh cắp), zombie, và tiến trình ngủ.

Free
Kiểm tra dung lượng bộ nhớ:
free -h
