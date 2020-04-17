package repos

import (
	"context"

	"github.com/thebogie/stg-go-flutter/config"
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
		config.Apex.Errorf("finding game by name %v", err)
		return
	}

	config.Apex.Infof("Found a single document: %+v", filter)
	return
}

// CreateNewUser is func adapter save record under database
func (g *gameRepo) AddGame(in *types.Game) {

	//var createdDocument session.MongoDbDocument

	collection := g.dbconn.Collection(g.dbCollection)
	g.FindGameByName(in)
	config.Apex.Debugf("Does it exist: %+v", in)
	if in.Gameid == primitive.NilObjectID {
		in.Gameid = primitive.NewObjectID()
		_, err := collection.InsertOne(context.TODO(), in)

		if err != nil {
			config.Apex.Errorf("Failed to insert new game with error: %v", err)
			return
		}
		config.Apex.Infof("AddGame: %+v", in)
	}
	return
}
