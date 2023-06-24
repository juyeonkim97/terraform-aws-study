#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 168.126.63.1" >> /etc/resolv.conf
echo "nameserver 210.220.163.82" >> /etc/resolv.conf
echo "nameserver 164.124.101.2" >> /etc/resolv.conf
sudo yum update -y
sudo yum install -y httpd.x86_64
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
availability_zone=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "Availability Zone : <span style='color:blue;'>$(echo $availability_zone)</span>" > /var/www/html/index.html
