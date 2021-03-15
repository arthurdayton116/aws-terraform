variable "user_data_private" {
  description = "start up script for ec2 instance"
  default     = <<-EOF
                  #!/bin/sh
                  apt-get update -y
                  sudo apt  install awscli -y

                  sudo apt-get remove docker docker-engine docker.io containerd runc -y

                  sudo apt-get install \
                      apt-transport-https \
                      ca-certificates \
                      curl \
                      gnupg \
                      lsb-release -y

                  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

                  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                  sudo apt-get update -y
                  sudo apt-get install docker-ce docker-ce-cli containerd.io -y

                  sudo usermod -aG docker ubuntu

                  ### Suppress overly verbose login screen - works on the 2nd login
                  touch /home/ubuntu/.hushlogin

                  ### Create service for autostart of Minecraft server whenever instance starts/reboots
                  sudo cp /home/ubuntu/nodeapi@.service /etc/systemd/system/nodeapi@.service
                  sudo systemctl start nodeapi@willmc
                  sudo systemctl status nodeapi@willmc
                  sudo systemctl enable nodeapi@willmc



                  EOF
}
