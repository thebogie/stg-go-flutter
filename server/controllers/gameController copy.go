package controllers

import (
	"github.com/gin-gonic/gin"
	"github.com/thebogie/stg-go-flutter/services"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// GameController interface
type GameController interface {
	UpdateGame(*gin.Context)
}

type gameController struct {
	gs services.GameService
}

// NewGameController instantiates User Controller
func NewGameController(
	gs services.GameService) GameController {
	return &gameController{
		gs: gs,
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
func (ctl *gameController) UpdateGame(*gin.Context) {
	var turd primitive.ObjectID
	ctl.gs.GetByID(turd)

}
