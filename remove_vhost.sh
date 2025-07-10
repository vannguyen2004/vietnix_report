#!/bin/bash

# Màu sắc
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
RESET='\e[0m'

delete_file_config(){
    local domain=$1

    echo -e "${YELLOW}🧹 Đang gỡ kích hoạt và xoá cấu hình ${domain}...${RESET}"
    a2dissite "${domain}.conf" > /dev/null

    sudo find /etc/apache2/sites-available -type f -name "${domain}.conf" -exec rm {} \; > /dev/null 2>&1
    sudo find /var/log/apache2/ -type d -name "${domain}" -exec rm -rf {} \; > /dev/null 2>&1
    if ./check_domain_exist.sh "${domain}-le-ssl"; then
        a2dissite "${domain}-le-ssl.conf" > /dev/null
        rm -f /etc/apache2/sites-available/${domain}-le-ssl.conf 
    fi
    apache2ctl configtest
     if [[ $? -ne 0 ]]; then
        echo -e "${RED}❌ Đã xảy ra lỗi! Vui lòng kiểm tra cấu hình Apache.${RESET}"
        exit 1
     fi
     systemctl reload apache2.service > /dev/null

}

main(){
    local domain 

    while true; do
        echo -e "\n${BLUE}=========================================================="
        echo "           🚫 CHƯƠNG TRÌNH XOÁ CẤU HÌNH VIRTUAL HOST"
        echo -e "==========================================================${RESET}"

        read -p "📋 Bạn có muốn xem danh sách các file cấu hình trước không? [y/N]: " choice
        if [[ "$choice" == [yY] ]]; then
            bash ./list_vhost.sh
        fi

        read -p "🌐 Nhập tên miền (domain) bạn muốn xoá: " domain
        if ! ./check_domain_exist.sh "$domain" ; then
            echo -e "${RED}❌ Domain ${domain} không tồn tại trên hệ thống!${RESET}"
            continue
        fi

        read -p "⚠️ Bạn có chắc chắn muốn xoá VirtualHost với domain ${domain}? [y/N]: " confirm
        if [[ "$confirm" == [yY] ]]; then
            delete_file_config "$domain"
            echo -e "${GREEN}✅ Đã xoá cấu hình VirtualHost cho ${domain}.${RESET}"
        else
            echo -e "${YELLOW}🔙 Huỷ thao tác xoá. Quay lại menu...${RESET}"
        fi

        read -p "🔁 Nhấn Enter để tiếp tục..."
    done
}

main
