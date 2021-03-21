#!/bin/bash

docker kill go_api_svc1

docker rm go_api_svc1

docker run \
      --name go_api_svc1 \
      --workdir /go/src \
      -v /opt/ubuntu/api/go/src:/go/src \
      -v /opt/ubuntu/api/go/bin:/go/bin \
      --env SWAGGER_HOST=$SWAGGER_HOST \
      --env SWAGGER_BASE_PATH=/ \
      --env TARGETOS=linux \
      --env TARGETARCH=amd64 \
      --env PRIVATE_IP=$PRIVATE_IP \
      --env PRIVATE_DNS=$PRIVATE_DNS \
      --env SECURITY_GROUP=$SECURITY_GROUP \
      --env AVAILABILITY_ZONE=$AVAILABILITY_ZONE \
      -p 3150:1323 \
      -d golang:1.16.2-buster go run .