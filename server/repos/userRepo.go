package repos

import (
	"context"
	//"errors"
	"log"

	"github.com/thebogie/stg-go-flutter/types"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
)

// UserRepo interface
type UserRepo interface {
	AddUser(*types.User)
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
func (u *userRepo) FindUserByUsername(filter *types.User) {

	collection := u.dbconn.Collection(u.dbCollection)

	err := collection.FindOne(context.TODO(), bson.M{"username": filter.Username}).Decode(&filter)
	if err != nil {
		log.Println(err)
		return
	}

	log.Printf("Found a single document: %+v\n", filter)
	return
}

// CreateNewUser is func adapter save record under database
func (u *userRepo) AddUser(in *types.User) {

	//var createdDocument session.MongoDbDocument

	collection := u.dbconn.Collection(u.dbCollection)
	u.FindUserByUsername(in)
	log.Printf("Does it exist: %+v\n", in)
	if in.Userid == primitive.NilObjectID {
		in.Userid = primitive.NewObjectID()
		_, err := collection.InsertOne(context.TODO(), in)

		if err != nil {
			log.Println("Failed to insert new game with error:", err)
			return
		}
		log.Printf("AddUser: %+v\n", in)
	}
	return
}
