variable "user_data" {
  description = "start up script for ec2 instance"
  default     = <<-EOF
                  #!/bin/sh
                  apt-get update -y
                  sudo apt-get install wget screen default-jdk nmap -y
                  sudo apt  install awscli -y

                  sudo mkdir /opt/ubuntu
                  sudo mkdir /opt/ubuntu/willmc

                  sudo bash -c "echo eula=true > /opt/ubuntu/willmc/eula.txt"

                  sudo chown -R ubuntu /opt/ubuntu/willmc/

                  cp /home/ubuntu/mc_16_4_server.jar /opt/ubuntu/willmc/mc_16_4_server.jar

                  chmod uga+x /opt/ubuntu/willmc/mc_16_4_server.jar

                  sudo cp /home/ubuntu/minecraft@.service /etc/systemd/system/minecraft@.service


                  sudo systemctl start minecraft@willmc

                  sudo systemctl status minecraft@willmc

                  sudo systemctl enable minecraft@willmc

                  apt-get install -y apache2
                  service start apache2
                  chkonfig apache2 on
                  instanceid="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"
                  echo "<html>" > /var/www/html/index.html
                  echo "<h1>Welcome to Apache Web Server</h1>" >> /var/www/html/index.html
                  echo "<h2>Created using Terraform</h2>" >> /var/www/html/index.html
                  echo "<h4>Instance ID=$instanceid</h4>" >> /var/www/html/index.html
                  echo "</html>" >> /var/www/html/index.html
                  EOF
}
