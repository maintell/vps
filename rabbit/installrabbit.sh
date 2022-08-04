#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

github="raw.githubusercontent.com/maintell/vps/master"

wget -N --no-check-certificate http://${github}/rabbit/rabbit-linux-amd64 -O /usr/local/bin/rabbit-linux-amd64
wget -N --no-check-certificate http://${github}/rabbit/rabbit.service -O /etc/systemd/system/rabbit.service

chmod +x /usr/local/bin/rabbit-linux-amd64

systemctl enable rabbit.service
systemctl start rabbit.service
