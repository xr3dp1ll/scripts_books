#!/bin/bash

echo "🔧 อัปเดตและติดตั้ง iptables + iptables-persistent..."
apt update
apt install -y iptables iptables-persistent

echo "🛑 ปิดและบล็อก UFW เพื่อไม่ให้รบกวน iptables..."
ufw disable
systemctl disable ufw
systemctl mask ufw

echo "🧹 ล้างกฎเดิมและตั้ง default policy..."
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "✅ อนุญาต loopback และ connection ที่เริ่มจากเครื่องนี้"
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

echo "✅ เปิด SSH, HTTP, HTTPS"
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

echo "✅ อนุญาต MySQL จาก IP ที่กำหนดเท่านั้น"
iptables -A INPUT -s 172.19.111.85/32 -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -s 192.168.81.1/32 -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j DROP

echo "✅ อนุญาต ping (ICMP) จากทุก IP"
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT

echo "✅ ปิดท้าย INPUT chain ด้วย DROP"
iptables -A INPUT -j DROP

echo "💾 บันทึกกฎ iptables ไปที่ /etc/iptables/rules.v4"
iptables-save > /etc/iptables/rules.v4

echo "🔁 โหลดกฎเข้า netfilter-persistent และเปิดใช้งานตอนบูต"
netfilter-persistent reload
netfilter-persistent save
systemctl enable netfilter-persistent

echo "🔍 ตรวจสอบสถานะ netfilter-persistent..."
systemctl status netfilter-persistent --no-pager

echo "✅ เสร็จสิ้น! ระบบ iptables ปลอดภัย และทำงานอัตโนมัติแล้ว"
