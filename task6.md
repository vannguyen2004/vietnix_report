# Xây Dựng workflow
### Yêu cầu:
- Gửi cảnh báo khi CPU server vượt 90% trong 5 phút.
- Gửi cảnh báo khi RAM server còn trống dưới 10%.
- Gửi cảnh báo khi dung lượng ổ cứng còn trống dưới 15%.
- Gửi cảnh báo  inode usage > 90%. 
- Gửi cảnh báo khi server load average tăng cao bất thường.
- Gửi cảnh báo khi một dịch vụ quan trọng (Nginx, MySQL, PHP-FPM) bị dừng.
- Tất cả các Alert sẽ được gửi qua discord

### Workflow 
```
{ "name": "Check System", "nodes": [ { "parameters": { "command": "free | awk '/Mem:/ {printf \"%.2f\", (1 - $7/$2) * 100}'" }, "id": "c0d1b90b-6803-4f6d-a808-11b542604ac3", "name": "Check RAM usage", "type": "n8n-nodes-base.ssh", "position": [ -700, -380 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "df -h | awk '$NF==\"/\"{printf \"%.2f\", $5}'" }, "id": "6bfa0a1e-da66-48c1-8698-efe3d5c068a0", "name": "Check Disk usage", "type": "n8n-nodes-base.ssh", "position": [ -480, -380 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "#!/bin/bash\nCHECK_ONE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_ONE\nsleep 70s\nCHECK_TWO=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_TWO\nsleep 70s\nCHECK_THREE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_THREE\nsleep 70s\nCHECK_FOUR=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FOUR\nsleep 70s\nCHECK_FIVE=$(top -bn 1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}')\n#echo $CHECK_FIVE\nif (( $(echo \"$CHECK_ONE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_TWO > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_THREE > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FOUR > 90\" | bc -l) )) && \\\n   (( $(echo \"$CHECK_FIVE > 90\" | bc -l) )); then\n\n    echo $CHECK_FIVE\nelse\n    echo 0\nfi\n\n\n" }, "id": "817771fc-d28f-4abd-b9d7-8ec228e4f7ed", "name": "Check CPU usage", "type": "n8n-nodes-base.ssh", "position": [ -1120, -380 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } }, "disabled": true }, { "parameters": { "command": "#!/bin/bash\n\ncheck_nginx=$(systemctl is-active nginx | awk \"{print $1}\")\necho $check_nginx\ncheck_mysql=$(systemctl is-active mysql | awk \"{print $1}\")\necho $check_mysql\ncheck_php_fpm=$(systemctl is-active php8.1-fpm | awk \"{print $1}\")\necho $check_php_fpm\n" }, "id": "25e36b7a-4f6d-40e1-852f-de9207d5dfba", "name": "Check Service", "type": "n8n-nodes-base.ssh", "position": [ -60, -380 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "command": "df -ih | awk '$NF==\"/\"{printf \"%.2f\", $5}'" }, "type": "n8n-nodes-base.ssh", "typeVersion": 1, "position": [ -920, -380 ], "id": "777ddd34-cd9a-41ae-a85e-c1600ebdd84e", "name": "Check inode Usage", "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "conditions": { "number": [ { "value1": "={{ $json.stdout }}", "operation": "larger", "value2": 85 } ] }, "combineOperation": "any" }, "id": "4c583b29-5df8-42aa-9ff6-062529ae249c", "name": "Check Disk", "type": "n8n-nodes-base.if", "position": [ -440, 20 ], "typeVersion": 1 }, { "parameters": { "conditions": { "number": [ { "value1": "={{ $json.stdout }}", "operation": "larger", "value2": 90 } ] }, "combineOperation": "any" }, "id": "6a1f0d1e-3f47-4c53-b4fe-a3c22f72161f", "name": "Check Inode", "type": "n8n-nodes-base.if", "position": [ -880, 300 ], "typeVersion": 1 }, { "parameters": { "conditions": { "number": [ { "value1": "={{ $json.stdout }}", "operation": "larger", "value2": 1 } ] }, "combineOperation": "any" }, "id": "1217af50-71b2-4493-863c-853fc39ee126", "name": "Check CPU", "type": "n8n-nodes-base.if", "position": [ -1060, 440 ], "typeVersion": 1 }, { "parameters": { "conditions": { "number": [ { "value1": "={{ $json.stdout }}", "operation": "larger", "value2": 60 } ] }, "combineOperation": "any" }, "id": "e6c2f9f8-e47a-4422-b310-61dd0344e0a5", "name": "Check RAM", "type": "n8n-nodes-base.if", "position": [ -640, 160 ], "typeVersion": 1 }, { "parameters": { "authentication": "webhook", "content": "=RAM server còn trống dưới 10%.\nPhần trăm RAM đang sử dụng hiện tại là: {{ $('Check RAM usage').item.json.stdout }} %\nThời gian: {{ $('Trigger Check System').item.json.Hour }}:{{ $('Trigger Check System').item.json.Minute }} Date {{ $('Trigger Check System').item.json['Day of month'] }} Month {{ $('Trigger Check System').item.json.Month }} Year {{ $('Trigger Check System').item.json.Year }}\n===============================", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ -460, 160 ], "id": "8e080c3d-e45a-4e3f-834c-74f29ee6374b", "name": "Alert RAM", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } }, { "parameters": { "authentication": "webhook", "content": "=Dung lượng đĩa hiện đang thấp dưới 15%\nPhần trăm ổ đĩa đã sử dụng: {{ $('Check Disk usage').item.json.stdout }} %\nThời gian: {{ $('Trigger Check System').item.json.Hour }}:{{ $('Trigger Check System').item.json.Minute }} Date {{ $('Trigger Check System').item.json['Day of month'] }} Month {{ $('Trigger Check System').item.json.Month }} Year {{ $('Trigger Check System').item.json.Year }}\n===============================", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ -260, 20 ], "id": "b11d0771-9118-4546-96bc-5f1c3fd605bb", "name": "Alert Disk", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } }, { "parameters": { "authentication": "webhook", "content": "=Inode usage > 90%\nPhần trăm Inode đang sử dụng: {{ $('Check inode Usage').item.json.stdout }} %\nThời gian: {{ $('Trigger Check System').item.json.Hour }}:{{ $('Trigger Check System').item.json.Minute }} Date {{ $('Trigger Check System').item.json['Day of month'] }} Month {{ $('Trigger Check System').item.json.Month }} Year {{ $('Trigger Check System').item.json.Year }}\n===============================", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ -700, 300 ], "id": "f303c13f-fcd1-4221-bd61-664fd9c74e0f", "name": "Alert Inode", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } }, { "parameters": { "authentication": "webhook", "content": "=Phần trăm CPU hiện đang cao hơn 90 trong vòng 5 phút gần nhất\nPhần trăm của CPU đang sử dụng hiện tại là: {{ $('Check CPU usage').item.json.stdout }} %\nThời gian: {{ $('Trigger Check System').item.json.Hour }}:{{ $('Trigger Check System').item.json.Minute }} Date {{ $('Trigger Check System').item.json['Day of month'] }} Month {{ $('Trigger Check System').item.json.Month }} Year {{ $('Trigger Check System').item.json.Year }}\n===============================", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ -840, 440 ], "id": "b6cec1ec-1052-4029-96a6-5df3e38f543d", "name": "Alert CPU", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } }, { "parameters": { "command": "#!/bin/bash\n\n# Lấy số core CPU\ncores=$(nproc)\n\n# Lấy load average 1 phút\nload1=$(awk '{print $2}' /proc/loadavg)\n\n# So sánh\nthreshold=$(echo \"$cores * 1.0\" | bc)  # cho phép 100% CPU load\n\n# In thông báo\nif (( $(echo \"$load1 > $threshold\" | bc -l) )); then\n    echo $load1\nelse\n    echo 0\nfi\n" }, "id": "c6b6558d-5cf6-4989-8ccc-0bee2e40c79e", "name": "Check Average", "type": "n8n-nodes-base.ssh", "position": [ -260, -380 ], "executeOnce": false, "typeVersion": 1, "credentials": { "sshPassword": { "id": "MEEc25RNo6SKcMdk", "name": "SSH 14.225.255.126" } } }, { "parameters": { "conditions": { "number": [ { "value1": "={{ $json.stdout }}", "operation": "larger", "value2": 1 } ] }, "combineOperation": "any" }, "id": "ed92312b-746e-4459-a21c-e054d7403494", "name": "Check Load", "type": "n8n-nodes-base.if", "position": [ -220, -140 ], "typeVersion": 1 }, { "parameters": { "authentication": "webhook", "content": "=Load Average đang tăng cao bất thường trong 5 phút gần đây\nLoad hiện tại trong vòng 5 phút gần nhất là: {{ $('Check Average').item.json.stdout }} %\nThời gian: {{ $('Trigger Check System').item.json.Hour }}:{{ $('Trigger Check System').item.json.Minute }} Date {{ $('Trigger Check System').item.json['Day of month'] }} Month {{ $('Trigger Check System').item.json.Month }} Year {{ $('Trigger Check System').item.json.Year }}\n===============================", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ -40, -140 ], "id": "3043667b-b0d7-4f8e-b0bd-78db175ab19b", "name": "Alert Load", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } }, { "parameters": { "rule": { "interval": [ { "field": "minutes" } ] } }, "id": "3ee87af8-f164-4e60-9d42-eb65a53ce0f3", "name": "Trigger Check System", "type": "n8n-nodes-base.scheduleTrigger", "position": [ -1360, -380 ], "typeVersion": 1.2 }, { "parameters": { "conditions": { "options": { "caseSensitive": true, "leftValue": "", "typeValidation": "strict", "version": 2 }, "conditions": [ { "id": "3f37b6e7-b7b3-4fe0-85fa-3d8795966663", "leftValue": "={{ $json['Nginx Status'] }}", "rightValue": "inactive", "operator": { "type": "string", "operation": "equals", "name": "filter.operator.equals" } }, { "id": "0cb52807-5901-4c2e-8651-ddf9c4237ea0", "leftValue": "={{ $json['MySQL Status'] }}", "rightValue": "inactive", "operator": { "type": "string", "operation": "equals", "name": "filter.operator.equals" } }, { "id": "dbd9eb0c-d813-4fa6-83c1-1ba22a5c6b3a", "leftValue": "={{ $json['PHP-FPM Status'] }}", "rightValue": "inactive", "operator": { "type": "string", "operation": "equals", "name": "filter.operator.equals" } } ], "combinator": "or" }, "options": {} }, "type": "n8n-nodes-base.if", "typeVersion": 2.2, "position": [ 320, -380 ], "id": "bff1e567-ede0-4e08-8fa2-19011f5262e2", "name": "Check Server Inactive" }, { "parameters": { "assignments": { "assignments": [ { "id": "f7c85642-1a27-4a61-b40b-30958c878d1a", "name": "Nginx Status", "value": "={{ $json.stdout.split('\\n')[0].trim() }}", "type": "string" }, { "id": "90140e84-65ab-4eff-a141-676b7791fa92", "name": "MySQL Status", "value": "={{ $json.stdout.split('\\n')[1].trim() }}", "type": "string" }, { "id": "4effc102-94f3-4960-a823-e3af46a46493", "name": "PHP-FPM Status", "value": "={{ $json.stdout.split('\\n')[2].trim() }}", "type": "string" } ] }, "options": {} }, "type": "n8n-nodes-base.set", "typeVersion": 3.4, "position": [ 120, -380 ], "id": "cd6b41c9-6a0b-44ca-8100-55547646ab52", "name": "Edit Result Check Service" }, { "parameters": { "authentication": "webhook", "content": "=Service Down \nNginx Status: {{ $json['Nginx Status'] }}\nMySQL Status: {{ $json['MySQL Status'] }}\nPHP-FPM Status: {{ $json['PHP-FPM Status'] }}\nThời gian: {{ $('Trigger Check System').item.json.Hour }}:{{ $('Trigger Check System').item.json.Minute }} Date {{ $('Trigger Check System').item.json['Day of month'] }} Month {{ $('Trigger Check System').item.json.Month }} Year {{ $('Trigger Check System').item.json.Year }}\n===============================", "options": {} }, "type": "n8n-nodes-base.discord", "typeVersion": 2, "position": [ 560, -380 ], "id": "76c0b7b6-5979-48c5-819d-cded66609a38", "name": "Alert Service", "webhookId": "01b767d1-48f3-457e-9426-caf5892a13b2", "credentials": { "discordWebhookApi": { "id": "vYU2ovSkuEHcdKiB", "name": "Discord Webhook account" } } } ], "pinData": {}, "connections": { "Check CPU usage": { "main": [ [ { "node": "Check CPU", "type": "main", "index": 0 }, { "node": "Check inode Usage", "type": "main", "index": 0 } ] ] }, "Check RAM usage": { "main": [ [ { "node": "Check RAM", "type": "main", "index": 0 }, { "node": "Check Disk usage", "type": "main", "index": 0 } ] ] }, "Check Disk usage": { "main": [ [ { "node": "Check Disk", "type": "main", "index": 0 }, { "node": "Check Average", "type": "main", "index": 0 } ] ] }, "Check Service": { "main": [ [ { "node": "Edit Result Check Service", "type": "main", "index": 0 } ] ] }, "Check inode Usage": { "main": [ [ { "node": "Check Inode", "type": "main", "index": 0 }, { "node": "Check RAM usage", "type": "main", "index": 0 } ] ] }, "Check Disk": { "main": [ [ { "node": "Alert Disk", "type": "main", "index": 0 } ] ] }, "Check Inode": { "main": [ [ { "node": "Alert Inode", "type": "main", "index": 0 } ] ] }, "Check CPU": { "main": [ [ { "node": "Alert CPU", "type": "main", "index": 0 } ] ] }, "Check RAM": { "main": [ [ { "node": "Alert RAM", "type": "main", "index": 0 } ] ] }, "Check Average": { "main": [ [ { "node": "Check Load", "type": "main", "index": 0 }, { "node": "Check Service", "type": "main", "index": 0 } ] ] }, "Check Load": { "main": [ [ { "node": "Alert Load", "type": "main", "index": 0 } ] ] }, "Trigger Check System": { "main": [ [ { "node": "Check CPU usage", "type": "main", "index": 0 } ] ] }, "Check Server Inactive": { "main": [ [ { "node": "Alert Service", "type": "main", "index": 0 } ] ] }, "Edit Result Check Service": { "main": [ [ { "node": "Check Server Inactive", "type": "main", "index": 0 } ] ] }, "Alert Service": { "main": [ [] ] } }, "active": true, "settings": { "executionOrder": "v1" }, "versionId": "5ef3b83e-8575-4be8-a62b-b46c35b31d70", "meta": { "templateCredsSetupCompleted": true, "instanceId": "3ccf4ecd0404b7fa314448bdbf1ad0285178274f152b93d738dc0c826690b592" }, "id": "pFVS79o2vpqIpjR2", "tags": [] }
```

### Logic thực hiện

Sử dụng gửi lệnh Command Line đến VPS để lấy các giá trị như trang thái dịch vụ (nginx, mysql, php-fpm), thông tin RAM, DISK, CPU, Inode, Load Average. Sau đó ta so sánh với các giá trị cho trước nếu vượt qua sẽ gửi thông tin đến Discord.  
Trong Workflow hiện tại đang chia ra thành 2 workflow nhỏ hơn là:
- Một workflow check dịch vụ đang chạy với thời gian 2 phút 1 lần.
- Một workflow sẽ check các thông tin của hệ thống như CPU, RAM, DISK, Load Average, Inode sẽ được kiểm tra 5 phút 1 lần
### Một số node được sử dụng trong bài LAB

![24](https://github.com/user-attachments/assets/a7089a9a-738c-488a-9a71-fa5bec03a498)

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

### Kiểm tra resource của hệ thống

##### Check disk
![15](https://github.com/user-attachments/assets/c2a7246d-8c77-456d-be7c-2e0c2de7f10a)
![16](https://github.com/user-attachments/assets/c9f043d1-9d8f-4b24-bd05-c252d50797f3)

##### Check RAM 
![18](https://github.com/user-attachments/assets/facb884d-e5d4-4f90-b8b0-d3fd5151298f)
![19](https://github.com/user-attachments/assets/c30bc24f-8bfd-4ef2-a352-26f8f84bfb8b)

##### Check COU và Load Average

![22](https://github.com/user-attachments/assets/b0d145c9-0211-4450-8c66-ab529a170394)
![23](https://github.com/user-attachments/assets/00da0c1f-b5ee-4897-9cad-099bff54b353)























  
