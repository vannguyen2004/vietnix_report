# Hướng dẫn kiểm tra các hệ thống bằng n8n
### Workflow
```
{ "name": "Check System", "nodes": [ { "parameters": { "command": "free | awk '/Mem:/ {printf \"%.2f\", (1 - $7/$2) * 100}'" }, "id": "c0d1b90b-6803-4f6d-a808-11b542604ac3", "name": "Check RAM usage", "type": "n8n-nodes-base.ssh", "position": [ -400, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "df -h | awk '$NF==\"/\"{printf \"%.2f\", $5}'" }, "id": "6bfa0a1e-da66-48c1-8698-efe3d5c068a0", "name": "Check Disk usage", "type": "n8n-nodes-base.ssh", "position": [ -180, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "#!/bin/bash\nCHECK_ONE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_ONE\nsleep 70s\nCHECK_TWO=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_TWO\nsleep 70s\nCHECK_THREE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_THREE\nsleep 70s\nCHECK_FOUR=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FOUR\nsleep 70s\nCHECK_FIVE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FIVE\nif (( $(echo \"$CHECK_ONE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_TWO > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_THREE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FOUR > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FIVE > 90\" | bc -l) )); then\n\n    echo $CHECK_FIVE\nelse\n    echo 0\nfi\n\n\n" }, "id": "817771fc-d28f-4abd-b9d7-8ec228e4f7ed", "name": "Check CPU usage", "type": "n8n-nodes-base.ssh", "position": [ -840, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "#!/bin/bash\n\ncheck_nginx=$(systemctl is-active nginx | awk \"{print $1}\")\necho $check_nginx\ncheck_mysql=$(systemctl is-active mysql | awk \"{print $1}\")\necho $check_mysql\ncheck_php_fpm=$(systemctl is-active php8.1-fpm | awk \"{print $1}\")\necho $check_php_fpm\n" }, "id": "25e36b7a-4f6d-40e1-852f-de9207d5dfba", "name": "Check Service", "type": "n8n-nodes-base.ssh", "position": [ 240, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "df -ih | awk '$NF==\"/\"{printf \"%.2f\", $5}'" }, "type": "n8n-nodes-base.ssh", "typeVersion": 1, "position": [ -640, -240 ], "id": "777ddd34-cd9a-41ae-a85e-c1600ebdd84e", "name": "Check inode Usage", "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "#!/bin/bash\n\n# Lấy số core CPU\ncores=$(nproc)\n\n# Lấy load average 1 phút\nload1=$(awk '{print $2}' /proc/loadavg)\n\n# So sánh\nthreshold=$(echo \"$cores * 1.0\" | bc)  # cho phép 100% CPU load\n\n# In thông báo\nif (( $(echo \"$load1 > $threshold\" | bc -l) )); then\n    echo $load1\nelse\n    echo 0\nfi\n" }, "id": "c6b6558d-5cf6-4989-8ccc-0bee2e40c79e", "name": "Check Average", "type": "n8n-nodes-base.ssh", "position": [ 20, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "rule": { "interval": [ { "field": "minutes" } ] } }, "id": "3ee87af8-f164-4e60-9d42-eb65a53ce0f3", "name": "Trigger Check System", "type": "n8n-nodes-base.scheduleTrigger", "position": [ -1080, -240 ], "typeVersion": 1.2 }, { "parameters": { "assignments": { "assignments": [ { "id": "49cf7bfb-eb70-454c-811b-6a6f9ecb462b", "name": "Nginx Status ", "value": "={{ $json.ServiceStatus.split('\\n')[0].trim() }}", "type": "string" }, { "id": "4a388c36-5a41-48ef-b998-38734827f56e", "name": "MySQL Status", "value": "={{ $json.ServiceStatus.split('\\n')[1].trim() }}", "type": "string" }, { "id": "d6d59af7-157a-481a-ace3-5361b17f390f", "name": "PHP_FPM", "value": "={{ $json.ServiceStatus.split('\\n')[2].trim() }}", "type": "string" }, { "id": "392ff3e0-b7b6-48dd-b759-49701b895a4e", "name": "CPU Status", "value": "={{ $json.CPU }}", "type": "string" }, { "id": "3a928756-860c-4e77-971b-75abee91d933", "name": "Disk Status", "value": "={{ $json.Disk }}", "type": "string" }, { "id": "93485443-3858-4868-a032-b9dc1a4be319", "name": "Average", "value": "={{ $('Check Average').item.json.stdout }}", "type": "string" }, { "id": "96e03619-fa91-4025-9628-63a3be3c19c7", "name": "Inode", "value": "={{ $json.Inode }}", "type": "string" }, { "id": "693bb184-804f-4ffe-8337-cc66ccac1e51", "name": "RAM", "value": "={{ $json.RAM }}", "type": "string" } ] }, "options": {} }, "type": "n8n-nodes-base.set", "typeVersion": 3.4, "position": [ -500, 80 ], "id": "cd6b41c9-6a0b-44ca-8100-55547646ab52", "name": "Edit Result Check Service" }, { "parameters": { "mode": "combineBySql", "numberInputs": 6, "query": "SELECT\n  input1.stdout AS CPU,\n  input2.stdout AS Disk,\n  input3.stdout AS RAM,\n  input4.stdout AS LoadAverage,\n  input5.stdout AS Inode,\n  input6.stdout AS ServiceStatus\nFROM input1\nLEFT JOIN input2 ON true\nLEFT JOIN input3 ON true\nLEFT JOIN input4 ON true\nLEFT JOIN input5 ON true\nLEFT JOIN input6 ON true" }, "id": "abfcd5b9-2502-47a3-a19d-c58d5db9d519", "name": "Merge check results", "type": "n8n-nodes-base.merge", "position": [ -780, 20 ], "typeVersion": 3 }, { "parameters": { "jsCode": "const data = $json;\n\n// 1. Các service cần check \"active/inactive\"\nconst services = [\n  \"Nginx Status \",\n  \"MySQL Status\",\n  \"PHP_FPM\"\n];\n\nlet msg = '⚠️ *Cảnh báo:*\\n';\nlet alert = false;\n\n// 🔧 Tùy chỉnh riêng từng loại tài nguyên\nconst diskUsage = parseFloat(data[\"Disk Status\"]);\nif (!isNaN(diskUsage)) {\n  if (diskUsage >= 90) {\n    alert = true;\n    msg += `- 🔴 Dung lượng đĩa đang rất cao: ${diskUsage} % \\n`;\n  } else if (diskUsage > 80) {\n    alert = true;\n    msg += `- 🟡 Dung lượng đĩa đang khá cao: ${diskUsage} % \\n`;\n  }\n}\n\n// 👉 Tùy chỉnh thêm nếu muốn (ví dụ CPU)\nconst cpuUsage = parseFloat(data[\"CPU Status\"]);\nif (!isNaN(cpuUsage) && cpuUsage >= 90) {\n  alert = true;\n  msg += `- 🔴 CPU đang quá tải: ${cpuUsage} % \\n`;\n}\n\n// 👉 RAM\nconst ramUsage = parseFloat(data[\"RAM\"]);\nif (!isNaN(ramUsage) && ramUsage >= 90) {\n  alert = true;\n  msg += `- 🔴 RAM đang quá tải: ${ramUsage} % \\n`;\n}\n\n// 👉 Inode\nconst inodeFree = parseFloat(data[\"Inode\"]);\nif (!isNaN(inodeFree) && inodeFree > 2) {\n  alert = true;\n  msg += `- 🔴 Inode còn rất thấp, hiện đang sử dụng: ${inodeFree} % \\n`;\n}\n\n// 👉 Load Average\nconst loadAvg = parseFloat(data[\"Average\"]);\nif (!isNaN(loadAvg) && loadAvg > 1) {\n  alert = true;\n  msg += `- 🔴 Load Average trong 5 phút vừa qua đang cao: ${loadAvg} \\n`;\n}\n\n// Kiểm tra trạng thái dịch vụ\nfor (const service of services) {\n  const status = (data[service] || \"\").toLowerCase().trim();\n  if (status === \"inactive\") {\n    alert = true;\n    msg += `- 🔴 ${service.trim()} đang *inactive* ❌\\n`;\n  }\n}\n\nif (!alert) {\n  return []; // Không có cảnh báo → không gửi tiếp\n}\n\nreturn [\n  {\n    json: {\n      message: msg\n    }\n  }\n];\n" }, "type": "n8n-nodes-base.code", "typeVersion": 2, "position": [ -240, 80 ], "id": "3e9f5628-3099-458d-a71a-ec21217606ed", "name": "Code" }, { "parameters": { "authentication": "webhook", "content": "={{$json[\"message\"]}}", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ 40, 80 ], "id": "76c0b7b6-5979-48c5-819d-cded66609a38", "name": "Alert Discord", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } } ], "pinData": {}, "connections": { "Check CPU usage": { "main": [ [ { "node": "Check inode Usage", "type": "main", "index": 0 }, { "node": "Merge check results", "type": "main", "index": 0 } ] ] }, "Check RAM usage": { "main": [ [ { "node": "Merge check results", "type": "main", "index": 2 }, { "node": "Check Disk usage", "type": "main", "index": 0 } ] ] }, "Check Disk usage": { "main": [ [ { "node": "Check Average", "type": "main", "index": 0 }, { "node": "Merge check results", "type": "main", "index": 1 } ] ] }, "Check Service": { "main": [ [ { "node": "Merge check results", "type": "main", "index": 5 } ] ] }, "Check inode Usage": { "main": [ [ { "node": "Check RAM usage", "type": "main", "index": 0 }, { "node": "Merge check results", "type": "main", "index": 4 } ] ] }, "Check Average": { "main": [ [ { "node": "Check Service", "type": "main", "index": 0 }, { "node": "Merge check results", "type": "main", "index": 3 } ] ] }, "Trigger Check System": { "main": [ [ { "node": "Check CPU usage", "type": "main", "index": 0 } ] ] }, "Edit Result Check Service": { "main": [ [ { "node": "Code", "type": "main", "index": 0 } ] ] }, "Merge check results": { "main": [ [ { "node": "Edit Result Check Service", "type": "main", "index": 0 } ] ] }, "Code": { "main": [ [ { "node": "Alert Discord", "type": "main", "index": 0 } ] ] }, "Alert Discord": { "main": [ [] ] } }, "active": false, "settings": { "executionOrder": "v1" }, "versionId": "8f8a2568-9405-4a69-94e6-d7de6a136007", "meta": { "templateCredsSetupCompleted": true, "instanceId": "3ccf4ecd0404b7fa314448bdbf1ad0285178274f152b93d738dc0c826690b592" }, "id": "pFVS79o2vpqIpjR2", "tags": [] }
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
check_nginx=$(systemctl is-active nginx | awk "{print $1}")
echo $check_nginx
check_mysql=$(systemctl is-active mysql | awk "{print $1}")
echo $check_mysql
check_php_fpm=$(systemctl is-active php8.1-fpm | awk "{print $1}")
echo $check_php_fpm
```
**Kiểmtra CPU**
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
load1=$(awk '{print $2}' /proc/loadavg)
threshold=$(echo "$cores * 1.0" | bc)
```
- nproc: lấy số core CPU
- load1: lấy giá trị load trung bình trong 1 phút
- Nếu load1 > số core, nghĩa là CPU đang bị quá tải  
**Kiểm tra trạng thái dịch vụ**
```
check_nginx=$(systemctl is-active nginx)
echo $check_nginx
```
Tương tự như MySQL, PHP-FPM  
c. **Node Edit Result Check**  
Sau khi Node **Check System** thực thi thành công. Output sẽ trả về 1 item kiếu **string** nên ta cần phải tách ra và so sánh kết quả với điều kiện. Như sau:  
![image](https://github.com/user-attachments/assets/b1a2f103-5acc-41a7-8510-1d4667b7f7fe)

Node này sẽ chia các mảng này ra thành mảng sau đó lấy lần lượt kết quả các phần tử, dùng hàm trim() để xóa các khoảng trắng trước, sau và gán vào bằng một tên như **CPU Status**, **Inode**, **Disk  Status** ,... *Lưu ý thứ tự sẽ phải sắp xếp đúng với Node trước nhé nếu không sẽ xãy ra hiện tượng lấy kết quả của CPU so sánh điều kiện của RAM*  
![image](https://github.com/user-attachments/assets/18089d4c-b781-4fd6-8f32-482faccd1ecb)

d. **Node Code**  
Sau khi đã tách kết quả ta đem đi so sánh bằng đoạn code sau  
![image](https://github.com/user-attachments/assets/97f982a0-425a-4f1f-a5b0-d0a82fde3625)

```
const data = $json;
// 1. Các service cần check "active/inactive"
const services = [
  "Nginx Status",
  "MySQL Status",
  "PHP-FPM Status"
];

let msg = '⚠️ *Cảnh báo:*\n';
let alert = false;

const diskUsage = parseFloat(data["Disk Status"]);
if (!isNaN(diskUsage)) {
  if (diskUsage >= 90) { //bạn có thể thay đổi giá trị 90 này theo yêu cầu của mình để so sánh với Disk hiện tại nhé
    alert = true;
    msg += `- 🔴 Dung lượng đĩa đang rất cao: ${diskUsage} % \n`;
  } else if (diskUsage > 80) { //bạn có thể thay đổi giá trị 80 này theo yêu cầu của mình để so sánh với Disk hiện tại nhé
    alert = true;
    msg += `- 🟡 Dung lượng đĩa đang khá cao: ${diskUsage} % \n`;
  }
}

// Tùy chỉnh thêm CPU
const cpuUsage = parseFloat(data["CPU Status"]);
if (!isNaN(cpuUsage) && cpuUsage >= 90) { // có thể thay đổi thành 80 nếu bạn muốn CPU dùng trên 80% sẽ cảnh báo
  alert = true;
  msg += `- 🔴 CPU đang quá tải: ${cpuUsage} % \n`;
}

// 👉 RAM
const ramUsage = parseFloat(data["RAM"]);
if (!isNaN(ramUsage) && ramUsage >= 90) { // có thể thay đổi thành 80 nếu bạn muốn RAM dùng trên 80% sẽ cảnh báo
  alert = true;
  msg += `- 🔴 RAM đang quá tải: ${ramUsage} % \n`;
}

// 👉 Inode
const inodeFree = parseFloat(data["Inode"]);
if (!isNaN(inodeFree) && inodeFree > 90) {  có thể thay đổi thành 90 nếu bạn muốn Inode dùng trên 90% sẽ cảnh báo
  alert = true;
  msg += `- 🔴 Inode còn rất thấp, hiện đang sử dụng: ${inodeFree} % \n`;
}

// 👉 Load Average
const loadAvg = parseFloat(data["Average"]);
if (!isNaN(loadAvg) && loadAvg > 1) { // Kết quả của loadAvg sẽ có 2 giá trị 0 và 1 nên bạn không cần điều chỉnh giá trị này
  alert = true;
  msg += `- 🔴 Load Average trong 5 phút vừa qua đang cao: ${loadAvg} \n`;
}

// Kiểm tra trạng thái dịch vụ
for (const service of services) {
  const status = (data[service] || "").toLowerCase().trim();
  if (status === "inactive") {
    alert = true;
    msg += `- 🔴 ${service.trim()} đang *inactive* ❌\n`;
  }
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

























