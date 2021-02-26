variable "user_data_private" {
  description = "start up script for ec2 instance"
  default     = <<-EOF
                  #!/bin/sh
                  apt-get update -y
                  sudo apt  install awscli -y
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
