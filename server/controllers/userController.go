package controllers

import (
	"encoding/json"
	"io/ioutil"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/thebogie/stg-go-flutter/config"
	"github.com/thebogie/stg-go-flutter/services"
	"github.com/thebogie/stg-go-flutter/types"
	//"go.mongodb.org/mongo-driver/bson/primitive"
)

// UserController interface
type UserController interface {
	Register(*gin.Context)
	Login(*gin.Context)
}

type userController struct {
	us      services.UserService
	pwdhash types.PasswordConfig
}

// NewUserController instantiates User Controller
func NewUserController(
	us services.UserService) UserController {
	return &userController{
		us: us,
		pwdhash: types.PasswordConfig{
			config.Config.Password.Time,
			config.Config.Password.Memory,
			config.Config.Password.Threads,
			config.Config.Password.Keylen},
	}
}

// @Summary Register new user
// @Produce  json
// @Param email body string true "Email"
// @Param password body string true "Password"
// @Success 200 {object} Response
// @Failure 400 {object} Response
// @Failure 500 {object} Response
// @Router /api/register [post]
func (ctl *userController) Register(c *gin.Context) {
	var rawStrings map[string]interface{}
	var player types.User

	//var jsonData map[string]interface{} // map[string]interface{}
	data, _ := ioutil.ReadAll(c.Request.Body)
	if e := json.Unmarshal(data, &rawStrings); e != nil {
		c.JSON(http.StatusBadRequest, gin.H{"msg": e.Error()})
		return
	}

	for key, value := range rawStrings {

		config.Apex.Debugf("%q is a string: %q", key, value)

		if key == "email" {
			player.Email = value.(string)
		}
		if key == "password" {
			hashed, err := services.GeneratePassword(&ctl.pwdhash, value.(string))
			if err != nil {
				config.Apex.Errorf("%s", err)
				return
			}
			player.Password = hashed
		}

	}
	ctl.us.AddUser(&player)

}

func (ctl *userController) Login(c *gin.Context) {
	var rawStrings map[string]interface{}
	var player types.User
	var attemptedpassword string

	//var jsonData map[string]interface{} // map[string]interface{}
	data, _ := ioutil.ReadAll(c.Request.Body)
	if e := json.Unmarshal(data, &rawStrings); e != nil {
		c.JSON(http.StatusBadRequest, gin.H{"msg": e.Error()})
		return
	}

	for key, value := range rawStrings {

		//config.Apex.Infof("%q is a string: %q", key, value)

		if key == "email" {
			player.Email = value.(string)
		}
		if key == "password" {
			attemptedpassword = value.(string)

		}

	}

	ctl.us.GetUserByEmail(&player)

	match, err := services.ComparePassword(attemptedpassword, player.Password)
	if err != nil {
		config.Apex.Errorf("%s", err)

		return
	}
	if match == false {
		config.Apex.Warn("WRONG PASSWORD SEND BACK TO LOGIN OR REGIESTER")
		c.JSON(http.StatusUnauthorized, gin.H{"status": "unauthorized"})
		return
	}

	config.Apex.Infof("Logged in player:%+v", player)

}
