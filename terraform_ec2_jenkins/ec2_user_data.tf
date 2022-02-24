variable "user_data" {
  description = "start up script for ec2 instance"
  default     = <<-EOF
                  #!/bin/sh

                  # check logs
                  # /var/log/cloud-init.log and
                  # /var/log/cloud-init-output.log

                  ### Updates and installs
                  sudo apt-get update -y
                  sudo apt install fontconfig openjdk-11-jre -y

                  sudo apt-get install wget curl -y
                  sudo apt install awscli -y

                  sudo apt install ca-certificates

                  curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh

                  sudo bash nodesource_setup.sh

                  sudo apt install nodejs -y

                  sudo apt install npm -y

                  sudo npm install yarn -g

                  sudo apt-get install apt-transport-https -y


                  #####################################
                  # https://logz.io/learn/complete-guide-elk-stack/#installing-elk
                  # https://souravatta.medium.com/monitor-jenkins-build-logs-using-elk-stack-697e13b78cb1
                  # jenkins - https://www.jenkins.io/doc/book/installing/linux/
                  #####################################

                  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
                    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

                  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                    /etc/apt/sources.list.d/jenkins.list > /dev/null

                  sudo apt-get update -y
                  sudo apt-get install jenkins -y

                  sudo systemctl enable jenkins

                  sudo systemctl start jenkins

                  sudo systemctl status jenkins

                  #####################################


                  #####################################
                  # elastic search
                  #####################################
                  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

                  echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

                  sudo apt-get update && sudo apt-get install elasticsearch

                  sudo mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.OLD
                  sudo mv /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options.OLD

                  sudo cp /home/ubuntu/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
                  sudo cp /home/ubuntu/jvm.options /etc/elasticsearch/jvm.options

                  #####################################
                  # logstash
                  #####################################
                  sudo apt-get install logstash

                  #####################################

                  #####################################
                  # kibana
                  #####################################
                  sudo apt-get install kibana

                  sudo mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml.OLD
                  sudo cp /home/ubuntu/kibana.yml /etc/kibana/kibana.yml

                  #####################################
                  # start
                  #####################################
                  sudo service elasticsearch start
                  sudo service kibana start

                  #####################################
                  # Filebeat & metricbeat
                  #####################################
                  sudo apt-get install filebeat -y
                  sudo apt-get install metricbeat -y

                  sudo systemctl enable metricbeat
                  sudo systemctl start metricbeat
                  sudo systemctl status metricbeat

                  sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.OLD
                  sudo cp /home/ubuntu/filebeat.yml /etc/filebeat/filebeat.yml

                  sudo cp /home/ubuntu/apache-01.conf /etc/logstash/conf.d/apache-01.conf
                  sudo cp /home/ubuntu/jenkins-01.conf /etc/logstash/conf.d/jenkins-01.conf

                  sudo service logstash start
                  sudo systemctl enable filebeat
                  sudo systemctl start filebeat
                  sudo systemctl status filebeat


                  ### Suppress overly verbose login screen - works on the 2nd login
                  touch /home/ubuntu/.hushlogin

                  EOF
}
