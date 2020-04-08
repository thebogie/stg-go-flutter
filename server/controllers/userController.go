package controllers

import (
	"github.com/gin-gonic/gin"
	"github.com/thebogie/stg-go-flutter/services"
	//"go.mongodb.org/mongo-driver/bson/primitive"
)

// UserController interface
type UserController interface {
	Register(*gin.Context)
}

type userController struct {
	us services.UserService
}

// NewUserController instantiates User Controller
func NewUserController(
	us services.UserService) UserController {
	return &userController{
		us: us,
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
func (ctl *userController) Register(*gin.Context) {
	//var turd primitive.ObjectID
	//ctl.us.GetByID(turd)

}
