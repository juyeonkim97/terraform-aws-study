Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//                                      
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//                                                                
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

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
instance_type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
echo "EC2 Instance Type : <span style='color:blue;'>$(echo $instance_type)</span>" > /var/www/html/index.html
--//--  