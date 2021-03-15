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
                  sudo chown -R ubuntu:ubuntu /opt/ubuntu

                  ### Enable firewall and open ports for Minecraft, SSH and Apache
                  # https://wiki.ubuntu.com/UncomplicatedFirewall
                  sudo ufw enable
                  sudo ufw allow 22/tcp
                  sudo ufw allow 80/tcp
                  sudo ufw allow 8080/tcp

                  cd /
                  sudo mkdir /var/www
                  sudo mkdir /var/www/html

                  sudo cp -R /tmp/build/* /var/www/html
                  sudo cp -R /tmp/dist/* /opt/ubuntu/api
                  sudo cp /tmp/dist/.babelrc /opt/ubuntu/api/.babelrc

                  instanceid="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"
                  publicip="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null)"
                  instancetype="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-type 2>/dev/null)"
                  securitygroups="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/security-groups 2>/dev/null)"

                  cd /var/www/html
                  sudo sed -i "s/localhost:3060/$publicip:8080/g" $(find . -type f)
                  cat /tmp/env_vars >> /etc/environment

                  ### Suppress overly verbose login screen - works on the 2nd login
                  touch /home/ubuntu/.hushlogin


                  ### Create service for autostart of Minecraft server whenever instance starts/reboots
                  sudo cp /home/ubuntu/nodeapi@.service /etc/systemd/system/nodeapi@.service
                  sudo systemctl start nodeapi@willmc
                  sudo systemctl status nodeapi@willmc
                  sudo systemctl enable nodeapi@willmc

                  ### Install apache for endpoint check and barf some simple HTML into an index file
                  apt-get install -y apache2
                  service start apache2
                  chkconfig apache2 on
                  sudo reboot
                  EOF
}
