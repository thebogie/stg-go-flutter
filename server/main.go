package main

import (
	"fmt"
	gql "server/graphQL"
	grapqhlconfig "server/graphQL/configuration"
	"server/initialization"
	"server/keys"
	"server/middlewares"
	"log"
	"net/http"
	"time"

	"github.com/99designs/gqlgen/handler"
	"github.com/gorilla/mux"
	"github.com/gorilla/handlers"
)

var port = fmt.Sprintf(":%s", keys.GetKeys().PORT)
var router = mux.NewRouter()

/*
	Initializes environment variables and establishes
	a connection to MongoDB.
*/
func init() {
	initialization.InitEnv()
	initialization.InitDatabase()
}

func main() {
	router.Use(middlewares.VerifyJwt)

	router.Handle("/playground", handler.Playground("playground", "/graphql"))

	router.Handle("/graphql", handler.GraphQL(gql.NewExecutableSchema(grapqhlconfig.GetConfig())))

	srv := &http.Server{
		Addr:         port,
		Handler:      handlers.CORS()(router),
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 20 * time.Second,
	}

	log.Println("🆙 Server listening on port", port)

	srv.ListenAndServe()
}
