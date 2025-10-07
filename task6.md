# Xây Dựng workflow

### Yêu cầu:

123

- Gửi cảnh báo khi CPU server vượt 90% trong 5 phút.
- Gửi cảnh báo khi RAM server còn trống dưới 10%.
- Gửi cảnh báo khi dung lượng ổ cứng còn trống dưới 15%.
- Gửi cảnh báo inode usage > 90%.
- Gửi cảnh báo khi server load average tăng cao bất thường.
- Gửi cảnh báo khi một dịch vụ quan trọng (Nginx, MySQL, PHP-FPM) bị dừng.
- Tất cả các Alert sẽ được gửi qua discord
  abc

# Workflow

```
{ "name": "My workflow 2", "nodes": [ { "parameters": { "rule": { "interval": [ { "field": "minutes" } ] } }, "id": "f0c63b17-543b-4955-b956-6184b5ffec83", "name": "Trigger Check System", "type": "n8n-nodes-base.scheduleTrigger", "position": [ 60, -100 ], "typeVersion": 1.2 }, { "parameters": { "jsCode": "const data = $json;\n\n// 1. Các service cần check \"active/inactive\"\nconst services = [\n  \"Nginx Status\",\n  \"MySQL Status\",\n  \"PHP-FPM Status\"\n];\n\nlet msg = '⚠️ *Cảnh báo:*\\n';\nlet alert = false;\n\n// 🔧 Tùy chỉnh riêng từng loại tài nguyên\nconst diskUsage = parseFloat(data[\"Disk Status\"]);\nif (!isNaN(diskUsage)) {\n  if (diskUsage >= 90) {\n    alert = true;\n    msg += `- 🔴 Dung lượng đĩa đang rất cao: ${diskUsage} % \\n`;\n  } else if (diskUsage > 80) {\n    alert = true;\n    msg += `- 🟡 Dung lượng đĩa đang khá cao: ${diskUsage} % \\n`;\n  }\n}\n\n// 👉 Tùy chỉnh thêm nếu muốn (ví dụ CPU)\nconst cpuUsage = parseFloat(data[\"CPU Status\"]);\nif (!isNaN(cpuUsage) && cpuUsage >= 90) {\n  alert = true;\n  msg += `- 🔴 CPU đang quá tải: ${cpuUsage} % \\n`;\n}\n\n// 👉 RAM\nconst ramUsage = parseFloat(data[\"RAM\"]);\nif (!isNaN(ramUsage) && ramUsage >= 90) {\n  alert = true;\n  msg += `- 🔴 RAM đang quá tải: ${ramUsage} % \\n`;\n}\n\n// 👉 Inode\nconst inodeFree = parseFloat(data[\"Inode\"]);\nif (!isNaN(inodeFree) && inodeFree > 2) {\n  alert = true;\n  msg += `- 🔴 Inode còn rất thấp, hiện đang sử dụng: ${inodeFree} % \\n`;\n}\n\n// 👉 Load Average\nconst loadAvg = parseFloat(data[\"Average\"]);\nif (!isNaN(loadAvg) && loadAvg > 1) {\n  alert = true;\n  msg += `- 🔴 Load Average trong 5 phút vừa qua đang cao: ${loadAvg} \\n`;\n}\n\n// Kiểm tra trạng thái dịch vụ\nfor (const service of services) {\n  const status = (data[service] || \"\").toLowerCase().trim();\n  if (status === \"inactive\") {\n    alert = true;\n    msg += `- 🔴 ${service.trim()} đang *inactive* ❌\\n`;\n  }\n}\n\nif (!alert) {\n  return []; // Không có cảnh báo → không gửi tiếp\n}\n\nreturn [\n  {\n    json: {\n      message: msg\n    }\n  }\n];\n" }, "type": "n8n-nodes-base.code", "typeVersion": 2, "position": [ 680, -100 ], "id": "77b11e1a-da55-49c5-bb98-8e929ec45c79", "name": "Code" }, { "parameters": { "authentication": "webhook", "content": "={{$json[\"message\"]}}", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ 880, -100 ], "id": "0650bd7b-ce5f-4f42-bcbc-4d585207f35f", "name": "Alert Discord", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } }, { "parameters": { "assignments": { "assignments": [ { "id": "49cf7bfb-eb70-454c-811b-6a6f9ecb462b", "name": "CPU Status", "value": "={{ $json.stdout.split('\\n')[0].trim()}}", "type": "string" }, { "id": "4a388c36-5a41-48ef-b998-38734827f56e", "name": "Inode", "value": "={{ $json.stdout.split('\\n')[1].trim()}}", "type": "string" }, { "id": "d6d59af7-157a-481a-ace3-5361b17f390f", "name": "Disk Status", "value": "={{ $json.stdout.split('\\n')[2].trim()}}", "type": "string" }, { "id": "392ff3e0-b7b6-48dd-b759-49701b895a4e", "name": "RAM", "value": "={{ $json.stdout.split('\\n')[3].trim()}}", "type": "string" }, { "id": "3a928756-860c-4e77-971b-75abee91d933", "name": "Average", "value": "={{ $json.stdout.split('\\n')[4].trim()}}", "type": "string" }, { "id": "93485443-3858-4868-a032-b9dc1a4be319", "name": "Nginx Status", "value": "={{ $json.stdout.split('\\n')[5].trim()}}", "type": "string" }, { "id": "96e03619-fa91-4025-9628-63a3be3c19c7", "name": "MySQL Status", "value": "={{ $json.stdout.split('\\n')[6].trim()}}", "type": "string" }, { "id": "693bb184-804f-4ffe-8337-cc66ccac1e51", "name": "PHP-FPM Status", "value": "={{ $json.stdout.split('\\n')[7].trim()}}", "type": "string" } ] }, "options": {} }, "type": "n8n-nodes-base.set", "typeVersion": 3.4, "position": [ 500, -100 ], "id": "01fbed51-31a6-405a-a226-80caced22a45", "name": "Edit Result Check" }, { "parameters": { "command": "#!/bin/bash\nCHECK_ONE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_ONE\nsleep 70s\nCHECK_TWO=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_TWO\nsleep 70s\nCHECK_THREE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_THREE\nsleep 70s\nCHECK_FOUR=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FOUR\nsleep 70s\nCHECK_FIVE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FIVE\nif (( $(echo \"$CHECK_ONE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_TWO > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_THREE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FOUR > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FIVE > 90\" | bc -l) )); then\n\n    echo $CHECK_FIVE\nelse\n    echo 0\nfi\n\ndf -ih | awk '$NF==\"/\"{printf \"%.2f\\n\", $5}'\n\ndf -h | awk '$NF==\"/\"{printf \"%.2f\\n\", $5}'\nfree | awk '/Mem:/ {printf \"%.2f\\n\", (1 - $7/$2) * 100}'\n\n# Lấy số core CPU\ncores=$(nproc)\n\n# Lấy load average 1 phút\nload1=$(awk '{print $2}' /proc/loadavg)\n\n# So sánh\nthreshold=$(echo \"$cores * 1.0\" | bc)  # cho phép 100% CPU load\n\n# In thông báo\nif (( $(echo \"$load1 > $threshold\" | bc -l) )); then\n    echo $load1\nelse\n    echo 0\nfi\ncheck_nginx=$(systemctl is-active nginx | awk \"{print $1}\")\necho $check_nginx\ncheck_mysql=$(systemctl is-active mysql | awk \"{print $1}\")\necho $check_mysql\ncheck_php_fpm=$(systemctl is-active php8.1-fpm | awk \"{print $1}\")\necho $check_php_fpm\n\n\n\n\n\n" }, "id": "e826507e-1438-48df-86e6-b84faab18dff", "name": "Check System", "type": "n8n-nodes-base.ssh", "position": [ 300, -100 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } } ], "pinData": {}, "connections": { "Trigger Check System": { "main": [ [ { "node": "Check System", "type": "main", "index": 0 } ] ] }, "Code": { "main": [ [ { "node": "Alert Discord", "type": "main", "index": 0 } ] ] }, "Edit Result Check": { "main": [ [ { "node": "Code", "type": "main", "index": 0 } ] ] }, "Check System": { "main": [ [ { "node": "Edit Result Check", "type": "main", "index": 0 } ] ] } }, "active": false, "settings": { "executionOrder": "v1" }, "versionId": "8796f54c-996b-4ca5-a1aa-b9973a471b6d", "meta": { "instanceId": "3ccf4ecd0404b7fa314448bdbf1ad0285178274f152b93d738dc0c826690b592" }, "id": "cybWjxlwsLxMY937", "tags": [] }
```

### Logic thực hiện

Sử dụng gửi lệnh Command Line đến VPS để lấy các giá trị như trang thái dịch vụ (nginx, mysql, php-fpm), thông tin RAM, DISK, CPU, Inode, Load Average. Sau đó ta so sánh với các giá trị cho trước nếu vượt qua sẽ gửi thông tin đến Discord. Chạy Workflow 5 phút một lần

### Một số node được sử dụng trong bài LAB

![39](https://github.com/user-attachments/assets/4ae72ddc-0c6c-4e8b-9311-7ba1f9dae12b)

- Trigger: **On a Schedule** sử dung để chạy workflow tự động theo thời gian hoặc chu kỳ.
- Node **SSH** với Action **Execute a command** để gửi command line thông qua SSH (có thể dùng key hoặc password)
- Node Edit Fields dùng để lọc chỉnh sửa các character sau kết quả trả về từ SSH
- Node code để so sánh các giá trị lấy được từ SSH Command và giá trị đặt trước
- Node Discord dùng để gửi message đến discord thông qua Webhook

### Workflow check trang thái của hệ thống

- Trigger: Cho chạy mỗi 5 phút 1 lần
- Sau đó ta gửi các command để lấy các thông tin của hệ thống để so sánh

### Check CPU

Logic: Ở đây ta lấy CPU không hoạt động sau đó lấy 100 - số CPU không hoạt động sẽ ra CPU đang sử dụng. Ta chạy lệnh 5 lần lưu lại với 5 biến ở mỗi lần ta dùng lệnh sleep để giãn cách thời gian sau đó mỗi lệnh chạy trong > 1 phút chạy lệnh sleep trong 4 lần nếu cả 5 giá trị của biến đều lớn hơn 90 sẽ được tính là CPU vượt quá 90%. Ngược lại nếu 1 trong 5 lần không vượt quá 90 nghĩa là trong vòng 5 phút load CPU không luôn luôn quá 90 và sẽ không gửi message  
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

Hiện thị inode theo dạng con người có thể đọc và lấy dòng có ký tự cuối cùng là / lấy cột thứ 5 của dòng đó (là cột % Usage) sau đó in ra giá trị của inode đang sử dụng

### Check RAM

```
free | awk '/Mem:/ {printf "%.2f", (1 - $7/$2) * 100}'
```

Lấy giá trị Memory đang sử dụng bằng cách lấy 1 - (avaiable/ total) \* 100 phần trăm sau đó làm tròn đến chữ số thập phân số 2

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

### Sử dụng node Edit Field

Dùng dễ chia tác và xóa khoảng trắng dữ liệu

### Sử dụng node code

Xữ lí điều kiện nếu các giá trị vượt mức cho phép sẽ tạo mess sau đó đẫy cho discord  
Code xữ lý như sau:

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
![41](https://github.com/user-attachments/assets/dbcd8efe-f25d-45a7-8a03-9fc26002a0b3)

# Kiểm tra

![38](https://github.com/user-attachments/assets/c5cf2b04-3e2b-41c0-8c95-ff646d90e231)
