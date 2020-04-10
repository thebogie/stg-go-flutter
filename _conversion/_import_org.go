package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"reflect"
	"stg/api/models"
	"strconv"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"golang.org/x/crypto/bcrypt"
)

func connectToDB() (db *mongo.Client) {

	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017")
	// Connect to MongoDB
	db, err := mongo.Connect(context.TODO(), clientOptions)

	if err != nil {
		config.Apex.Fatal(err)
	}

	// Check the connection
	err = db.Ping(context.TODO(), nil)

	if err != nil {
		config.Apex.Fatal(err)
	}

	fmt.Println("Connected to MongoDB!")

	//defer db.Disconnect(context.TODO())

	//fmt.Println("Connection to MongoDB closed.")
	return db
}

//if username doesnt exist, add it
func FindPlayerID(username string) primitive.ObjectID {
	retval := primitive.NilObjectID

	hash, err := bcrypt.GenerateFromPassword([]byte("letmein"), 5)
	if err != nil {
		fmt.Println("FAILED HASH?")
		return retval
	}
	find := (&models.User{
		Username:          username,
		Email:             username + "@gmail.com",
		Password:          string(hash),
		Firstname:         username,
		Lastname:          username,
		Timestampmodified: time.Now(),
		Nickname:          username,
	}).New()

	db := connectToDB()
	defer db.Disconnect(context.TODO())
	coll := db.Database("stgdata").Collection("users")
	filter := bson.D{{"username", username}}

	err = coll.FindOne(context.TODO(), filter).Decode(&find)
	if err == nil {
		fmt.Printf("Already exists %+v\n", find.Username)
		db.Disconnect(context.TODO())
		return find.Userid
	}

	fmt.Println("user to add", find)

	_, err = coll.InsertOne(context.Background(), find)

	retval = find.Userid
	db.Disconnect(context.TODO())
	return retval

}

//if game doesnt exist, add it
func FindGameID(g *models.Game) primitive.ObjectID {
	retval := primitive.NilObjectID

	db := connectToDB()
	defer db.Disconnect(context.TODO())
	coll := db.Database("stgdata").Collection("games")
	filter := bson.D{{"name", g.Name}}

	err := coll.FindOne(context.TODO(), filter).Decode(&g)
	if err == nil {
		fmt.Printf("Already exists %+v\n", g)

		return g.Gameid
	}

	fmt.Println("game to add", g)

	_, err = coll.InsertOne(context.Background(), g)

	retval = g.Gameid

	return retval

}

func FindContestID(c *models.Contest) primitive.ObjectID {
	retval := primitive.NilObjectID

	db := connectToDB()
	defer db.Disconnect(context.TODO())
	coll := db.Database("stgdata").Collection("contests")
	filter := bson.D{{"contestname", c.Contestname}}

	err := coll.FindOne(context.TODO(), filter).Decode(&c)
	if err == nil {
		fmt.Printf("Already exists %+v\n", c)
		return c.Contestid
	}

	fmt.Println("contest to add", c)

	_, err = coll.InsertOne(context.Background(), c)

	retval = c.Contestid
	return retval

}

//if venue doesnt exist, add it
func FindVenueID(v *models.Venue) primitive.ObjectID {
	retval := primitive.NilObjectID

	db := connectToDB()
	defer db.Disconnect(context.TODO())
	coll := db.Database("stgdata").Collection("venues")
	filter := bson.D{{"address", v.Address}}

	err := coll.FindOne(context.TODO(), filter).Decode(&v)
	if err == nil {
		fmt.Printf("Already exists %+v\n", v)
		return v.Venueid
	}

	fmt.Println("venue to add", v)

	_, err = coll.InsertOne(context.Background(), v)

	retval = v.Venueid
	return retval

}

func getRandomContestName() (contestname string) {

	var wordnik struct {
		Id   string `json:"id"`
		Word string `json:"word"`
	}

	contestname = "The "

	adj, err := http.Get("http://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&includePartOfSpeech=adjective&api_key=fe48869d95274080a130207a25202ab0de9f5a79720597c74")
	if err != nil {
		config.Apex.Fatal(err)
	}

	defer adj.Body.Close()

	json.NewDecoder(adj.Body).Decode(&wordnik)
	contestname = contestname + string(wordnik.Word)

	noun, err := http.Get("http://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&includePartOfSpeech=noun&api_key=fe48869d95274080a130207a25202ab0de9f5a79720597c74")
	if err != nil {
		config.Apex.Fatal(err)
	}

	defer noun.Body.Close()

	json.NewDecoder(noun.Body).Decode(&wordnik)
	contestname = contestname + " " + string(wordnik.Word)

	return contestname
}

func main() {

	timelayout := "2006-01-02T15:04:05-07:00"

	// Open our jsonFile
	jsonFile, err := os.Open("stg_records.json")
	// if we os.Open returns an error then handle it
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Successfully Opened stg_records.json")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)

	var result map[string]interface{}
	json.Unmarshal([]byte(byteValue), &result)

	//JSON
	for _, a := range result {

		//contests
		for _, c := range a.([]interface{}) {

			//contest

			importcontest := (&models.Contest{}).New()
			importcontest.Contestname = getRandomContestName()

			var startstr, stopstr string
			for d, e := range c.(map[string]interface{}) {

				//fmt.Println("d=", d)
				//fmt.Println("e=", e)
				if d == "start" {

					startstr = e.(string)

				}
				if d == "stop" {

					stopstr = e.(string)

				}
				if d == "startoffset" {

					t, err := time.Parse(timelayout, startstr+e.(string))
					if err != nil {
						fmt.Println("WRONG FORMAT FOR TIME", err)
					}
					importcontest.Start = t
					importcontest.Startoffset = e.(string)
				}
				if d == "stopoffset" {

					t, err := time.Parse(timelayout, stopstr+e.(string))
					if err != nil {
						fmt.Println("WRONG FORMAT FOR TIME", err)
					}
					importcontest.Stop = t
					importcontest.Stopoffset = e.(string)
				}

				//GAMES
				if d == "games" {

					games := []primitive.ObjectID{}
					for _, v := range e.([]interface{}) {

						importgames := (&models.Game{}).New()

						importgames.Name = v.(string)

						games = append(games, FindGameID(importgames))
					}
					importcontest.Games = games
				}

				//VENUE
				if d == "venue" {

					importvenue := (&models.Venue{}).New()

					for k, v := range e.(map[string]interface{}) {

						if k == "address" {
							importvenue.Address = v.(string)
						}
						if k == "lat" {
							importvenue.Lat, _ = strconv.ParseFloat(v.(string), 64)
						}
						if k == "lng" {
							importvenue.Lng, _ = strconv.ParseFloat(v.(string), 64)
						}
					}

					importcontest.Venue = FindVenueID(importvenue)
				}

				//OUTCOME
				if d == "outcome" {
					outcomes := []models.Stats{}

					for _, g := range e.([]interface{}) {

						importoutcome := (&models.Stats{}).New()

						v := reflect.ValueOf(g)
						for _, key := range v.MapKeys() {
							strct := v.MapIndex(key)

							if key.Interface() == "playerid" {
								//fmt.Println("playerid:", strct.Interface().(string))

								importoutcome.Playerid = FindPlayerID(strct.Interface().(string))

							}
							if key.Interface() == "place" {
								//fmt.Println("playerid:", strct.Interface().(string))

								i, _ := strconv.Atoi(strct.Interface().(string))
								importoutcome.Place = i

							}
							if key.Interface() == "result" {
								//fmt.Println("playerid:", strct.Interface().(string))

								importoutcome.Result = strct.Interface().(string)
							}

						}
						outcomes = append(outcomes, *importoutcome)
					}
					importcontest.Outcome = outcomes
				}

			}
			fmt.Println("CONTEST TO ADD:", importcontest)
			FindContestID(importcontest)
		}

	}
}

//delete
