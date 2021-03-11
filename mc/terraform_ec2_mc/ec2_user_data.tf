locals {
  user_data = {
    description = "start up script for ec2 instance"
    default     = <<-EOF
                  #!/bin/sh

                  # check logs
                  # /var/log/cloud-init.log and
                  # /var/log/cloud-init-output.log

                  ### Updates and installs
                  sudo apt-get update -y
                  sudo apt-get install wget screen default-jdk nmap -y
                  sudo apt install awscli -y


                  ### Create directories for minecraft
                  sudo mkdir /opt/ubuntu
                  sudo mkdir /opt/ubuntu/willmc
                  sudo chown -R ubuntu:ubuntu /opt/ubuntu

                  ### Check if our bucket has anything in it
                  list=$(aws s3 ls s3://${local.s3_bucket_name}/mcBackup/)

                  ### If it does sync it to our EC2 instance and delete any lock files else do first time setup
                  if echo $list |grep -wc "world/" ; then
                      aws s3 sync s3://${local.s3_bucket_name}/mcBackup /opt/ubuntu/willmc
                      sudo rm -f /opt/ubuntu/willmcworld/session.lock
                  else
                      ## Sets eula for minecraft
                      sudo bash -c "echo eula=true > /opt/ubuntu/willmc/eula.txt"
                      ## Copy minecraft jar to run directory
                      cp /home/ubuntu/mc_16_4_server.jar /opt/ubuntu/willmc/mc_16_4_server.jar
                  fi

                  ### Make sure Ubuntu user owns it
                  sudo chown -R ubuntu:ubuntu /opt/ubuntu/willmc/

                  ### Create shutdown script that will sync results of kiddies changes to their world back to S3
                  echo "aws s3 sync /opt/ubuntu/willmc s3://${local.s3_bucket_name}/mcBackup" > /opt/ubuntu/willmc/shutdown.sh
                  sudo chmod uga+x /opt/ubuntu/willmc/shutdown.sh

                  ### Make sure it is executable
                  chmod uga+x /opt/ubuntu/willmc/mc_16_4_server.jar

                  ### Create service for autostart of Minecraft server whenever instance starts/reboots
                  sudo cp /home/ubuntu/minecraft@.service /etc/systemd/system/minecraft@.service
                  sudo systemctl start minecraft@willmc
                  sudo systemctl status minecraft@willmc
                  sudo systemctl enable minecraft@willmc

                  ### Enable firewall and open ports for Minecraft, SSH and Apache
                  # https://wiki.ubuntu.com/UncomplicatedFirewall
                  sudo ufw enable
                  sudo ufw allow 25565/tcp
                  sudo ufw allow 22/tcp
                  sudo ufw allow 80/tcp

                  ### Suppress overly verbose login screen - works on the 2nd login
                  touch /home/ubuntu/.hushlogin

                  ### Install apache for endpoint check and barf some simple HTML into an index file
                  apt-get install -y apache2
                  service start apache2
                  chkconfig apache2 on
                  instanceid="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"
                  echo "<html>" > /var/www/html/index.html
                  echo "<h1>Welcome to Apache Web Server</h1>" >> /var/www/html/index.html
                  echo "<h2>Created using Terraform</h2>" >> /var/www/html/index.html
                  echo "<h4>Instance ID=$instanceid</h4>" >> /var/www/html/index.html
                  echo "</html>" >> /var/www/html/index.html
                  EOF
  }
}
