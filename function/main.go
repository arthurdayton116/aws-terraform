package main

import (
        "context"
        "encoding/json"
        "fmt"
        "github.com/aws/aws-lambda-go/events"
        "github.com/aws/aws-lambda-go/lambda"
        "log"
        "os"
)

type envVars struct {
        Name string `json:"name"`
        Value string     `json:"value"`
}

type MyResponse struct {
        Message string `json:"Answer:"`
}

type basicEvent struct {
        Name string `json:"name"`
        Age int     `json:"age"`
}

type basicResponse struct {
        Name string `json:"name"`
        Age int     `json:"age"`
        Message string `json:"message"`
        envVars []envVars `json:"envvars"`
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

func HandleLambdaEvent(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
        //return MyResponse{Message: fmt.Sprintf("%s is %d years old!", event.Name, event.Age)}, nil
        parsedReq, _ := parseMessage(req.Body)

        envArr := []envVars{}
        envArr = append(envArr,envVars{"foo", os.Getenv("foo")})
        envArr = append(envArr,envVars{"please", os.Getenv("please")})

        respBody := basicResponse{
                Name:    parsedReq.Name,
                Age:     parsedReq.Age,
                Message: fmt.Sprintf("%s is %d years old!",parsedReq.Name,parsedReq.Age),
                envVars: envArr,
        }

        respBodyByte, _ := json.Marshal(respBody)
        return events.APIGatewayProxyResponse{
                StatusCode: 200,
                Body: string(respBodyByte),
        }, nil
}

func main() {
        lambda.Start(HandleLambdaEvent)
}

func parseMessage(reqBody string)(*basicEvent, error){
        b := []byte(reqBody)
        var resp basicEvent
        err := json.Unmarshal(b, &resp)
        if err == nil {
                log.Print(fmt.Sprintf("Account Name: [%s]", resp.Name))
        }
        return &resp, nil
}