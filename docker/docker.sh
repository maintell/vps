#!/bin/bash

# 安装Docker
install_docker() {
    echo "安装Docker..."
    yum update -y
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
    systemctl start docker
    systemctl enable docker
    echo "Docker安装完成."
}
# 安装Docker Compose
install_docker_compose() {
    echo "安装Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    echo "Docker Compose安装完成."
}

# 执行安装
install_docker
install_docker_compose
 
echo "docker一键安装完成."
