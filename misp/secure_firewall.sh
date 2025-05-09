#!/bin/bash

echo "🔧 อัปเดตระบบและติดตั้ง iptables พร้อม iptables-persistent..."
apt update
apt install -y iptables iptables-persistent

echo "🛑 ปิดและบล็อก UFW เพื่อไม่ให้รบกวน iptables..."
ufw disable
systemctl disable ufw
systemctl mask ufw

echo "🧹 ล้างกฎ iptables เดิม และตั้ง default policy ให้ปลอดภัย..."
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "✅ อนุญาต loopback และ connection ที่เริ่มจากเครื่องนี้"
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

echo "✅ อนุญาตพอร์ตที่จำเป็น (SSH, HTTP, HTTPS)"
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

echo "✅ อนุญาต MySQL (3306) จาก IP ที่กำหนดเท่านั้น"
iptables -A INPUT -s 172.19.111.85/32 -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -s 192.168.81.1/32 -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j DROP

echo "✅ อนุญาตให้ทุก IP ใช้ ICMP (ping)"
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

echo "✅ ปิดท้าย INPUT chain ด้วย DROP อย่างชัดเจน"
iptables -A INPUT -j DROP

echo "💾 บันทึกกฎ iptables ไว้ถาวร"
iptables-save > /etc/iptables/rules.v4
netfilter-persistent save
netfilter-persistent reload

echo "✅ การตั้งค่า iptables สำเร็จและบล็อก UFW เรียบร้อยแล้ว"
