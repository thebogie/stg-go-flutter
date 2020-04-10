package db

import (
	"context"
	"time"

	"github.com/thebogie/stg-go-flutter/config"

	"github.com/labstack/gommon/log"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

// InitDB instantiates User Controller
func InitDB() *mongo.Database {

	ctx, _ := context.WithTimeout(context.Background(), 10*time.Second)

	client, err := mongo.Connect(
		ctx,
		options.Client().ApplyURI(config.Config.Database.Address),
	)

	if err != nil {
		config.Apex.Fatalf("cant connect to Mongo %v", err)
	}

	failedConnection := client.Ping(ctx, readpref.Primary())

	if failedConnection != nil {
		config.Apex.Fatalf("❌", err)
	}

	log.Print("✅ Connection to MongoDB established")

	dbconn := client.Database(config.Config.Database.Database)

	return dbconn

}
