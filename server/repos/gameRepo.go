package repos

import (
	"context"
	"log"

	"github.com/thebogie/stg-go-flutter/types"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// GameRepo interface
type GameRepo interface {
	FindGameByName(*types.Game)
	AddGame(in *types.Game)
}

type gameRepo struct {
	dbconn       *mongo.Database
	dbCollection string
}

// NewGameRepo instantiates User Controller
func NewGameRepo(dbconn *mongo.Database, dbCollection string) GameRepo {
	return &gameRepo{
		dbconn:       dbconn,
		dbCollection: dbCollection,
	}
}

// FindGameByName is func adapter save record under database
func (g *gameRepo) FindGameByName(filter *types.Game) {

	collection := g.dbconn.Collection(g.dbCollection)

	err := collection.FindOne(context.TODO(), bson.M{"name": filter.Name}).Decode(&filter)
	if err != nil {
		log.Println(err)
		return
	}

	log.Printf("Found a single document: %+v\n", filter)
	return
}

// CreateNewUser is func adapter save record under database
func (g *gameRepo) AddGame(in *types.Game) {

	//var createdDocument session.MongoDbDocument

	collection := g.dbconn.Collection(g.dbCollection)
	g.FindGameByName(in)
	log.Printf("Does it exist: %+v\n", in)
	if in.Gameid == primitive.NilObjectID {
		in.Gameid = primitive.NewObjectID()
		_, err := collection.InsertOne(context.TODO(), in)

		if err != nil {
			log.Println("Failed to insert new game with error:", err)
			return
		}
		log.Printf("AddGame: %+v\n", in)
	}
	return
}
