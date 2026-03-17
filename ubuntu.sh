echo net.core.default_qdisc=fq >> /etc/sysctl.conf
echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
echo net.core.rmem_max=16777216 >> /etc/sysctl.conf
echo net.core.wmem_max=16777216 >> /etc/sysctl.conf
sysctl -p
apt install -y nginx
systemctl enable nginx
openssl genrsa -des3 -passout pass:123456 -out /etc/nginx/cert.key 2048
openssl req -passin pass:123456 -new -subj "/C=US/ST=WA/L=Oracle/O=Oracle/OU=Oracle/CN=cdn.oracle.com" -key /etc/nginx/cert.key -out /etc/nginx/cert.csr
mv /etc/nginx/cert.key /etc/nginx/cert.origin.key
openssl rsa -passin pass:123456 -in /etc/nginx/cert.origin.key -out /etc/nginx/cert.key
openssl x509 -req -days 18250 -in /etc/nginx/cert.csr -signkey /etc/nginx/cert.key -out /etc/nginx/cert.crt	
wget -P /etc/nginx/ -N --no-check-certificate http://raw.githubusercontent.com/maintell/vps/master/nginx/nginx.conf	
apt -y install unzip
wget -P /usr/share/nginx/html/ -N --no-check-certificate http://raw.githubusercontent.com/maintell/vps/master/nginx/docs.zip
unzip -o -q /usr/share/nginx/html/docs.zip -d /usr/share/nginx/html/	
systemctl restart nginx

bash <(curl -fsSL https://tcp.hy2.sh/)
bash <(curl -fsSL https://sing-box.app/deb-install.sh)
wget -N --no-check-certificate http://raw.githubusercontent.com/maintell/vps/master/singbox/config.json -O /etc/sing-box/config.json
systemctl enable sing-box
systemctl start sing-box
systemctl status sing-box 	

bash <(curl -fsSL https://get.hy2.sh/)
echo -e "${Info} hysteria正在生成证书中..."
openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name prime256v1) -keyout /etc/hysteria/server.key -out /etc/hysteria/server.crt -subj "/CN=bing.com" -days 36500
chown hysteria /etc/hysteria/server.key
chown hysteria /etc/hysteria/server.crt
echo -e "${Info}  hysteria服务使能..."
wget -N --no-check-certificate https://raw.githubusercontent.com/maintell/vps/master/hysteria/config.yaml -O /etc/hysteria/config.yaml
mkdir /etc/systemd/system/hysteria-server.service.d/
touch /etc/systemd/system/hysteria-server.service.d/priority.conf
echo "[Service]" >> /etc/systemd/system/hysteria-server.service.d/priority.conf
echo "CPUSchedulingPolicy=rr" >> /etc/systemd/system/hysteria-server.service.d/priority.conf 
echo "CPUSchedulingPriority=99" >> /etc/systemd/system/hysteria-server.service.d/priority.conf
systemctl daemon-reload
systemctl restart hysteria-server.service 
systemctl enable hysteria-server.service
systemctl start  hysteria-server.service

wget -N --no-check-certificate https://raw.githubusercontent.com/maintell/vps/master/hysteria/hysteria2 -O /usr/local/bin/hysteria2
chmod +x /usr/local/bin/hysteria2
cp /etc/systemd/system/hysteria-server.service /etc/systemd/system/hysteria2-server.service
sudo sed -i 's|ExecStart=/usr/local/bin/hysteria server --config /etc/hysteria/config.yaml|ExecStart=/usr/local/bin/hysteria2 server --config /etc/hysteria2/config.yaml|' /etc/systemd/system/hysteria2-server.service
mkdir -p /etc/hysteria2/
wget -N --no-check-certificate https://raw.githubusercontent.com/maintell/vps/master/hysteria/hysteria2.yaml -O /etc/hysteria2/config.yaml	
openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name prime256v1) -keyout /etc/hysteria2/server.key -out /etc/hysteria2/server.crt -subj "/CN=bing.com" -days 36500
chown hysteria /etc/hysteria2/server.key
chown hysteria /etc/hysteria2/server.crt
mkdir /etc/systemd/system/hysteria2-server.service.d/
touch /etc/systemd/system/hysteria2-server.service.d/priority.conf
echo "[Service]" >> /etc/systemd/system/hysteria2-server.service.d/priority.conf
echo "CPUSchedulingPolicy=rr" >> /etc/systemd/system/hysteria2-server.service.d/priority.conf 
echo "CPUSchedulingPriority=99" >> /etc/systemd/system/hysteria2-server.service.d/priority.conf
systemctl daemon-reload
systemctl restart hysteria2-server.service 
systemctl enable hysteria2-server.service
systemctl start  hysteria2-server.service
iptables -t nat -A PREROUTING -i eth0 -p udp --dport 35000:60000 -j REDIRECT --to-ports 32053
