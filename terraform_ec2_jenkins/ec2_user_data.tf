variable "user_data" {
  description = "start up script for ec2 instance"
  default     = <<-EOF
                  #!/bin/sh

                  # to check logs of build look here
                  # /var/log/cloud-init.log and
                  # /var/log/cloud-init-output.log

                  ### Updates and installs
                  sudo apt-get update -y
                  #### JAVA
                  sudo apt install fontconfig openjdk-11-jre -y
                  ##### HTTP
                  sudo apt-get install wget curl -y
                  sudo apt install ca-certificates
                  #### AWS
                  sudo apt install awscli -y

                  #### Install node and npm and yarn - this is for build job of React
                  curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
                  sudo bash nodesource_setup.sh
                  sudo apt install nodejs -y
                  sudo apt install npm -y
                  sudo npm install yarn -g

                  #### For running stress test on machine
                  sudo apt-get install stress -y

                  #####################################
                  # https://logz.io/learn/complete-guide-elk-stack/#installing-elk - ELK STACK
                  # https://souravatta.medium.com/monitor-jenkins-build-logs-using-elk-stack-697e13b78cb1 - REFERENCE
                  # jenkins - https://www.jenkins.io/doc/book/installing/linux/ - JENKINS
                  #####################################

                  #### This is for fetching repositories
                  sudo apt-get install apt-transport-https -y

                  #### get signing key
                  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
                    /usr/share/keyrings/jenkins-keyring.asc > /dev/null

                  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
                    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                    /etc/apt/sources.list.d/jenkins.list > /dev/null

                  #### Install and setup Jenkins to autostart
                  sudo apt-get update -y
                  sudo apt-get install jenkins -y

                  sudo systemctl enable jenkins

                  sudo systemctl start jenkins

                  sudo systemctl status jenkins

                  #####################################


                  #####################################
                  # elastic search
                  #####################################
                  #### Key
                  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
                  #### Repo
                  echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

                  #### Install
                  sudo apt-get update && sudo apt-get install elasticsearch

                  #### Config files
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

                  #### Config files
                  sudo mv /etc/kibana/kibana.yml /etc/kibana/kibana.yml.OLD
                  sudo cp /home/ubuntu/kibana.yml /etc/kibana/kibana.yml

                  #####################################
                  # start services
                  #####################################
                  sudo service elasticsearch start
                  sudo service kibana start

                  #####################################
                  # Filebeat & metricbeat - not actually using filebeat at moment
                  #####################################
                  sudo apt-get install filebeat -y
                  sudo apt-get install metricbeat -y

                  #### Sets up monitoring for stack
                  sudo metricbeat modules enable elasticsearch-xpack
                  sudo metricbeat modules enable kibana-xpack
                  sudo metricbeat modules enable logstash-xpack
                  sudo metricbeat modules enable beat-xpack

                  sudo systemctl enable metricbeat
                  sudo systemctl start metricbeat
                  sudo systemctl status metricbeat

                  #### Config
                  sudo mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.OLD
                  sudo cp /home/ubuntu/filebeat.yml /etc/filebeat/filebeat.yml

                  #### Logstash configs
                  ##### File Example
                  sudo cp /home/ubuntu/apache-01.conf /etc/logstash/conf.d/apache-01.conf
                  ##### Setup for http input plugin so I can send messages to logstash endpoint
                  sudo cp /home/ubuntu/http.conf /etc/logstash/conf.d/http.conf

                  sudo cp /home/ubuntu/jenkins_build.conf /etc/logstash/conf.d/jenkins_build.conf

                  sudo mv /etc/logstash/pipelines.yml /etc/logstash/pipelines.yml.OLD
                  sudo cp /home/ubuntu/pipelines.yml /etc/logstash/pipelines.yml

                  #### Bug fix - https://github.com/elastic/logstash/issues/13777 - plugin install faceplants logstash because of bad upstream dependency
                  # sudo sed --in-place "s/gem.add_runtime_dependency \"sinatra\", '~> 2'/gem.add_runtime_dependency \"sinatra\", '~> 2.1.0'/g" /usr/share/logstash/logstash-core/logstash-core.gemspec
                  # sudo /usr/share/logstash/bin/ruby -S /usr/share/logstash/vendor/bundle/jruby/2.5.0/bin/bundle install

                  #### Startups
                  sudo service logstash start

                  sudo systemctl enable filebeat
                  sudo systemctl start filebeat
                  sudo systemctl status filebeat
                  sudo mkdir /etc/filebeat/inputs

                  #### This can be used to create index
                  # curl -X PUT "http://localhost:9200/jenkins?pretty"
                  #### This could be used to automate config on jenkins
                  #curl -v -d "script=$(cat /tmp/script.groovy)" --user username:ApiToken http://jenkins01.yourcompany.com:8080/scriptText

                  ### Suppress overly verbose login screen - works on the 2nd login
                  touch /home/ubuntu/.hushlogin

                  EOF
}
