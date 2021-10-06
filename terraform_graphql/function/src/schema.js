const { gql } = require('apollo-server');

const typeDefs = gql`
  type Query {
      hello: String
      checkContext: CheckContext
      comment: Comment
  }
  
  type Mutation {
      addComment(comment: NewComment) : Comment
  }
  
  type CheckContext {
      functionName: String
      functionVersion: String
      invokedFunctionArn: String
      memoryLimitInMB: String
      awsRequestId: String
      logGroupName: String
      logStreamName: String
  }

  type Comment {
      postid: String
      timestamp: String
      comment: String
      name: String
      TestTableHashKey: String
  }

  input NewComment {
      postid: String
      timestamp: String
      comment: String
      name: String
  }
`;

module.exports = typeDefs;
