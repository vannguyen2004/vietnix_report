# Xây Dựng workflow
### Yêu cầu:
- Gửi cảnh báo khi CPU server vượt 90% trong 5 phút.
- Gửi cảnh báo khi RAM server còn trống dưới 10%.
- Gửi cảnh báo khi dung lượng ổ cứng còn trống dưới 15%.
- Gửi cảnh báo  inode usage > 90%. 
- Gửi cảnh báo khi server load average tăng cao bất thường.
- Gửi cảnh báo khi một dịch vụ quan trọng (Nginx, MySQL, PHP-FPM) bị dừng.
- Tất cả các Alert sẽ được gửi qua discord

# Workflow 
```
{ "name": "Check System", "nodes": [ { "parameters": { "command": "free | awk '/Mem:/ {printf \"%.2f\", (1 - $7/$2) * 100}'" }, "id": "c0d1b90b-6803-4f6d-a808-11b542604ac3", "name": "Check RAM usage", "type": "n8n-nodes-base.ssh", "position": [ -480, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "df -h | awk '$NF==\"/\"{printf \"%.2f\", $5}'" }, "id": "6bfa0a1e-da66-48c1-8698-efe3d5c068a0", "name": "Check Disk usage", "type": "n8n-nodes-base.ssh", "position": [ -260, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "#!/bin/bash\nCHECK_ONE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_ONE\nsleep 70s\nCHECK_TWO=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_TWO\nsleep 70s\nCHECK_THREE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_THREE\nsleep 70s\nCHECK_FOUR=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FOUR\nsleep 70s\nCHECK_FIVE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FIVE\nif (( $(echo \"$CHECK_ONE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_TWO > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_THREE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FOUR > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FIVE > 90\" | bc -l) )); then\n\n    echo $CHECK_FIVE\nelse\n    echo 0\nfi\n\n\n" }, "id": "817771fc-d28f-4abd-b9d7-8ec228e4f7ed", "name": "Check CPU usage", "type": "n8n-nodes-base.ssh", "position": [ -920, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "#!/bin/bash\n\ncheck_nginx=$(systemctl is-active nginx | awk \"{print $1}\")\necho $check_nginx\ncheck_mysql=$(systemctl is-active mysql | awk \"{print $1}\")\necho $check_mysql\ncheck_php_fpm=$(systemctl is-active php8.1-fpm | awk \"{print $1}\")\necho $check_php_fpm\n" }, "id": "25e36b7a-4f6d-40e1-852f-de9207d5dfba", "name": "Check Service", "type": "n8n-nodes-base.ssh", "position": [ 160, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "df -ih | awk '$NF==\"/\"{printf \"%.2f\", $5}'" }, "type": "n8n-nodes-base.ssh", "typeVersion": 1, "position": [ -720, -240 ], "id": "777ddd34-cd9a-41ae-a85e-c1600ebdd84e", "name": "Check inode Usage", "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "#!/bin/bash\n\n# Lấy số core CPU\ncores=$(nproc)\n\n# Lấy load average 1 phút\nload1=$(awk '{print $2}' /proc/loadavg)\n\n# So sánh\nthreshold=$(echo \"$cores * 1.0\" | bc)  # cho phép 100% CPU load\n\n# In thông báo\nif (( $(echo \"$load1 > $threshold\" | bc -l) )); then\n    echo $load1\nelse\n    echo 0\nfi\n" }, "id": "c6b6558d-5cf6-4989-8ccc-0bee2e40c79e", "name": "Check Average", "type": "n8n-nodes-base.ssh", "position": [ -60, -240 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "rule": { "interval": [ { "field": "minutes" } ] } }, "id": "3ee87af8-f164-4e60-9d42-eb65a53ce0f3", "name": "Trigger Check System", "type": "n8n-nodes-base.scheduleTrigger", "position": [ -1160, -240 ], "typeVersion": 1.2 }, { "parameters": { "assignments": { "assignments": [ { "id": "49cf7bfb-eb70-454c-811b-6a6f9ecb462b", "name": "Nginx Status ", "value": "={{ $json.ServiceStatus.split('\\n')[0].trim() }}", "type": "string" }, { "id": "4a388c36-5a41-48ef-b998-38734827f56e", "name": "MySQL Status", "value": "={{ $json.ServiceStatus.split('\\n')[1].trim() }}", "type": "string" }, { "id": "d6d59af7-157a-481a-ace3-5361b17f390f", "name": "PHP_FPM", "value": "={{ $json.ServiceStatus.split('\\n')[2].trim() }}", "type": "string" }, { "id": "392ff3e0-b7b6-48dd-b759-49701b895a4e", "name": "CPU Status", "value": "={{ $json.CPU }}", "type": "string" }, { "id": "3a928756-860c-4e77-971b-75abee91d933", "name": "Disk Status", "value": "={{ $json.Disk }}", "type": "string" }, { "id": "93485443-3858-4868-a032-b9dc1a4be319", "name": "Average", "value": "={{ $('Check Average').item.json.stdout }}", "type": "string" }, { "id": "96e03619-fa91-4025-9628-63a3be3c19c7", "name": "Inode", "value": "={{ $json.Inode }}", "type": "string" }, { "id": "693bb184-804f-4ffe-8337-cc66ccac1e51", "name": "RAM", "value": "={{ $json.RAM }}", "type": "string" } ] }, "options": {} }, "type": "n8n-nodes-base.set", "typeVersion": 3.4, "position": [ -580, 80 ], "id": "cd6b41c9-6a0b-44ca-8100-55547646ab52", "name": "Edit Result Check Service" }, { "parameters": { "mode": "combineBySql", "numberInputs": 6, "query": "SELECT\n  input1.stdout AS CPU,\n  input2.stdout AS Disk,\n  input3.stdout AS RAM,\n  input4.stdout AS LoadAverage,\n  input5.stdout AS Inode,\n  input6.stdout AS ServiceStatus\nFROM input1\nLEFT JOIN input2 ON true\nLEFT JOIN input3 ON true\nLEFT JOIN input4 ON true\nLEFT JOIN input5 ON true\nLEFT JOIN input6 ON true" }, "id": "abfcd5b9-2502-47a3-a19d-c58d5db9d519", "name": "Merge check results", "type": "n8n-nodes-base.merge", "position": [ -860, 20 ], "typeVersion": 3 }, { "parameters": { "jsCode": "const data = $json;\n\n// 1. Ngưỡng cảnh báo cho tài nguyên\nconst threshold = {\n  \"CPU Status\": 90,\n  \"RAM\": 90,\n  \"Disk Status\": 80,\n  \"Inode\": 90,\n  \"Average\": 1  \n};\n\n// 2. Các service cần check \"active/inactive\"\nconst services = [\n  \"Nginx Status \",\n  \"MySQL Status\",\n  \"PHP_FPM\"\n];\n\nlet msg = '⚠️ *Cảnh báo:*\\n';\nlet alert = false;\n\n// Kiểm tra vượt ngưỡng\nfor (const key in threshold) {\n  const value = parseFloat(data[key]);\n\n  if (!isNaN(value) && value >= threshold[key]) {\n    alert = true;\n    msg += `- ${key} đang cao: ${value}\\n `;\n  }\n}\n\n// Kiểm tra trạng thái dịch vụ\nfor (const service of services) {\n  const status = (data[service] || \"\").toLowerCase().trim();\n  if (status === \"inactive\") {\n    alert = true;\n    msg += `- ${service.trim()} đang *inactive* ❌\\n`;\n  }\n}\n\nif (!alert) {\n  return []; // Không có cảnh báo → không gửi tiếp\n}\n\nreturn [\n  {\n    json: {\n      message: msg\n    }\n  }\n];\n" }, "type": "n8n-nodes-base.code", "typeVersion": 2, "position": [ -320, 80 ], "id": "3e9f5628-3099-458d-a71a-ec21217606ed", "name": "Code" }, { "parameters": { "authentication": "webhook", "content": "={{$json[\"message\"]}}", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ -40, 80 ], "id": "76c0b7b6-5979-48c5-819d-cded66609a38", "name": "Alert Discord", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } } ], "pinData": {}, "connections": { "Check CPU usage": { "main": [ [ { "node": "Check inode Usage", "type": "main", "index": 0 }, { "node": "Merge check results", "type": "main", "index": 0 } ] ] }, "Check RAM usage": { "main": [ [ { "node": "Merge check results", "type": "main", "index": 2 }, { "node": "Check Disk usage", "type": "main", "index": 0 } ] ] }, "Check Disk usage": { "main": [ [ { "node": "Check Average", "type": "main", "index": 0 }, { "node": "Merge check results", "type": "main", "index": 1 } ] ] }, "Check Service": { "main": [ [ { "node": "Merge check results", "type": "main", "index": 5 } ] ] }, "Check inode Usage": { "main": [ [ { "node": "Check RAM usage", "type": "main", "index": 0 }, { "node": "Merge check results", "type": "main", "index": 4 } ] ] }, "Check Average": { "main": [ [ { "node": "Check Service", "type": "main", "index": 0 }, { "node": "Merge check results", "type": "main", "index": 3 } ] ] }, "Trigger Check System": { "main": [ [ { "node": "Check CPU usage", "type": "main", "index": 0 } ] ] }, "Edit Result Check Service": { "main": [ [ { "node": "Code", "type": "main", "index": 0 } ] ] }, "Merge check results": { "main": [ [ { "node": "Edit Result Check Service", "type": "main", "index": 0 } ] ] }, "Code": { "main": [ [ { "node": "Alert Discord", "type": "main", "index": 0 } ] ] }, "Alert Discord": { "main": [ [] ] } }, "active": false, "settings": { "executionOrder": "v1" }, "versionId": "1bb14b71-cbf4-4322-b301-3875fbc99b34", "meta": { "templateCredsSetupCompleted": true, "instanceId": "3ccf4ecd0404b7fa314448bdbf1ad0285178274f152b93d738dc0c826690b592" }, "id": "pFVS79o2vpqIpjR2", "tags": [] }
```

### Logic thực hiện

Sử dụng gửi lệnh Command Line đến VPS để lấy các giá trị như trang thái dịch vụ (nginx, mysql, php-fpm), thông tin RAM, DISK, CPU, Inode, Load Average. Sau đó ta so sánh với các giá trị cho trước nếu vượt qua sẽ gửi thông tin đến Discord. Chạy Workflow 5 phút một lần
### Một số node được sử dụng trong bài LAB

![28](https://github.com/user-attachments/assets/d2b0faae-d4fa-4d35-b04f-3e7bc13e1f1b)



- Trigger: **On a Schedule** sử dung để chạy workflow tự động theo thời gian hoặc chu kỳ.
- Node **SSH** với Action **Execute a command** để gửi command line thông qua SSH (có thể dùng key hoặc password)
- Node Edit Fields dùng để lọc chỉnh sửa các character sau kết quả trả về từ SSH
- Node code để so sánh các giá trị lấy được từ SSH Command và giá trị đặt trước
- Node Discord dùng để gửi message đến discord thông qua Webhook


### Workflow check trang thái của hệ thống
- Trigger: Cho chạy mỗi 5 phút 1 lần
- Sau đó ta gửi các command để lấy các thông tin của hệ thống để so sánh

### Check CPU
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
### Check Inode Usage
```
 df -ih | awk '$NF=="/"{printf "%.2f", $5}'
```
  Hiện thị inode theo dạng con người có thể đọc và lấy dòng có ký tự cuối cùng là / lấy cột thứ 5 của dòng đó (là cột % Usage) sau đó in ra giá trị  của inode đang sử dụng

###  Check RAM  
```
free | awk '/Mem:/ {printf "%.2f", (1 - $7/$2) * 100}'
```

Lấy giá trị Memory đang sử dụng bằng cách lấy 1 - (avaiable/ total) * 100 phần trăm sau đó làm tròn đến chữ số thập phân số 2

### Check Disk
```
df -h | awk '$NF=="/"{printf "%.2f", $5}'
```
Tương tự ta lấy cột Used (cột số 5) ở dòng có kí tự cuối cùng là /

### Check Average 
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
- Ở các node Điều kiện IF và Discord sẽ là kiểm tra theo điều kiện cho trước mà nếu match thì sẽ gửi message. Việc N8N và Discord sẽ giao tiếp qua webhook của Discord
### Check Status Service
- ta gửi đoạn command sau
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

### Sử dụng node Merger
Mục đích để gom Input từ các node trước đó để dễ sử lý
![29](https://github.com/user-attachments/assets/dc7f2d1e-dc11-422e-bc67-1e98a787d0e5)

### Sử dụng node Edit Field 
Dùng dễ chia tác và xóa khoản trắng dữ liệu
### Sử dụng node code 
Xữ lí điều kiện nếu các giá trị vượt mức cho phép sẽ tạo mess sau đó đẫy cho discord  
Code xữ lí như sau:

```
const data = $json;

// 1. Các service cần check "active/inactive"
const services = [
  "Nginx Status ",
  "MySQL Status",
  "PHP_FPM"
];

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
### Node Discord
Ta truyền vào mess của node code trước đó
![30](https://github.com/user-attachments/assets/0bd47f43-644f-4bd1-9f0d-6177f16ac5d3)

# Kiểm tra 
- Tắt dịch vụ nginx, stress test đĩa cao, CPU, Load Average cao

![31](https://github.com/user-attachments/assets/300c173a-8648-4f5a-926d-0e6a9af932a8)
![32](https://github.com/user-attachments/assets/f2841b41-c967-4dbf-830e-2fe8e6bc030e)


![33](https://github.com/user-attachments/assets/d4593698-1a8c-4e4d-a836-0d550ec77490)

- Kiểm tra RAM

![34](https://github.com/user-attachments/assets/b27afce5-c765-4502-aa5f-cddafab25140)
![35](https://github.com/user-attachments/assets/886de5a2-9244-4b6b-8c10-b9bbe685d028)
- Kiểm tra inode (đã giảm mức inode xuống nếu > 2% sẽ gửi cảnh báo)

![36](https://github.com/user-attachments/assets/e2971cd8-426d-446b-8116-229ed2f1dc60)
![37](https://github.com/user-attachments/assets/1aa8fa07-bb01-4c37-91a4-70813ab2d92c)


















  
