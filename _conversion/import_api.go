package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"reflect"
	"strconv"
	"time"

	"../server/models"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func main() {

	timelayout := "2006-01-02T15:04:05-07:00"

	// set any variables
	req.Var("key", "value")

	// run it and capture the response
	var respData interface{}
	ctx := context.Background()
	if err := client.Run(ctx, req, &respData); err != nil {
		log.Fatal(err)
	}

	fmt.Println("CONTEST TO ADD: %v", respData)

	//timelayout := "2006-01-02T15:04:05-07:00"

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
			//importcontest.Contestname = getRandomContestName()

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

						//games = append(games, FindGameID(importgames))
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

					//importcontest.Venue = FindVenueID(importvenue)
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

								//
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
			//FindContestID(importcontest)

			//if false {
			//	fmt.Println("CONTEST TO ADD: %v", c)
			//}

		}

	}
}

//delete
