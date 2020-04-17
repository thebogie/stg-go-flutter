package repos

import (
	"context"

	"github.com/thebogie/stg-go-flutter/config"
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
		config.Apex.Warnf("find venue issue %v", err)
		return
	}

	config.Apex.Infof("Found a single document: %+v", filter)
	return
}

// CreateNewUser is func adapter save record under database
func (v *venueRepo) AddVenue(in *types.Venue) {

	//var createdDocument session.MongoDbDocument

	collection := v.dbconn.Collection(v.dbCollection)
	v.FindVenue(in)
	config.Apex.Debugf("Does it exist: %+v", in)
	if in.Venueid == primitive.NilObjectID {
		in.Venueid = primitive.NewObjectID()
		_, err := collection.InsertOne(context.TODO(), in)

		if err != nil {
			config.Apex.Errorf("Failed to insert new Venue with error:", err)
			return
		}
		config.Apex.Infof("AddVenue: %+v", in)
	}
	return
}
