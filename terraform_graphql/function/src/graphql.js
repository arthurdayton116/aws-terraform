// graphql.js

const { ApolloServer } = require('apollo-server-lambda');
const typeDefs = require('./schema');
const resolvers = require( './resolvers');

// Construct a schema, using GraphQL schema language
// const typeDefs = gql`
//   type Query {
//     hello: String
//   }
// `;

// Provide resolver functions for your schema fields
// const resolvers = {
//     Query: {
//         CheckContext: (parent, args, context, info) => {
//             console.log(parent)
//             console.log(args)
//             console.log(context)
//             console.log(info)
//             return context
//         },
//     },
// };

const server = new ApolloServer({
    typeDefs,
    resolvers,
    context: ({ event, context, express }) => ({
        headers: event.headers,
        functionName: context.functionName,
        event,
        context,
        expressRequest: express.req,
    }),
});

exports.graphqlHandler = server.createHandler();

