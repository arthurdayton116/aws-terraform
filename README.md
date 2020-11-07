# aws-vpc

## Generate a key for ec2 instance
ssh-keygen -t rsa

## Login to ec2 instance
ssh -i ~/.ssh/id_rsa_ec2 ubuntu@54.245.155.241


## Fetch meta data
instanceid="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"
