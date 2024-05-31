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
	bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root	
	wget -O "/usr/local/share/xray/geosite.dat" https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
	wget -O "/usr/local/share/xray/geoip.dat" https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
	wget -P /usr/local/etc/xray/ -N --no-check-certificate http://raw.githubusercontent.com/maintell/vps/master/v2/config.json
	systemctl enable xray
	systemctl restart xray
	bash <(curl -fsSL https://get.hy2.sh/)
  openssl req -x509 -nodes -newkey ec:<(openssl ecparam -name prime256v1) -keyout /etc/hysteria/server.key -out /etc/hysteria/server.crt -subj "/CN=bing.com" -days 36500
	chown hysteria /etc/hysteria/server.key
  chown hysteria /etc/hysteria/server.crt
  wget -N --no-check-certificate http://raw.githubusercontent.com/maintell/vps/master/hysteria/config.yaml -O /etc/hysteria/config.yaml
	systemctl enable hysteria-server.service
	systemctl start  hysteria-server.service
	systemctl status  hysteria-server.service
