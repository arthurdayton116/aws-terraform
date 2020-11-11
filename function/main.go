package main

import (
        "fmt"
        "github.com/aws/aws-lambda-go/lambda"
        "github.com/aws/aws-lambda-go/events"
)

type MyEvent struct {
        Name string `json:"What is your name?"`
        Age int     `json:"How old are you?"`
}

type MyResponse struct {
        Message string `json:"Answer:"`
}

//type APIGatewayProxyResponse struct {
//        StatusCode      int               `json:"statusCode"`
//        Headers         map[string]string `json:"headers"`
//        Body            string            `json:"body"`
//        IsBase64Encoded bool              `json:"isBase64Encoded,omitempty"`
//}

//type events.APIGatewayProxyRequest struct {
//        Resource              string                        `json:"resource"` // The resource path defined in API Gateway
//        Path                  string                        `json:"path"`     // The url path for the caller
//        HTTPMethod            string                        `json:"httpMethod"`
//        Headers               map[string]string             `json:"headers"`
//        QueryStringParameters map[string]string             `json:"queryStringParameters"`
//        PathParameters        map[string]string             `json:"pathParameters"`
//        StageVariables        map[string]string             `json:"stageVariables"`
//        RequestContext        APIGatewayProxyRequestContext `json:"requestContext"`
//        Body                  string                        `json:"body"`
//        IsBase64Encoded       bool                          `json:"isBase64Encoded,omitempty"`
//}
func HandleLambdaEvent(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
        //return MyResponse{Message: fmt.Sprintf("%s is %d years old!", event.Name, event.Age)}, nil
        return events.APIGatewayProxyResponse{
                StatusCode: 200,
                Body: fmt.Sprintf("%s is %d years old!","a",0),
        }, nil
}

func main() {
        lambda.Start(HandleLambdaEvent)
}