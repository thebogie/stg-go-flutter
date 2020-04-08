package repos

import (
	"context"
	"log"

	"github.com/thebogie/stg-go-flutter/types"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// VenueRepo interface
type VenueRepo interface {
	FindVenue(*types.Venue)
	AddVenue(in *types.Venue)
}

type venueRepo struct {
	dbconn       *mongo.Database
	dbCollection string
}

// NewVenueRepo instantiates User Controller
func NewVenueRepo(dbconn *mongo.Database, dbCollection string) VenueRepo {
	return &venueRepo{
		dbconn:       dbconn,
		dbCollection: dbCollection,
	}
}

// FindVenueByName is func adapter save record under database
func (v *venueRepo) FindVenue(filter *types.Venue) {

	collection := v.dbconn.Collection(v.dbCollection)

	err := collection.FindOne(context.TODO(), bson.M{"address": filter.Address}).Decode(&filter)
	if err != nil {
		log.Println(err)
		return
	}

	log.Printf("Found a single document: %+v\n", filter)
	return
}

// CreateNewUser is func adapter save record under database
func (v *venueRepo) AddVenue(in *types.Venue) {

	//var createdDocument session.MongoDbDocument

	collection := v.dbconn.Collection(v.dbCollection)
	v.FindVenue(in)
	log.Printf("Does it exist: %+v\n", in)
	if in.Venueid == primitive.NilObjectID {
		in.Venueid = primitive.NewObjectID()
		_, err := collection.InsertOne(context.TODO(), in)

		if err != nil {
			log.Println("Failed to insert new Venue with error:", err)
			return
		}
		log.Printf("AddVenue: %+v\n", in)
	}
	return
}
