package controllers

import (
	"encoding/json"
	"io/ioutil"

	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/thebogie/stg-go-flutter/config"
	"github.com/thebogie/stg-go-flutter/services"
	"github.com/thebogie/stg-go-flutter/types"
	//"go.mongodb.org/mongo-driver/bson/primitive"
)

// ContestController interface
type ContestController interface {
	UpdateContest(*gin.Context)
}

type contestController struct {
	us services.UserService
	cs services.ContestService
	gs services.GameService
	vs services.VenueService
}

// NewContestController instantiates User Controller
func NewContestController(
	us services.UserService,
	cs services.ContestService,
	gs services.GameService,
	vs services.VenueService) ContestController {
	return &contestController{
		us: us,
		cs: cs,
		gs: gs,
		vs: vs,
	}
}

// Contest : used to store each event with a list of outcomes, games played and the venue
type cargoContest struct {
	Start       time.Time    `json:"start" bson:"start"`
	Startoffset string       `json:"startoffset" bson:"startoffset"`
	Stop        time.Time    `json:"stop" bson:"stop"`
	Stopoffset  string       `json:"stopoffset" bson:"stopoffset"`
	Outcome     []cargoStats `json:"outcome" bson:"outcome"`
	Games       []string     `json:"games" bson:"games"`
	Venue       cargoVenue   `json:"venue" bson:"venue"`
}
type cargoVenue struct {
	Address string  `json:"address" bson:"address"`
	Lat     float64 `json:"lat,string" bson:"lat"`
	Lng     float64 `json:"lng,string" bson:"lng"`
}
type cargoGame struct {
	Published time.Time `json:"published" bson:"published"`
	Name      string    `json:"name" bson:"name"`
	BGGLink   string    `json:"BGGLink" bson:"bgglink"`
}
type cargoStats struct {
	Playerid string `json:"playerid" bson:"_id"`
	Place    int    `json:"place,string" bson:"place"`
	Result   string `json:"result" bson:"result"`
}

// @Summary Register new user
// @Produce  json
// @Param email body string true "Email"
// @Param password body string true "Password"
// @Success 200 {object} Response
// @Failure 400 {object} Response
// @Failure 500 {object} Response
// @Router /api/register [post]
func (ctl *contestController) UpdateContest(c *gin.Context) {
	//var cargo cargoContest
	var contest types.Contest
	var venue types.Venue

	var rawStrings map[string]interface{}

	//var jsonData map[string]interface{} // map[string]interface{}
	data, _ := ioutil.ReadAll(c.Request.Body)
	if e := json.Unmarshal(data, &rawStrings); e != nil {
		c.JSON(http.StatusBadRequest, gin.H{"msg": e.Error()})
		return
	}

	for key, value := range rawStrings {

		if key == "stopoffset" {
			contest.Stopoffset = value.(string)
		}
		if key == "stop" {
			stop, _ := time.Parse(
				"2006-01-02T15:04:05",
				value.(string))
			contest.Stop = stop
		}
		if key == "startoffset" {
			contest.Startoffset = value.(string)
		}
		if key == "start" {
			start, _ := time.Parse(
				"2006-01-02T15:04:05",
				value.(string))
			contest.Start = start
		}

		//TODO: need to add game service to find game and set it here
		if key == "outcome" {

			for _, b := range value.([]interface{}) {
				var stats types.Stats
				for c, d := range b.(map[string]interface{}) {
					if c == "place" {
						stats.Place, _ = strconv.Atoi(d.(string))
					}
					if c == "result" {
						stats.Result, _ = d.(string)
					}
					if c == "playerid" {
						var player types.User
						//var found *types.User
						//TODO: user doesnt exist... create user? throw failure to put in correct user
						player.Email = d.(string)
						ctl.us.GetUserByEmail(&player)
						stats.Playerid = player.Userid
					}
				}
				contest.Outcome = append(contest.Outcome, stats)
			}

		}

		//TODO: need to add venue service to find venue and set it here
		if key == "venue" {
			for vkey, vvalue := range value.(map[string]interface{}) {
				if vkey == "address" {
					venue.Address = vvalue.(string)
				}
				if vkey == "lat" {
					venue.Lat, _ = strconv.ParseFloat(vvalue.(string), 64)
				}
				if vkey == "lng" {
					venue.Lng, _ = strconv.ParseFloat(vvalue.(string), 64)
				}

			}

			addvenue, err := ctl.vs.AddVenue(&venue)
			if err != nil {
				config.Apex.Fatalf("add venue issue %v", err)
			}

			contest.Venue = addvenue.Venueid

		}
		//TODO: need to add game service to find game and set it here
		if key == "games" {
			for _, s := range value.([]interface{}) {
				var game types.Game

				game.Name = s.(string)

				addgame, err := ctl.gs.AddGame(&game)
				if err != nil {
					config.Apex.Fatalf("addgame issue %v", err)
				}

				contest.Games = append(contest.Games, addgame.Gameid)
			}
		}

	}

	ctl.cs.UpdateContest(&contest)

}
