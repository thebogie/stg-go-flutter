package repos

import (
	"context"
	//"errors"

	"github.com/thebogie/stg-go-flutter/config"

	"github.com/thebogie/stg-go-flutter/types"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// UserRepo interface
type UserRepo interface {
	AddUser(*types.User)
	FindUserByUsername(*types.User) bool
}

type userRepo struct {
	dbconn       *mongo.Database
	dbCollection string
}

// NewUserRepo instantiates User Controller
func NewUserRepo(dbconn *mongo.Database, dbCollection string) UserRepo {
	return &userRepo{
		dbconn:       dbconn,
		dbCollection: dbCollection,
	}
}

// CreateNewUser is func adapter save record under database
func (u *userRepo) FindUserByUsername(filter *types.User) bool {

	collection := u.dbconn.Collection(u.dbCollection)

	err := collection.FindOne(context.TODO(), bson.M{"username": filter.Username}).Decode(&filter)
	if err != nil {
		config.Apex.Infof("%s", err)
		return false
	}

	if filter.Userid == primitive.NilObjectID {

		return false
	}

	config.Apex.Infof("%v", filter)

	return true
}

// CreateNewUser is func adapter save record under database
func (u *userRepo) AddUser(in *types.User) {

	//var createdDocument session.MongoDbDocument

	collection := u.dbconn.Collection(u.dbCollection)
	u.FindUserByUsername(in)
	config.Apex.Infof("Does it exist: %+v", in)
	if in.Userid == primitive.NilObjectID {
		in.Userid = primitive.NewObjectID()
		_, err := collection.InsertOne(context.TODO(), in)

		if err != nil {
			config.Apex.Errorf("Failed to insert new game with error: %v", err)
			return
		}
		config.Apex.Infof("AddUser: %+v", in)
	}
	return
}
