# Hướng dẫn kiểm tra các hệ thống bằng n8n
### Workflow
```
{ "name": "My workflow 4", "nodes": [ { "parameters": { "rule": { "interval": [ { "field": "minutes" } ] } }, "id": "55623997-54df-4ea2-952f-fa5fef5c8e74", "name": "Trigger Check System", "type": "n8n-nodes-base.scheduleTrigger", "position": [ -400, -100 ], "typeVersion": 1.2 }, { "parameters": { "jsCode": "const data = $json;\n\n// 1. Các service cần check \"active/inactive\"\nlet msg = '⚠️ *Cảnh báo:*\\n';\nlet alert = false;\n\n// 🔧 Tùy chỉnh riêng từng loại tài nguyên\nconst diskUsage = parseFloat(data[\"Disk Status\"]);\nif (!isNaN(diskUsage)) {\n  if (diskUsage >= 90) {\n    alert = true;\n    msg += `- 🔴 Dung lượng đĩa đang rất cao: ${diskUsage} % \\n`;\n  } else if (diskUsage > 80) {\n    alert = true;\n    msg += `- 🟡 Dung lượng đĩa đang khá cao: ${diskUsage} % \\n`;\n  }\n}\n\n// 👉 Tùy chỉnh thêm nếu muốn (ví dụ CPU)\nconst cpuUsage = parseFloat(data[\"CPU Status\"]);\nif (!isNaN(cpuUsage) && cpuUsage >= 90) {\n  alert = true;\n  msg += `- 🔴 CPU đang quá tải: ${cpuUsage} % \\n`;\n}\n\n// 👉 RAM\nconst ramUsage = parseFloat(data[\"RAM\"]);\nif (!isNaN(ramUsage) && ramUsage >= 90) {\n  alert = true;\n  msg += `- 🔴 RAM đang quá tải: ${ramUsage} % \\n`;\n}\n\n// 👉 Inode\nconst inodeFree = parseFloat(data[\"Inode\"]);\nif (!isNaN(inodeFree) && inodeFree > 2) {\n  alert = true;\n  msg += `- 🔴 Inode còn rất thấp, hiện đang sử dụng: ${inodeFree} % \\n`;\n}\n\n// 👉 Load Average\nconst loadAvg = parseFloat(data[\"Average\"]);\nif (!isNaN(loadAvg) && loadAvg > 1) {\n  alert = true;\n  msg += `- 🔴 Load Average trong 5 phút vừa qua đang cao: ${loadAvg} \\n`;\n}\n/**const services = [\n  \"Nginx Enable\",\n  \"Nginx Active\",\n  \"MySQL Enable\",\n  \"MySQL Active\",\n  \"PHP-FPM Enable\",\n  \"PHP-FPM Active\"\n];**/\nconst services = [\"Nginx\", \"MySQL\",\"PHP-FPM\"]\n// Kiểm tra trạng thái dịch vụ\nfor (const service of services) {\n  const isInstalled = (data[`${service} Installed`] || \"\").toLowerCase().trim();\n  if (isInstalled === \"not-found\") {\n    alert = true;\n    msg += `- ❌ ${service.trim()} *chưa được cài đặt*\\n`;\n    continue;\n  }\n\n  const isActive = (data[`${service} Active`] || \"\").toLowerCase().trim();\n  alert = true;\n  const activeText = (isActive === \"active\")\n    ? \"*hiện tại đang active* ✅\"\n    : \"*hiện tại đang inactive* ❌\";\n  msg += `- 🔧 ${service.trim()} *đã được cài đặt* và ${activeText}\\n`;\n}\n\nif (!alert) {\n  return []; // Không có cảnh báo → không gửi tiếp\n}\n\nreturn [\n  {\n    json: {\n      message: msg\n    }\n  }\n];" }, "type": "n8n-nodes-base.code", "typeVersion": 2, "position": [ 220, -100 ], "id": "6718d5f2-d778-4b33-b911-6b7703a47fdc", "name": "Code" }, { "parameters": { "authentication": "webhook", "content": "={{$json[\"message\"]}}", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ 420, -100 ], "id": "20271544-42ce-44c6-86d7-031d94c23060", "name": "Alert Discord", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } }, { "parameters": { "assignments": { "assignments": [ { "id": "49cf7bfb-eb70-454c-811b-6a6f9ecb462b", "name": "CPU Status", "value": "={{ $json.stdout.split('\\n')[0].trim()}}", "type": "string" }, { "id": "4a388c36-5a41-48ef-b998-38734827f56e", "name": "Inode", "value": "={{ $json.stdout.split('\\n')[1].trim()}}", "type": "string" }, { "id": "d6d59af7-157a-481a-ace3-5361b17f390f", "name": "Disk Status", "value": "={{ $json.stdout.split('\\n')[2].trim()}}", "type": "string" }, { "id": "392ff3e0-b7b6-48dd-b759-49701b895a4e", "name": "RAM", "value": "={{ $json.stdout.split('\\n')[3].trim()}}", "type": "string" }, { "id": "3a928756-860c-4e77-971b-75abee91d933", "name": "Average", "value": "={{ $json.stdout.split('\\n')[4].trim()}}", "type": "string" }, { "id": "93485443-3858-4868-a032-b9dc1a4be319", "name": "Nginx Installed", "value": "={{ $json.stdout.split('\\n')[5].trim()}}", "type": "string" }, { "id": "96e03619-fa91-4025-9628-63a3be3c19c7", "name": "Nginx Active", "value": "={{ $json.stdout.split('\\n')[6].trim()}}", "type": "string" }, { "id": "693bb184-804f-4ffe-8337-cc66ccac1e51", "name": "MySQL Installed", "value": "={{ $json.stdout.split('\\n')[7].trim()}}", "type": "string" }, { "id": "21d1a1bd-0de9-496a-bfdb-74bdfa2bc20b", "name": "MySQL Active", "value": "={{ $json.stdout.split('\\n')[8].trim()}}", "type": "string" }, { "id": "e9ce8211-50dd-4400-a058-5fd75266ff38", "name": "PHP-FPM Installed", "value": "={{ $json.stdout.split('\\n')[9].trim()}}", "type": "string" }, { "id": "233ac6c0-f06e-429b-985b-e0cfa329513d", "name": "PHP-FPM Active", "value": "={{ $json.stdout.split('\\n')[10].trim()}}", "type": "string" } ] }, "options": {} }, "type": "n8n-nodes-base.set", "typeVersion": 3.4, "position": [ 40, -100 ], "id": "990ed797-1306-4b93-9858-bd5c5077dd90", "name": "Edit Result Check" }, { "parameters": { "command": "#!/bin/bash\nCHECK_ONE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_ONE\nsleep 5s\nCHECK_TWO=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_TWO\nsleep 5s\nCHECK_THREE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_THREE\nsleep 5s\nCHECK_FOUR=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FOUR\nsleep 5s\nCHECK_FIVE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FIVE\nif (( $(echo \"$CHECK_ONE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_TWO > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_THREE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FOUR > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FIVE > 90\" | bc -l) )); then\n\n    echo $CHECK_FIVE\nelse\n    echo 0\nfi\n\ndf -ih | awk '$NF==\"/\"{printf \"%.2f\\n\", $5}'\n\ndf -h | awk '$NF==\"/\"{printf \"%.2f\\n\", $5}'\nfree | awk '/Mem:/ {printf \"%.2f\\n\", (1 - $7/$2) * 100}'\n\n# Lấy số core CPU\ncores=$(nproc)\n# Lấy load average 5 phút\nload1=$( top -bn1 | grep \"load average\" | awk -F'load average: ' '{print $2}' | cut -d',' -f2)\n\n# So sánh\nthreshold=$(echo \"$cores * 1.0\" | bc)  # cho phép 100% CPU load\n# In thông báo\nif (( $(echo \"$load1 > $threshold\" | bc -l) )); then\n    echo $load1\nelse\n    echo 0\nfi\nnginx_service=$(systemctl list-unit-files | awk '/nginx/ {print $1; found=1} END {if (!found) print \"not-found\"}')&& echo $nginx_service\ncheck_nginx_active=$(systemctl is-active nginx | awk '{print $1}')&& echo $check_nginx_active\nmysql_service=$(systemctl list-unit-files | grep mysql |  awk '/mysql/ {print $1; found=1} END {if (!found) print \"not-found\"}')&& echo $mysql_service\ncheck_mysql_active=$(systemctl is-active mysql | awk '{print $1}')&& echo $check_mysql_active\nphp81_fpm_service=$(systemctl list-unit-files| awk '/php8.1-fpm/ {print $1; found=1} END {if (!found) print \"not-found\"}') && echo $php81_fpm_service\ncheck_php_fpm_active=$(systemctl is-active php8.1-fpm | awk '{print $1}') && echo $check_php_fpm_active\n\n\n\n\n\n\n" }, "id": "1ca88f8c-f60c-4ca0-bbc1-9e78087bfe5a", "name": "Check System", "type": "n8n-nodes-base.ssh", "position": [ -160, -100 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } } ], "pinData": {}, "connections": { "Trigger Check System": { "main": [ [ { "node": "Check System", "type": "main", "index": 0 } ] ] }, "Code": { "main": [ [ { "node": "Alert Discord", "type": "main", "index": 0 } ] ] }, "Edit Result Check": { "main": [ [ { "node": "Code", "type": "main", "index": 0 } ] ] }, "Check System": { "main": [ [ { "node": "Edit Result Check", "type": "main", "index": 0 } ] ] } }, "active": false, "settings": { "executionOrder": "v1" }, "versionId": "be3df220-b0c0-4045-9b0d-a774b9f69adf", "meta": { "instanceId": "3ccf4ecd0404b7fa314448bdbf1ad0285178274f152b93d738dc0c826690b592" }, "id": "Sgi9fhD42sj3Ol7v", "tags": [] }
```
### Giới thiệu 
Workflow này được xây dựng nhằm mục đích giám sát tình trạng hệ thống máy chủ Linux theo thời gian thực. Hệ thống sẽ định kỳ kiểm tra các chỉ số quan trọng như:

- Hiệu suất CPU, mức sử dụng RAM, Disk và Inode

- Load Average để đánh giá mức độ tải hệ thống

Trạng thái hoạt động của các dịch vụ quan trọng như:

- nginx

- php-fpm hoặc php

- mysql hoặc mariadb

Khi phát hiện bất kỳ chỉ số nào vượt quá ngưỡng cảnh báo, workflow sẽ gửi thông báo tức thì về Discord thông qua webhook, giúp quản trị viên chủ động phát hiện sớm và xử lý sự cố kịp thời
### Các mức cảnh báo như sau
- Gửi cảnh báo khi CPU server vượt 90% trong 5 phút.
- Gửi cảnh báo khi RAM server còn trống dưới 10%.
- Gửi cảnh báo khi dung lượng ổ cứng còn trống dưới 20% (cảnh báo) dưới 10% (cảnh báo khẩn cấp)
- Gửi cảnh báo  inode usage > 90%. 
- Gửi cảnh báo khi server load average tăng cao bất thường.
- Gửi cảnh báo khi một dịch vụ quan trọng (Nginx, MySQL, PHP-FPM) bị dừng.
### Các bước triển khai
1. Đầu tiên các bản hay copy đoạn code ở trên sau đó tạo workflow mới trong n8n rồi paste vào nhé
![image](https://github.com/user-attachments/assets/7804ce04-3ab5-4d26-bda0-626b3b09c86b)

2. Tôi sẽ giải thích từng node trong này nhé  
a. **Node Trigger Check System**  
Ở node này sẽ là thời gian mà bạn chạy workflow giám xác hệ thống. Có thể chạy 2 phút một lần, 5 phút một lần, hay 10 phút một lần,...Tuy nhiên tôi khuyên bạn không nên để thời gian quá xa vì hệ thống có thể gặp vấn đề mà bạn không thể phát hiện kịp thời
![image](https://github.com/user-attachments/assets/1bb569e8-766b-4431-909f-ac02c706b8c9)

b. **Check System**  
Node này dùng để gửi các Command đến máy chủ được giám sát để lấy thông tin CPU, RAM, DISK, Inode, Load Average và các dịch vụ như Nginx MySQL, PHP-FPM    
Nhưng trước tiên bạn phải thêm Thông tin xác thực vào nhé

![image](https://github.com/user-attachments/assets/2ef8eaa2-4526-413d-984e-8b5555e3a29e)

Sẽ có 2 Option để bạn xác thực với máy chủ: Password và Private Key
Bạn điền các thông tin:
- Host: Là địa chỉ IP của máy chủ của bạn
- Port kết nối: 22 (Nếu bạn thay đổi trên VPS cũng cần phải thay đổi ở đây nhé)
- Username: Điền tên user truy cập của bạn
- Password: Nhập password đăng nhập của user ở trên

![image](https://github.com/user-attachments/assets/bbe888e3-27bd-4f1f-866f-7cfacda2396c)

Trong trường hợp bạn dùng Private Key, bạn cũng nhập thông tin như:
- Host
- Port
- Username
- Private key: Là Private key trong key pair mà bạn đã tạo ra
- Passphrase: Bạn điền Passphrase của key (nếu có)
![image](https://github.com/user-attachments/assets/0873014b-3901-41cd-8969-5cb34ab0254c)
Tiếp theo tôi sẽ giải tích đoạn command được gửi đi trong node này
```
#!/bin/bash
CHECK_ONE=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_ONE
sleep 70s
CHECK_TWO=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_TWO
sleep 70s
CHECK_THREE=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_THREE
sleep 70s
CHECK_FOUR=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_FOUR
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

df -ih | awk '$NF=="/"{printf "%.2f\n", $5}'

df -h | awk '$NF=="/"{printf "%.2f\n", $5}'
free | awk '/Mem:/ {printf "%.2f\n", (1 - $7/$2) * 100}'

# Lấy số core CPU
cores=$(nproc)
# Lấy load average 5 phút
load1=$(top -bn1 | awk '/load average/ {print $13}')
# So sánh
threshold=$(echo "$cores * 1.0" | bc)  # cho phép 100% CPU load
# In thông báo
if (( $(echo "$load1 > $threshold" | bc -l) )); then
    echo $load1
else
    echo 0
fi
nginx_service=$(systemctl list-unit-files | awk '/nginx/ {print $1; found=1} END {if (!found) print "not-found"}')&& echo $nginx_service
check_nginx_active=$(systemctl is-active nginx | awk '{print $1}')&& echo $check_nginx_active
mysql_service=$(systemctl list-unit-files | grep mysql |  awk '/mysql/ {print $1; found=1} END {if (!found) print "not-found"}')&& echo $mysql_service
check_mysql_active=$(systemctl is-active mysql | awk '{print $1}')&& echo $check_mysql_active
php81_fpm_service=$(systemctl list-unit-files| awk '/php8.1-fpm/ {print $1; found=1} END {if (!found) print "not-found"}') && echo $php81_fpm_service
check_php_fpm_active=$(systemctl is-active php8.1-fpm | awk '{print $1}') && echo $check_php_fpm_active
```
**Kiểm tra CPU**
```
CHECK_ONE=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_ONE
sleep 70s
CHECK_TWO=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_TWO
sleep 70s
CHECK_THREE=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_THREE
sleep 70s
CHECK_FOUR=$(top -bn 1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
#echo $CHECK_FOUR
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
- Ta tiến hành kiểm tra CPU trong vòng 5 phút và lưu lại bằng 5 biến **CHECK_ONE**, **CHECK_TWO**,.... sau đó ta so sánh nếu cả 5 lần CPU đều cao hơn 90% nghĩa là trong 5 phút vừa qua CPU lúc nào cũng cao hơn 90%  và in ra kết quả

**Kiểm tra Inode usage**
```
df -ih | awk '$NF=="/"{printf "%.2f\n", $5}'
```
- df -ih: xem inode usage theo định dạng human-readable
- Lọc phân vùng gốc /
- In phần trăm inode đang dùng

**Kiểm tra Disk usage**
```
df -h | awk '$NF=="/"{printf "%.2f\n", $5}'
```
Tuơng tự như kiểm tra Inode nhưng lần này sẽ kiểm tra đĩa  

**Kiểm tra RAM usage**
```
free | awk '/Mem:/ {printf "%.2f\n", (1 - $7/$2) * 100}'
```
- free: kiểm tra bộ nhớ
- $2: tổng RAM
- $7: RAM còn trống (available)
- Tính RAM đã dùng = 100 - available/tổng

**Kiểm tra Load Average**
```
cores=$(nproc)
load1=$( top -bn1 | grep "load average" | awk -F'load average: ' '{print $2}' | cut -d',' -f2)
threshold=$(echo "$cores * 1.0" | bc)
```
- nproc: lấy số core CPU
- load1: lấy giá trị load trung bình trong 1 phút
- Nếu load1 > số core, nghĩa là CPU đang bị quá tải  
**Kiểm tra trạng thái dịch vụ**
  
Nếu dịch vụ đó đã được cài đặt thì sẽ lấy giá trị là tên dịch vụ đó nếu chưa thì sẽ lấy giá trị là not found và sau đó kiểm tra dịch vụ đó có active hay không
```
nginx_service=$(systemctl list-unit-files | awk '/nginx/ {print $1; found=1} END {if (!found) print "not-found"}')&& echo $nginx_service
check_nginx_active=$(systemctl is-active nginx | awk '{print $1}')&& echo $check_nginx_active
mysql_service=$(systemctl list-unit-files | grep mysql |  awk '/mysql/ {print $1; found=1} END {if (!found) print "not-found"}')&& echo $mysql_service
check_mysql_active=$(systemctl is-active mysql | awk '{print $1}')&& echo $check_mysql_active
php81_fpm_service=$(systemctl list-unit-files| awk '/php8.1-fpm/ {print $1; found=1} END {if (!found) print "not-found"}') && echo $php81_fpm_service
check_php_fpm_active=$(systemctl is-active php8.1-fpm | awk '{print $1}') && echo $check_php_fpm_active
```
Tương tự như MySQL, PHP-FPM  
c. **Node Edit Result Check**  
Sau khi Node **Check System** thực thi thành công. Output sẽ trả về 1 item kiếu **string** nên ta cần phải tách ra và so sánh kết quả với điều kiện. Như sau:  
![image](https://github.com/user-attachments/assets/aaeb1b47-f8b4-4896-873d-7bb74ee57c76)


Node này sẽ chia các Output ra thành mảng sau đó lấy lần lượt kết quả các phần tử, dùng hàm trim() để xóa các khoảng trắng trước, sau và gán vào bằng một tên như **CPU Status**, **Inode**, **Disk  Status** ,... *Lưu ý thứ tự sẽ phải sắp xếp đúng với Node trước nhé nếu không sẽ xãy ra hiện tượng lấy kết quả của CPU so sánh điều kiện của RAM*  

![image](https://github.com/user-attachments/assets/abd97ace-cd12-4df9-947b-9deb30f02162)


d. **Node Code**  
Sau khi đã tách kết quả ta đem đi so sánh bằng đoạn code sau  
![image](https://github.com/user-attachments/assets/97f982a0-425a-4f1f-a5b0-d0a82fde3625)

```
const data = $json;

// 1. Các service cần check "active/inactive"
let msg = '⚠️ *Cảnh báo:*\n';
let alert = false;

// 🔧 Tùy chỉnh riêng từng loại tài nguyên
const diskUsage = parseFloat(data["Disk Status"]);
if (!isNaN(diskUsage)) {
  if (diskUsage >= 90) {
    alert = true;
    msg += `- 🔴 Dung lượng đĩa đang rất cao: ${diskUsage} % \n`;
  } else if (diskUsage > 80) {
    alert = true;
    msg += `- 🟡 Dung lượng đĩa đang khá cao: ${diskUsage} % \n`;
  }
}

// 👉 Tùy chỉnh thêm nếu muốn (ví dụ CPU)
const cpuUsage = parseFloat(data["CPU Status"]);
if (!isNaN(cpuUsage) && cpuUsage >= 90) {
  alert = true;
  msg += `- 🔴 CPU đang quá tải: ${cpuUsage} % \n`;
}

// 👉 RAM
const ramUsage = parseFloat(data["RAM"]);
if (!isNaN(ramUsage) && ramUsage >= 90) {
  alert = true;
  msg += `- 🔴 RAM đang quá tải: ${ramUsage} % \n`;
}

// 👉 Inode
const inodeFree = parseFloat(data["Inode"]);
if (!isNaN(inodeFree) && inodeFree > 2) {
  alert = true;
  msg += `- 🔴 Inode còn rất thấp, hiện đang sử dụng: ${inodeFree} % \n`;
}

// 👉 Load Average
const loadAvg = parseFloat(data["Average"]);
if (!isNaN(loadAvg) && loadAvg > 1) {
  alert = true;
  msg += `- 🔴 Load Average trong 5 phút vừa qua đang cao: ${loadAvg} \n`;
}
/**const services = [
  "Nginx Enable",
  "Nginx Active",
  "MySQL Enable",
  "MySQL Active",
  "PHP-FPM Enable",
  "PHP-FPM Active"
];**/
const services = ["Nginx", "MySQL","PHP-FPM"]
// Kiểm tra trạng thái dịch vụ
for (const service of services) {
  const isEnabled = (data[`${service} Enable`] || "").toLowerCase().trim();
  const isActive = (data[`${service} Active`] || "").toLowerCase().trim();

  alert = true; // luôn bật vì bạn muốn báo trong mọi trường hợp

  const enableText = (isEnabled === "enabled")
    ? "*đã được bật khi reboot*"
    : "*chưa tự động bật khi reboot*";

  const activeText = (isActive === "active")
    ? "và hiện tại đang *active* ✅"
    : "và hiện tại đang *inactive* ❌";

  msg += `-  ${service.trim()} ${enableText} ${activeText}\n`;
}

if (!alert) {
  return []; // Không có cảnh báo → không gửi tiếp
}

return [
  {
    json: {
      message: msg
    }
  }
];
```
e. **Node Alert Discord**  
Node này sẽ đẫy thông báo về Discord, ở đây tôi dùng webhook. Bạn có thể xem doc của discord về webhook trên discord nhé: https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks  
Ở **Message** bạn lấy Output của **Node Code** trước đó

![image](https://github.com/user-attachments/assets/707d0354-26d8-43c4-9e29-334f690b459b)

### Kết quả

![image](https://github.com/user-attachments/assets/a61cf96f-e836-4050-b4e7-ec06b28e0e67)

























