# SSL, Domain, and DNS Guide

## SSL (Secure Socket Layer)
SSL (Secure Socket Layer) là công nghệ bảo mật mã hóa dữ liệu từ client đến máy chủ web server.

Dựa trên mức độ bảo mật, SSL được chia thành 3 loại với cấp độ xác thực nghiêm ngặt tăng dần:

- DV (Domain Validated): Xác thực cơ bản dựa trên tên miền.
- OV (Organization Validated): Xác thực tổ chức, yêu cầu kiểm tra thông tin doanh nghiệp.
- EV (Extended Validation): Xác thực cao nhất, yêu cầu kiểm tra kỹ lưỡng tổ chức và pháp lý.
CSR (Certificate Signing Request)

CSR là tệp yêu cầu dùng để gửi đến CA (Certificate Authority) nhằm cấp chứng chỉ. Nó là đoạn mã hóa chứa các thông tin như tên miền, tên tổ chức, và thông tin liên lạc.

Ví dụ lệnh tạo CSR bằng OpenSSL:

``` openssl req -new -newkey rsa:2048 -nodes -keyout tech.training.vietnix.tech -out ech.training.vietnix.tech.csr``` 



![image](https://github.com/user-attachments/assets/a8c70ffb-391e-4d65-9e3f-85f58ed6e0ba)



PEM (Privacy Enhanced Mail)

- PEM là định dạng tệp được sử dụng rộng rãi để lưu trữ và truyền tải chứng chỉ số, khóa mật mã, và dữ liệu bảo mật khác. Dữ liệu được mã hóa bằng Base64.

Private Key

- Private key (khóa riêng tư) là khóa được đặt ở phía server, dùng để giải mã lưu lượng dữ liệu từ client được mã hóa bằng public key.

PFX

- PFX là một loại tệp nhị phân chứa chứng chỉ (certificate), chứng chỉ trung gian (intermediate certificates), và khóa riêng tư (private key) trong một tệp duy nhất. PFX thường được dùng để cài đặt SSL trên IIS.

- Để chuyển đổi chứng chỉ, khóa riêng tư, v.v. sang định dạng PFX, bạn có thể sử dụng công cụ tại: [SSLShopper SSL Converter.](https://www.sslshopper.com/ssl-converter.html)

## Domain
Domain (tên miền) là địa chỉ website trên internet, giúp người dùng truy cập website thay vì phải ghi nhớ địa chỉ IP.
Các trạng thái của tên miền:
- Active: Tên miền đang hoạt động.
- AddPeriod: Trạng thái tên miền mới đăng ký hoặc gia hạn.
- AutoRenewPeriod: Tên miền ở trạng thái tự động gia hạn.
- Inactive: Tên miền sau khi đăng ký, đang chờ kích hoạt.
- PendingCreate: Tên miền đang chờ xác nhận đăng ký.
- PendingDelete: Tên miền hết hạn, chờ xóa khỏi hệ thống.
- PendingRenew: Tên miền đang chờ gia hạn.
- PendingRestore: Tên miền hết hạn, đang trong quá trình khôi phục.
- PendingTransfer: Tên miền đang chờ thay đổi nhà đăng ký.
- PendingUpdate: Tên miền đang chờ cập nhật thông tin.
- RedemptionPeriod: Tên miền hết hạn, đang trong giai đoạn chuộc lại.
- RenewPeriod: Tên miền đã hoàn tất quá trình gia hạn.
- ServerDeleteProhibited: Tên miền bị khóa để không bị xóa.
- ServerHold: Tên miền bị tạm ngưng bởi nhà quản lý tên miền.
- ServerRenewProhibited / ServerTransferProhibited: Tên miền không được phép chuyển đổi sang nhà đăng ký khác.
- ServerUpdateProhibited: Tên miền không được phép cập nhật.
- TransferPeriod: Tên miền đang trong trạng thái chuyển nhà đăng ký.

**Subdomain**

Subdomain (tên miền con) là một phần của tên miền chính. Ví dụ: Với tên miền chính nguyenhv.id.vn, bạn có thể tạo subdomain như sub.nguyenhv.id.vn.

**Virtual Host**
Virtual host cho phép nhiều website hoạt động trên cùng một máy chủ hoặc địa chỉ IP, giúp tối ưu tài nguyên và giảm chi phí.

## Mail Server
Mail Server là máy chủ dùng để gửi và nhận email bao gồm các giao thức smtp, imap, pop3   
DNS Records cho Email
- MX (Mail Exchange): Bản ghi DNS giúp điều hướng email đến đúng máy chủ nhận thư.
- DKIM: Bản ghi TXT cung cấp xác thực và độ tin cậy cho email gửi từ tên miền, sử dụng chữ ký số để tránh email giả mạo.
- SPF: Bản ghi TXT xác định các máy chủ email được ủy quyền gửi email từ tên miền cụ thể.
- PTR: Bản ghi phân giải địa chỉ IP sang tên miền.
## DNS (Domain Name System)
DNS (Domain Name System) chuyển đổi tên miền thành địa chỉ IP và ngược lại.
Các DNS Records phổ biến
- A: Địa chỉ IPv4.
- AAAA: Địa chỉ IPv6.
- MX: Mail Exchange (bản ghi email).
- CNAME: Bí danh (alias) cho tên miền.
- TXT: Bản ghi chứa nội dung văn bản tùy chỉnh.
- PTR: Bản ghi phân giải từ địa chỉ IP sang tên miền.
Các DNS hoạt động: Hệ thống DNS sẽ thực hiện tiếp nhận yêu cầu sau đó chuyển đổi tên miền sang địa chỉ IP và ngược lại

Quy trình phân giải DNS:  
***Client → Resolver → Root Server → TLD Server → Authoritative Name Server → IP Address.***  
Kết quả được trả về theo chiều ngược lại.  

Nếu có bộ nhớ cache ở bất kỳ giai đoạn nào từ Client đến Authoritative Name Server, hệ thống sẽ sử dụng cache thay vì truy vấn record đó. Do đó, khi thay đổi bản ghi DNS, thường mất một khoảng thời gian để các TLD hoặc Authoritative Name Server đồng bộ các bản ghi mới.
