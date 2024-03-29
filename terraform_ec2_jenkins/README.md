## Process to setup Jenkins Server with ELK stack

1. Run ``` terraform apply ``` in terraform_ec2_jenkins_vpc
1. Run ``` terraform apply ``` in terraform_ec2_jenkins

### Terraform output will produce links and commands

![Terraform Output](doc/TerraformOutput.png)

Wait about 5 minutes after successful Terraform Apply for installs to complete.

Then - Logon with public_ssh_link (aws security group rules should be scoped to local machine)

Get jenkins initial admin password with jenkins_admin_pw.

### Setup Jenkins

![Jenkins Admin Password](doc/JenkinsAdminPassword.png)

![Jenkins Default Plugins](doc/JenkinsDefaultPlugins.png)

### Confirm Logstash working
While you wait confirm logstash is running by clicking kibana_link

![Kibana](doc/Kibana.png)
Import the export.ndjson file and confirm indexes have been created
![Imported Objects](doc/importedObjects.png)

Go to discover and confirm data exists

![Discover Results](doc/DiscoverResults.png)

### Create Jenkins admin user

![Jenkins Create Admin User](doc/JenkinsCreateAdminUser.png)

### Install HTTP Request plugin

![Manage Jenkins](doc/ManageJenkins.png)

![HTTP Request Plugin](doc/HTTPRequestPlugin.png)

### Create and Run pipeline using Jenkinsfile

/files/Jenkinsfile

![Pipeline Setup](doc/PipelineSetup.png)

![Pipeline Job](doc/BuildJob.png)

### Confirm Import of Report Canvas To Kibana



Set auto refresh

![Auto Refresh](doc/autoRefresh.png)

### Run Build and Watch Results

![Run Build](doc/RunBuild.png)

Confirm Jenkins job started

![Build Started](doc/buildStartedDashboard.png)

Confirm Jenkins job completed

![Build Started](doc/buildFinishedDashboard.png)


#### Run Terraform Destroy to cleanup

``` terraform destroy ```

### Troubleshooting

See if logstash running ```curl http://localhost:9600```

Logstash logfiles ```cd /var/log/logstash```

Logstash logfiles ```tail -f -n 50 /var/log/logstash/logstash-plain.log```

Logstash input config files ```cd /etc/logstash/conf.d```

Logstash Install ```cd /usr/share/logstash```

Logstash Restart 

```
sudo service logstash start

ps aux | grep [l]ogstash

ps aux | grep [f]ilebeat

/usr/share/filebeat/bin/filebeat run -c /etc/filebeat/filebeat.yml

/usr/share/filebeat/bin/filebeat test config -c /etc/filebeat/filebeat.yml

tail -f -n 50 /var/log/filebeat/filebeat.log

sudo /usr/share/logstash/bin/logstash --config.test_and_exit -f /etc/logstash

kill -9 

tail -f -n 50 /var/log/jenkins/jenkins.log

```

vi /usr/share/logstash/Gemfile.lock 
search - /sinatra - should be 2.1

Logstash reinstall 

```
sudo apt-get remove logstash

sudo apt-get install logstash
```

Logstash http endpoint test message 

```
curl -H "content-type: application/json" -XPUT 'http://127.0.0.1:31311/jenkin-builds/' -d '{
"user": "thenewpne",
"run_date": "2022-02-26T15:15:15",
"message": "This is a test",
"durationString": "xxxx",
"absoluteUrl": "xxxxxx",
"startTimeInMillis": "12345",
"startTime": "xxxxx",
"BUILD_TAG": "xxxx"
}'
```

### Elastic SQL Snippets

```
POST _sql?format=txt
{
  "query": """
  SELECT status_msg FROM "jenkins*" where tags not in ('_grok_parse_failure')
  """
}

PUT dummy

curl -XPOST "http://localhost:9200/_search" -d'
  {
_sql?format=json
{
  "query": """
  SELECT parsed_json.run_status, status_message, parsed_json.build_start_time,parsed_json.build_end_time, parsed_json.build_duration_seconds FROM "jenkins*" where parsed_json.build_start_time is not null 
  """
}
  }'

POST _sql?format=json
{
  "query": """
  SHOW COLUMNS from "jenkins*"
  """
}
```