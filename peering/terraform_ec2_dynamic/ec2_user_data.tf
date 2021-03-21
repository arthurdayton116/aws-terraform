

variable "user_data" {
  description = "start up script for ec2 instance"
  default     = <<-EOF
                  #!/bin/sh

                  # check logs
                  # /var/log/cloud-init.log and
                  # /var/log/cloud-init-output.log

                  ### Updates and installs
                  sudo apt-get update -y
                  sudo apt-get install wget screen default-jdk nmap  apt-transport-https ca-certificates curl gnupg lsb-release -y
                  sudo apt install awscli -y

                  sudo apt-get remove docker docker-engine docker.io containerd runc -y

                  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

                  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                  sudo apt-get update -y
                  sudo apt-get install docker-ce docker-ce-cli containerd.io -y

                  sudo usermod -aG docker ubuntu

                  ### Create directories for minecraft
                  sudo mkdir /opt/ubuntu
                  sudo mkdir /opt/ubuntu/api
                  sudo mkdir /opt/ubuntu/api/go
                  sudo chown -R ubuntu:ubuntu /opt/ubuntu
                  sudo chmod ugo+x /home/ubuntu/dockerStart.sh

                  instanceid="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"
                  publicip="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null)"
                  privateip="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null)"
                  instancetype="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-type 2>/dev/null)"
                  securitygroups="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/security-groups 2>/dev/null)"
                  localdns="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/local-hostname 2>/dev/null)"
                  availzone="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/placement/availability-zone 2>/dev/null)"

                  sudo echo "INSTANCE_ID=$instanceid" >> /etc/environment
                  sudo echo "PUBLIC_IP=$publicip" >> /etc/environment
                  sudo echo "PRIVATE_IP=$privateip" >> /etc/environment
                  sudo echo "INSTANCE_TYPE=$instance-type" >> /etc/environment
                  sudo echo "SECURITY_GROUP=$securitygroups" >> /etc/environment
                  sudo echo "PRIVATE_DNS=$localdns" >> /etc/environment
                  sudo echo "AVAILABILITY_ZONE=$availzone" >> /etc/environment
                  sudo echo "SWAGGER_HOST=$publicip:3150" >> /etc/environment
                  sudo echo "SWAGGER_HOST_PRIVATE=$privateip:3150" >> /etc/environment

                  ### Enable firewall and open ports for Minecraft, SSH and Apache
                  # https://wiki.ubuntu.com/UncomplicatedFirewall
                  sudo ufw enable
                  sudo ufw allow 22/tcp
                  sudo ufw allow 80/tcp
                  sudo ufw allow 8080/tcp
                  sudo ufw allow 3150/tcp

                  cd /
                  sudo mkdir /var/www
                  sudo mkdir /var/www/html

                  sudo cp -R /tmp/build/* /var/www/html
                  sudo cp -R /tmp/template-service-go/* /opt/ubuntu/api/go

                  cd /var/www/html
                  sudo sed -i "s/localhost:3060/$publicip:8080/g" $(find . -type f)
                  cat /tmp/env_vars >> /etc/environment

                  ### Suppress overly verbose login screen - works on the 2nd login
                  touch /home/ubuntu/.hushlogin


                  ### Create service for autostart of Minecraft server whenever instance starts/reboots
                  sudo cp /home/ubuntu/goapi@.service /etc/systemd/system/goapi@.service
                  sudo systemctl start goapi@willmc
                  sudo systemctl status goapi@willmc
                  sudo systemctl enable goapi@willmc

                  ### Install apache for endpoint check and barf some simple HTML into an index file
                  apt-get install -y apache2
                  service start apache2
                  chkconfig apache2 on
                  # sudo reboot
                  EOF
}
