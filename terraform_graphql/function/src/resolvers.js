var AWS = require("aws-sdk");
// Set the AWS Region.
AWS.config.update({ region: "us-east-1" });
var credentials = new AWS.SharedIniFileCredentials();
AWS.config.credentials = credentials;
// Create DynamoDB document client
var docClient = new AWS.DynamoDB.DocumentClient({apiVersion: '2012-08-10'});

var params = {
    TableName: 'sample-company-test',
    Key: {'TestTableHashKey': "7eaf9564-9142-4c97-9fd1-5841cf64664b"}
};


docClient.get(params, function(err, data) {
    if (err) {
        console.log("Error", err);
    } else {
        console.log("Success", data.Item);
    }
});

module.exports = {
    Query: {
        hello: () => "It Works! Dammit",
        // https://docs.aws.amazon.com/lambda/latest/dg/nodejs-context.html
        checkContext: (parent, args, context, info) => {
            console.log(parent)
            console.log(args)
            console.log(context)
            console.log(info)
            return {
                functionName: context.functionName,
                functionVersion: context.context.functionVersion,
                invokedFunctionArn: context.context.invokedFunctionArn,
                memoryLimitInMB: context.context.memoryLimitInMB,
                awsRequestId: context.context.awsRequestId,
                logGroupName: context.context.logGroupName,
                logStreamName: context.context.logStreamName
            }
        },
        comment: async () => {
            const { Item } = await docClient.get(params).promise()

                   console.log("Item", Item)
                    return {
                        postid: "1",
                        timestamp: Item.timestamp,
                        comment: Item.comment,
                        name: Item.name,
                        TestTableHashKey: Item.TestTableHashKey
                    }
        }
    },
    Mutation: {
        addComment:  (parent, args, context, info) => {
            console.log("args", args)
            return {
                postid: args.comment.postid,
                timestamp: args.comment.timestamp,
                comment: args.comment.comment,
                name: args.comment.name
            }
},
    },
}

