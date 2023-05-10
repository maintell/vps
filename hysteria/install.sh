wget -N --no-check-certificate https://github.com/apernet/hysteria/releases/download/v1.3.4/hysteria-linux-amd64 -O /usr/local/bin/hysteria
chmod +x /usr/local/bin/hysteria
wget -N --no-check-certificate http://${github}/hysteria/configUDP.json -O /usr/local/etc/hysteria/configUDP.json
wget -N --no-check-certificate http://${github}/hysteria/configFakeTcp.json -O /usr/local/etc/hysteria/configFakeTcp.json
wget -N --no-check-certificate http://${github}/hysteria/HyUDP.service -O /etc/systemd/system/HyUDP.service
wget -N --no-check-certificate http://${github}/hysteria/hyFakeTcp.service -O /etc/systemd/system/hyFakeTcp.service
systemctl enable HyUDP.service
systemctl start  HyUDP.service
systemctl enable hyFakeTcp.service
systemctl start  hyFakeTcp.service
