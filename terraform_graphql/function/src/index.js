const { ApolloServer } = require('apollo-server-express');
const { ApolloServerPluginDrainHttpServer } = require('apollo-server-core');
const express = require( 'express');
const http = require( 'http');
const resolvers = require( './resolvers');
const typeDefs = require('./schema');

async function startApolloServer(typeDefs, resolvers) {
    const app = express();
    const httpServer = http.createServer(app);
    const server = new ApolloServer({
        typeDefs,
        resolvers,
        plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
    });
    await server.start();
    server.applyMiddleware({ app });
    await new Promise(resolve => httpServer.listen({ port: 4000 }, resolve));
    console.log(`🚀 Server ready at http://localhost:4000${server.graphqlPath}`);
}

startApolloServer(typeDefs, resolvers);

//
// curl --request POST \
//  --header 'content-type: application/json' \
//  --url 'https://zv22bezl0b.execute-api.us-east-1.amazonaws.com/dev_gql' \
//  --data '{"query":"query ExampleQuery {comment {comment, postid, timestamp, name, TestTableHashKey }}"}'
//
