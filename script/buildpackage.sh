#!/bin/bash
cd ../function
GOOS=linux go build main.go
GOOS=darwin go build -o local main.go
zip function.zip main