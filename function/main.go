package main

import (
	"context"
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/google/uuid"
	"log"
	"os"
	"strconv"
)

type envVars struct {
	Name  string `json:"name"`
	Value string `json:"value"`
}

type MyResponse struct {
	Message string `json:"Answer:"`
}

type basicEvent struct {
	Name string `json:"name"`
	Age  int    `json:"age"`
}

type basicResponse struct {
	Name    string    `json:"name"`
	Age     int       `json:"age"`
	Message string    `json:"message"`
	envVars []envVars `json:"envvars"`
}

type APIGatewayProxyResponse struct {
	StatusCode      int               `json:"statusCode"`
	Headers         map[string]string `json:"headers"`
	Body            string            `json:"body"`
	IsBase64Encoded bool              `json:"isBase64Encoded,omitempty"`
}

type APIGatewayProxyRequest struct {
	Resource              string                               `json:"resource"` // The resource path defined in API Gateway
	Path                  string                               `json:"path"`     // The url path for the caller
	HTTPMethod            string                               `json:"httpMethod"`
	Headers               map[string]string                    `json:"headers"`
	QueryStringParameters map[string]string                    `json:"queryStringParameters"`
	PathParameters        map[string]string                    `json:"pathParameters"`
	StageVariables        map[string]string                    `json:"stageVariables"`
	RequestContext        events.APIGatewayProxyRequestContext `json:"requestContext"`
	Body                  string                               `json:"body"`
	IsBase64Encoded       bool                                 `json:"isBase64Encoded,omitempty"`
}

type DbInput struct {
	TestTableHashKey string `dynamodbav:"TestTableHashKey"`
	One              string `dynamodbav:"one"`
	Two              string `dynamodbav:"two"`
}

func HandleLambdaEvent(ctx context.Context, req APIGatewayProxyRequest) (APIGatewayProxyResponse, error) {

	log.SetFlags(log.LstdFlags | log.Llongfile)

	log.Println(req)

	table := flag.String("t", "sample-company-test", "The name of the table")
	flag.Parse()

	log.Printf("table=%v\n", *table)

	if *table == "" {
		log.Println("You must specify a table name (-t TABLE)")
		return APIGatewayProxyResponse{
			StatusCode: 200,
			Body:       "Error",
		}, errors.New("You must specify a table name (-t TABLE)")
	}

	log.Println("Pos 1")
	// Use the SDK's default configuration.
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Printf("Config flamed=%v\n", err.Error())
		panic("unable to load SDK config, " + err.Error())
	}
	log.Println("Pos 2")
	// Create an Amazon DynamoDB client.
	client := dynamodb.NewFromConfig(cfg)

	// Build the input parameters for the request.
	input := &dynamodb.DescribeTableInput{
		TableName: table,
	}

	inputItem := &dynamodb.ScanInput{
		TableName: table,
	}

	respItem, err := GetItems(context.TODO(), client, inputItem)
	log.Println("Pos 3")
	items := []Item{}

	err = attributevalue.UnmarshalListOfMaps(respItem.Items, &items)
	log.Println("Pos 3.1")

	if err != nil {
		log.Printf("failed to unmarshal Dynamodb Scan Items, %v", err)
		panic(fmt.Sprintf("failed to unmarshal Dynamodb Scan Items, %v", err))
	}
	log.Println("Pos 4")
	for _, item := range items {

		log.Println("TestTableHashKey: ", item.TestTableHashKey)
		log.Println("One: ", item.One)
		log.Println("Two: ", item.Two)
		log.Println()

	}

	if err != nil {
		log.Println("Got an error scanning the table:")
		log.Println(err.Error())
		return APIGatewayProxyResponse{
			StatusCode: 200,
			Body:       "Error",
		}, errors.New("Got an error scanning the table")
	}

	resp, err := GetTableInfo(context.TODO(), client, input)
	if err != nil {
		panic("failed to describe table, " + err.Error())
	}

	log.Println("Info about " + *table + ":")
	log.Println("  #items:     ", resp.Table.ItemCount)
	log.Println("  Size (bytes)", resp.Table.TableSizeBytes)
	log.Println("  Status:     ", string(resp.Table.TableStatus))

	log.Printf("  CreateDateTime:     %v\n", resp.Table.CreationDateTime)
	log.Printf("  TableArn:     %v\n", *resp.Table.TableArn)

	//return MyResponse{Message: fmt.Sprintf("%s is %d years old!", event.Name, event.Age)}, nil
	parsedReq, _ := parseMessage(req.Body)

	stuff := DbInput{
		TestTableHashKey: uuid.New().String(),
		One:              parsedReq.Name,
		Two:              strconv.Itoa(parsedReq.Age),
	}

	av, _ := attributevalue.MarshalMap(stuff)

	putItem := &dynamodb.PutItemInput{
		Item:      av,
		TableName: table,
	}

	PutItems(context.TODO(), client, putItem)

	log.Printf("  parsedReq:     %v\n", parsedReq)

	envArr := []envVars{}
	envArr = append(envArr, envVars{"foo", os.Getenv("foo")})
	envArr = append(envArr, envVars{"please", os.Getenv("please")})

	respBody := basicResponse{
		Name:    parsedReq.Name,
		Age:     parsedReq.Age,
		Message: fmt.Sprintf("%s is %d years old!", parsedReq.Name, parsedReq.Age),
		envVars: envArr,
	}

	respBodyByte, _ := json.Marshal(respBody)
	return APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       string(respBodyByte),
	}, nil
}

//
//func main() {
//
//       lambda.Start(HandleLambdaEvent)
//}
//
func parseMessage(reqBody string) (*basicEvent, error) {
	log.Printf("reqBody = %v", reqBody)
	b := []byte(reqBody)
	var resp basicEvent
	err := json.Unmarshal(b, &resp)
	log.Printf("Parse = %v", b)
	if err == nil {
		log.Print(fmt.Sprintf("Account Name: [%s]", resp.Name))
	}

	return &resp, nil
}

// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX - License - Identifier: Apache - 2.0
//package main

// DynamoDBDescribeTableAPI defines the interface for the DescribeTable function.
// We use this interface to enable unit testing.
type DynamoDBDescribeTableAPI interface {
	DescribeTable(ctx context.Context,
		params *dynamodb.DescribeTableInput,
		optFns ...func(*dynamodb.Options)) (*dynamodb.DescribeTableOutput, error)
}

type DynamoDBScanAPI interface {
	Scan(ctx context.Context,
		params *dynamodb.ScanInput,
		optFns ...func(*dynamodb.Options)) (*dynamodb.ScanOutput, error)
}

type DynamoDBPutAPI interface {
	PutItem(ctx context.Context,
		params *dynamodb.PutItemInput,
		optFns ...func(*dynamodb.Options)) (*dynamodb.PutItemOutput, error)
}

type Item struct {
	TestTableHashKey string
	One              string
	Two              string
}

// GetTableInfo retrieves information about the table.
func GetTableInfo(c context.Context, api DynamoDBDescribeTableAPI, input *dynamodb.DescribeTableInput) (*dynamodb.DescribeTableOutput, error) {
	return api.DescribeTable(c, input)
}

func GetItems(c context.Context, api DynamoDBScanAPI, input *dynamodb.ScanInput) (*dynamodb.ScanOutput, error) {
	return api.Scan(c, input)
}

func PutItems(c context.Context, api DynamoDBPutAPI, input *dynamodb.PutItemInput) (*dynamodb.PutItemOutput, error) {
	return api.PutItem(c, input)
}

func main() {
	log.Println("Main")
	lambda.Start(HandleLambdaEvent)

}
