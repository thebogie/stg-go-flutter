package grapqhlconfig

import (
	gql "server/graphQL"
	graphqldirectives "server/graphQL/directives"
	graphqlresolvers "server/graphQL/resolvers"
)

/*
	Creates and returns the GraphQL configuration
*/
func GetConfig() gql.Config {
	config := gql.Config{Resolvers: &graphqlresolvers.Resolver{}}

	config.Directives.IsSignedIn = graphqldirectives.IsSignedIn

	return config
}
