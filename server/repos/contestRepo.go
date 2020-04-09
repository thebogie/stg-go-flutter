package repos

import (
	"context"
	//"errors"

	"encoding/json"
	"log"

	"github.com/thebogie/stg-go-flutter/config"
	"github.com/thebogie/stg-go-flutter/types"

	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// ContestRepo interface
type ContestRepo interface {
	AddContest(*types.Contest)
}

type contestRepo struct {
	dbconn       *mongo.Database
	dbCollection string
}

// NewContestRepo instantiates Contest Controller
func NewContestRepo(dbconn *mongo.Database, dbCollection string) ContestRepo {
	return &contestRepo{
		dbconn:       dbconn,
		dbCollection: dbCollection,
	}
}

// CreateNewContest is func adapter save record under database
func (c *contestRepo) AddContest(in *types.Contest) {

	//var createdDocument session.MongoDbDocument

	collection := c.dbconn.Collection(c.dbCollection)

	if in.Contestid == primitive.NilObjectID {
		in.Contestid = primitive.NewObjectID()
		_, err := collection.InsertOne(context.TODO(), in)

		if err != nil {
			log.Println("Failed to insert new contest with error:", err)
			return
		}
		log.Printf("AddContest: %+v\n", in)

		data, err := json.Marshal(in)
		if err != nil {
			log.Fatal(err)
		}

		config.ContestLogger.Printf("%s\n", data)

	}

	return
}
