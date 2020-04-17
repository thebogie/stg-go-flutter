package types

import (
	"time"

	"go.mongodb.org/mongo-driver/bson/primitive"
	"gopkg.in/mgo.v2/bson"
)

// PasswordConfig is this
type PasswordConfig struct {
	Time    uint32
	Memory  uint32
	Threads uint8
	KeyLen  uint32
}

// User : player
type User struct {
	Userid    primitive.ObjectID `json:"_id" bson:"_id"`
	Email     string             `json:"email" bson:"email"`
	FirstName string             `json:"firstName" bson:"firstName"`
	LastName  string             `json:"lastName" bson:"lastName"`
	Password  string             `json:"password" bson:"password"`
	Birthdate time.Time          `json:"birthdate" bson:"birthdate"`
	Nickname  string             `json:"nickname" bson:"nickname"`
}

// Venue : place, result for each person playing
type Venue struct {
	Venueid primitive.ObjectID `json:"_id" bson:"_id"`
	Address string             `json:"address" bson:"address"`
	Lat     float64            `json:"lat" bson:"lat"`
	Lng     float64            `json:"lng" bson:"lng"`
}

// Glicko2 : glicko2 data for each match. To keep track of changes for trending
type Glicko2 struct {
	Playerid   primitive.ObjectID `json:"playerid"`
	Rating     float64            `json:"rating"`
	Deviation  float64            `json:"deviation"`
	Volatility float64            `json:"volatility"`
}

// Rating : each match played with glicko2 data
type Rating struct {
	Ratingid         primitive.ObjectID `json:"ratingid" `
	RatingDate       time.Time          `json:"ratingdate"`
	RatingDateOffset int                `json:"ratingdateoffset"`
	Ratings          []Glicko2          `json:"ratings"`
	//Contests         []Contest `json:"contests"`
}

// Game : place, result for each person playing
type Game struct {
	Gameid    primitive.ObjectID `json:"_id" bson:"_id"`
	Published time.Time          `json:"published" bson:"published"`
	Name      string             `json:"name" bson:"name"`
	BGGLink   string             `json:"BGGLink" bson:"bgglink"`
}

// Stats : place, result for each person playing
type Stats struct {
	Playerid primitive.ObjectID `json:"playerid" bson:"playerid"`
	Place    int                `json:"place" bson:"place"`
	Result   string             `json:"result" bson:"result"`
}

// Contest : used to store each event with a list of outcomes, games played and the venue
type Contest struct {
	Contestid   primitive.ObjectID   `json:"_id" bson:"_id"`
	Start       time.Time            `json:"start" bson:"start"`
	Startoffset string               `json:"startoffset" bson:"startoffset"`
	Stop        time.Time            `json:"stop" bson:"stop"`
	Stopoffset  string               `json:"stopoffset" bson:"stopoffset"`
	Contestname string               `json:"contestname" bson:"contestname"`
	Outcome     []Stats              `json:"outcome" bson:"outcome"`
	Games       []primitive.ObjectID `json:"games" bson:"games"`
	Venue       primitive.ObjectID   `json:"venue" bson:"venue"`
	Processed   bool                 `json:"processed" bson:"processed"`
}

// Product ..
type Product struct {
	ID                    bson.ObjectId `json:"_id,omitempty" bson:"_id,omitempty"`
	Name                  string        `json:"name" bson:"name" nosql:"name" validate:"required"`
	ImageClosed           string        `json:"image_closed" bson:"image_closed" validate:"required"`
	ImageOpen             string        `json:"image_open" bson:"image_open" validate:"required"`
	Description           string        `json:"description" bson:"description" validate:"required"`
	Story                 string        `json:"story" bson:"story" validate:"required"`
	SourcingValues        []string      `json:"sourcing_values" bson:"sourcing_values" validate:"required"`
	Ingredients           []string      `json:"ingredients" bson:"ingredients" validate:"required"`
	AllergyInfo           string        `json:"allergy_info" bson:"allergy_info" validate:"required"`
	DietaryCertifications string        `json:"dietary_certifications" bson:"dietary_certifications" validate:"required"`
	ProductID             string        `json:"product_id" bson:"product_id"`
	CreatedAt             time.Time     `json:"-" bson:"created_at"`
	UpdatedAt             time.Time     `json:"-" bson:"updated_at"`
	DeletedAt             *time.Time    `json:"-" bson:"deleted_at"`
}

// ProductUpdate ..
type ProductUpdate struct {
	ID                    bson.ObjectId `json:"_id,omitempty" bson:"_id,omitempty"`
	Name                  string        `json:"name" bson:"name" nosql:"name" validate:"-"`
	ImageClosed           string        `json:"image_closed" bson:"image_closed" nosql:"image_closed" validate:"-"`
	ImageOpen             string        `json:"image_open" bson:"image_open" nosql:"image_open" validate:"-"`
	Description           string        `json:"description" bson:"description" nosql:"description" validate:"-"`
	Story                 string        `json:"story" bson:"story" nosql:"story" validate:"-"`
	SourcingValues        []string      `json:"sourcing_values" bson:"sourcing_values" nosql:"sourcing_values" validate:"-"`
	Ingredients           []string      `json:"ingredients" bson:"ingredients" nosql:"ingredients" validate:"-"`
	AllergyInfo           string        `json:"allergy_info" bson:"allergy_info" nosql:"allergy_info" validate:"-"`
	DietaryCertifications string        `json:"dietary_certifications" bson:"dietary_certifications" nosql:"dietary_certifications" validate:"-"`
	ProductID             string        `json:"product_id" bson:"product_id"`
	CreatedAt             time.Time     `json:"-" bson:"created_at"`
	UpdatedAt             time.Time     `json:"-" bson:"updated_at"`
	DeletedAt             *time.Time    `json:"-" bson:"deleted_at"`
}
