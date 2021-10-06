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

type preEvent struct {
	Name      string          `json:"name"`
	Age       int             `json:"age"`
	Random    json.RawMessage `json:"random"`
	PostID    int             `json:"postid"`
	TimeStamp string          `json:"timestamp"`
	Comment   string          `json:"comment"`
}

type basicEvent struct {
	Name      string `json:"name"`
	Age       int    `json:"age"`
	Random    string `json:"random"`
	PostID    int    `json:"postid"`
	TimeStamp string `json:"timestamp"`
	Comment   string `json:"comment"`
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
	Random           string `dynamodbav:"random"`
	Name             string `dynamodbav:"name"`
	PostID           string `dynamodbav:"postid"`
	TimeStamp        string `dynamodbav:"timestamp"`
	Comment          string `dynamodbav:"comment"`
}

var (
	table   *string
	headers map[string]string
)

func init() {
	fmt.Println("This will get called on main initialization")
	table = flag.String("t", "sample-company-test", "The name of the table")
	flag.Parse()
	headers = make(map[string]string)
	headers["Access-Control-Allow-Headers"] = "Content-Type"
	headers["Access-Control-Allow-Origin"] = "*"
	headers["Access-Control-Allow-Methods"] = "OPTIONS,POST,GET"
}

func putDynamoDB(client *dynamodb.Client, req APIGatewayProxyRequest, table *string) (APIGatewayProxyResponse, error) {
	parsedReq, _ := parseMessage(req.Body)

	stuff := DbInput{
		TestTableHashKey: uuid.New().String(),
		One:              parsedReq.Name,
		Two:              strconv.Itoa(parsedReq.Age),
		Random:           parsedReq.Random,
		Name:             parsedReq.Name,
		PostID:           strconv.Itoa(parsedReq.PostID),
		Comment:          parsedReq.Comment,
		TimeStamp:        parsedReq.TimeStamp,
	}

	av, _ := attributevalue.MarshalMap(stuff)

	putItem := &dynamodb.PutItemInput{
		Item:      av,
		TableName: table,
	}

	dbResp, err := PutItems(context.TODO(), client, putItem)

	if err != nil {
		log.Printf("Db Put flamed=%v\n", err.Error())
		panic("Put splat" + err.Error())
	} else {
		log.Printf("Db Response=%v\n", dbResp)
	}

	envArr := []envVars{}
	envArr = append(envArr, envVars{"foo", os.Getenv("foo")})
	envArr = append(envArr, envVars{"please", os.Getenv("please")})

	respBody := basicResponse{
		Name:    parsedReq.Name,
		Age:     parsedReq.Age,
		Message: fmt.Sprintf("%s is %d years old!", parsedReq.Name, parsedReq.Age),
		envVars: envArr,
	}

	log.Printf("  parsedReq:     %v\n", parsedReq)

	respBodyByte, _ := json.Marshal(respBody)

	log.Printf("  respBodyByte:     %v\n", string(respBodyByte))

	return APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       string(respBodyByte),
		Headers:    headers,
	}, nil
}

// https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
func HandleLambdaEvent(ctx context.Context, req APIGatewayProxyRequest) (APIGatewayProxyResponse, error) {

	log.SetFlags(log.LstdFlags | log.Llongfile)

	if *table == "" {
		log.Println("You must specify a table name (-t TABLE)")
		return APIGatewayProxyResponse{
			StatusCode: 200,
			Body:       "Error",
			Headers:    headers,
		}, errors.New("You must specify a table name (-t TABLE)")
	}

	log.Printf("table=%v\n", *table)

	// Use the SDK's default configuration.
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		log.Printf("Config flamed=%v\n", err.Error())
		panic("unable to load SDK config, " + err.Error())
	}
	// Create an Amazon DynamoDB client.
	client := dynamodb.NewFromConfig(cfg)

	log.Printf("req.Path = %v \n", req.Path)
	log.Printf("req.HTTPMethod = %v \n", req.HTTPMethod)
	log.Printf("req.Body = %v \n", req.Body)

	switch req.HTTPMethod {
	case "OPTIONS":
		return APIGatewayProxyResponse{
			StatusCode: 200,
			Body:       "We Good",
			Headers:    headers,
		}, nil
	case "POST":
		log.Printf("case Post = %v \n", req.HTTPMethod)

		return putDynamoDB(client, req, table)

	case "GET":
		log.Printf("case Get = %v \n", req.HTTPMethod)

		items := []Item{}

		inputItem := &dynamodb.ScanInput{
			TableName: table,
		}

		respItem, err := GetItems(context.TODO(), client, inputItem)

		err = attributevalue.UnmarshalListOfMaps(respItem.Items, &items)

		if err != nil {
			log.Printf("failed to unmarshal Dynamodb Scan Items, %v", err)
			panic(fmt.Sprintf("failed to unmarshal Dynamodb Scan Items, %v", err))
		}

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
				Headers:    headers,
			}, errors.New("Got an error scanning the table")
		}

		// Build the input parameters for the request.
		input := &dynamodb.DescribeTableInput{
			TableName: table,
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

	default:
		log.Printf("Unrecognized method = %v \n", req.HTTPMethod)

		log.Printf("req.Path = %v \n", req.Path)
		log.Printf("req.HTTPMethod = %v \n", req.HTTPMethod)
		log.Printf("req.Body = %v \n", req.Body)

		return APIGatewayProxyResponse{
			StatusCode: 200,
			Body:       "Error",
			Headers:    headers,
		}, errors.New("Got an error in switch")
	}

	//return MyResponse{Message: fmt.Sprintf("%s is %d years old!", event.Name, event.Age)}, nil

	return APIGatewayProxyResponse{
		StatusCode: 418,
		Body:       "Not sure how it came to this",
		Headers:    headers,
	}, nil
}

// TODO: Why does is faceplant locally on second call?
func parseMessage(reqBody string) (*basicEvent, error) {
	log.Printf("reqBody = %v", reqBody)
	b := []byte(reqBody)
	var preResp preEvent
	var resp basicEvent
	err := json.Unmarshal(b, &preResp)

	resp.Name = preResp.Name
	resp.Age = preResp.Age
	resp.Random = string(preResp.Random)
	resp.PostID = preResp.PostID
	resp.TimeStamp = preResp.TimeStamp
	resp.Comment = preResp.Comment

	log.Printf("Parse = %v", string(b))
	log.Printf("preResp = %v", preResp)
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
