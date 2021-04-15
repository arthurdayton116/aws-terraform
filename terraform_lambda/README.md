# TODO - Under construction

## Fetch meta data
instanceid="$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"

## Lambda
https://docs.aws.amazon.com/lambda/latest/dg/lambda-golang.html

https://us-west-2.console.aws.amazon.com/xray/home?region=us-west-2#/getting-started

https://docs.aws.amazon.com/lambda/latest/dg/images-test.html

docker rm go_dynamo_db; docker run \
      --name go_dynamo_db \
      --workdir /go/src \
      -v `pwd`/function:/go/src \
      -v `pwd`/config:/root/.aws/config \
      -it golang:1.16.2-buster /bin/sh

# from function directory using Dockerfile
docker build -t testawsimage:local .

docker build -f Dockerfile.localbuild -t testawsimage:local .

docker rm testawsimage; docker run -p 9000:8080 \
  -v `pwd`/config:/root/.aws/config \
  testawsimage:local 
      
 curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"name":"hello world!", "age": 10}'
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 793219755011.dkr.ecr.us-west-2.amazonaws.com/sample-company-ecr   