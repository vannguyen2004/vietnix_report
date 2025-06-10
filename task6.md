# Xây Dựng workflow
### Yêu cầu:
- Gửi cảnh báo khi CPU server vượt 90% trong 5 phút.
- Gửi cảnh báo khi RAM server còn trống dưới 10%.
- Gửi cảnh báo khi dung lượng ổ cứng còn trống dưới 15%.
- Gửi cảnh báo  inode usage > 90%. 
- Gửi cảnh báo khi server load average tăng cao bất thường.
- Gửi cảnh báo khi một dịch vụ quan trọng (Nginx, MySQL, PHP-FPM) bị dừng.
- Tất cả các Alert sẽ được gửi qua discord

### Logic thực hiện

Sử dụng gửi lệnh Command Line đến VPS để lấy các giá trị như trang thái dịch vụ (nginx, mysql, php-fpm), thông tin RAM, DISK, CPU, Inode, Load Average. Sau đó ta so sánh với các giá trị cho trước nếu vượt qua sẽ gửi thông tin đến Discord.  
Trong Workflow hiện tại đang chia ra thành 2 workflow nhỏ hơn là:
- Một workflow check dịch vụ đang chạy với thời gian 2 phút 1 lần.
- Một workflow sẽ check các thông tin của hệ thống như CPU, RAM, DISK, Load Average, Inode sẽ được kiểm tra 5 phút 1 lần
### Một số node được sử dụng trong bài LAB
- Trigger: **On a Schedule** sử dung để chạy workflow tự động theo thời gian hoặc chu kỳ.
- Node **SSH** với Action **Execute a command** để gửi command line thông qua SSH (có thể dùng key hoặc password)
- Node Edit Fields dùng để lọc chỉnh sửa các character sau kết quả trả về từ SSH
- Node điều kiện (IF) dùng để so sánh các thông tin của VPS với các thông số mà ta thiết lập sẵn trước đó nếu khớp sẽ gửi thông tin đến Discord
- Node Discord dùng để gửi message đến discord thông qua Webhook
### Workflow check các dịch vụ của hệ thống

![7](https://github.com/user-attachments/assets/4988a320-0039-4002-ade3-00c912f5704a)

- Trigger: Cho chạy mỗi 2 phút 1 lần

![1](https://github.com/user-attachments/assets/32d59c39-42b7-4984-9918-f304232f048e)

- SSH Command: ta gửi đoạn command sau
```
#!/bin/bash

check_nginx=$(systemctl is-active nginx | awk "{print $1}")
echo $check_nginx
check_mysql=$(systemctl is-active mysql | awk "{print $1}")
echo $check_mysql
check_php_fpm=$(systemctl is-active php-fpm | awk "{print $1}")
echo $check_php_fpm   
```

Mục đích để lấy trạng thái các dịch vụ xem là **inactive** hay **active**

![3](https://github.com/user-attachments/assets/fcf04828-3b68-4ee4-bb9a-e60dbd9a2777)

- Tuy nhiên output ra là một chuỗi phân cách bởi ký tự xuống dòng (\n) nên ta dùng node **edit fields** để tách lấy các giá trị

![4](https://github.com/user-attachments/assets/b5d08ae7-f8b8-4aa3-91f2-b3727639717b)

 Ta đặt tên cho từng dịch vụ để dễ phân biệt Nginx Status, MySQL Status, PHP-FPM Status
 Về phần giá trị ta lấy stdout ở node SSH Command dùng hàm split() để chia chuổi thành mảng và lấy phần tử đầu tiên bắt đầu bằng 0 sau đó để chắc chắn các giá trị không bị dính khoảng trắng ta dùng hàm trim() để loại bỏ tất cả dấu cách ở trước và sau. Tương tư với MySQL Status và PHP-FPM Status. Cuối cùng ta được một Array chứa Object bên trong
- Ở Node điều kiện ta lấy giá trị của **Nginx Status** trước đó so sánh nếu **inactive** thì sẽ là **true** ngược lại sẽ là **false** tương tự như ở các điều kiện của MySQL và PHP-FPM
![5](https://github.com/user-attachments/assets/28d048ce-88a4-48da-b8f6-41c304b60795)
- Ở Node Discord ta gửi thông điệp với Trạng thái dịch vụ và thời gian
![6](https://github.com/user-attachments/assets/f0c87c9b-b5a6-416d-8f93-d6768dc92c24)

### Workflow check trang thái của hệ thống
![8](https://github.com/user-attachments/assets/47a0f11f-ff10-4283-bc42-33f2a290f111)

- Trigger: Cho chạy mỗi 5 phút 1 lần
- Sau đó ta gửi các command để lấy các thông tin của hệ thống để so sánh
##### Check Inode Usage
```
 df -ih | awk '$NF=="/"{printf "%.2f", $5}'
```
  Hiện thị inode theo dạng con người có thể đọc và lấy dòng có ký tự cuối cùng là / lấy cột thứ 5 của dòng đó (là cột % Usage) sau đó in ra giá trị  của inode đang sử dụng

#####  Check RAM  
```
free | awk '/Mem:/ {printf "%.2f", (1 - $7/$2) * 100}'
```

Lấy giá trị Memory đang sử dụng bằng cách lấy 1 - (avaiable/ total) * 100 phần trăm sau đó làm tròn đến chữ số thập phân số 2

##### Check Disk
```
df -h | awk '$NF=="/"{printf "%.2f", $5}'
```
Tương tự ta lấy cột Used (cột số 5) ở dòng có kí tự cuối cùng là /

##### Check Average 
Nếu số node lớn hơn số core thì sẽ được tính là tải cao
```
#!/bin/bash

# Lấy số core CPU
cores=$(nproc)

# Lấy load average 1 phút
load1=$(awk '{print $2}' /proc/loadavg)

# So sánh
threshold=$(echo "$cores * 1.0" | bc)  # cho phép 100% CPU load

# In thông báo
if (( $(echo "$load1 > $threshold" | bc -l) )); then
    echo $load1
else
    echo 0
fi
```

##### Check CPU
Logic: Ở đây ta lấy CPU không hoạt động sau đó lấy 100 - số CPU không hoạt động sẽ ra CPU đang sử dụng. Ta chạy lệnh 5 lần lưu lại với 5 biến ở mỗi lần ta dùng lệnh sleep để giãn cách thời gian sau đó mỗi lệnh chạy trong > 1 phút chạy lệnh sleep trong 4 lần nếu cả 5 giá trị của biến đều lớn hơn 90 sẽ được tính là CPU vượt quá 90%. Ngược lại nếu 1 trong 5 lần không vượt quá 90  nghĩa là trong vòng 5 phút load CPU không luôn luôn quá 90 và sẽ không gửi message  
Note Ở các lệnh echo bị command
```
#!/bin/bash
CHECK_ONE=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
sleep 70s
CHECK_TWO=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
sleep 70s
CHECK_THREE=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
sleep 70s
CHECK_FOUR=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
sleep 70s
CHECK_FIVE=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_FIVE
if (( $(echo "$CHECK_ONE > 90" | bc -l) )) && \
   (( $(echo "$CHECK_TWO > 90" | bc -l) )) && \
   (( $(echo "$CHECK_THREE > 90" | bc -l) )) && \
   (( $(echo "$CHECK_FOUR > 90" | bc -l) )) && \
   (( $(echo "$CHECK_FIVE > 90" | bc -l) )); then
    echo $CHECK_FIVE
else
    echo 0
fi

```
Ở các node Điều kiện IF và Discord sẽ là kiểm tra theo điều kiện cho trước mà nếu match thì sẽ gửi message. Việc N8N và Discord sẽ giao tiếp qua webhook của Discord

# Kiểm tra 
### Kiểm tra các service của hệ thống
Ta bật tất cả các Service cần kiểm tra sau đó từ từ tắt đó đi nhé
![9](https://github.com/user-attachments/assets/12d92368-25f1-4035-bee6-832fd11bb73e)

![10](https://github.com/user-attachments/assets/2322edc6-c80f-475b-9c78-a572ed336236)

![12](https://github.com/user-attachments/assets/ba1c8d75-9f2d-48f0-8c05-6ce88049f4f9)
![11](https://github.com/user-attachments/assets/27dc3c09-413a-463e-aecc-6d41fd43496c)

![13](https://github.com/user-attachments/assets/2976b128-65a2-4c0f-9b4f-0147c60576b6)
![14](https://github.com/user-attachments/assets/0bd793e6-5331-4e80-bef7-fb78af1329ad)
![14](https://github.com/user-attachments/assets/ca8a1671-09b4-4952-9610-bf476d5196a4)

### Kiểm tra resource của hệ thống

Check disk
![15](https://github.com/user-attachments/assets/bbe2fba0-49f9-4d25-b78d-bcf95d5921ec)

















  
