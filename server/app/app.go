package app

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/thebogie/stg-go-flutter/config"
	"github.com/thebogie/stg-go-flutter/controllers"
	"github.com/thebogie/stg-go-flutter/db"
	"github.com/thebogie/stg-go-flutter/repos"
	"github.com/thebogie/stg-go-flutter/services"
)

var (
	router = gin.Default()
)

// Run is run
func Run() {

	/*
		====== Setup Database Domains ========
	*/
	dbc := db.InitDB()

	/*
		====== Setup repositories =======
	*/
	userRepo := repos.NewUserRepo(dbc, "users")
	contestRepo := repos.NewContestRepo(dbc, "contests")
	gameRepo := repos.NewGameRepo(dbc, "games")
	venueRepo := repos.NewVenueRepo(dbc, "venues")

	/*
		====== Setup services ===========
	*/
	userService := services.NewUserService(userRepo)
	contestService := services.NewContestService(contestRepo)
	gameService := services.NewGameService(gameRepo)
	venueService := services.NewVenueService(venueRepo)

	/*
		====== Setup controllers ========
	*/
	userCtl := controllers.NewUserController(userService)
	gameCtl := controllers.NewGameController(gameService)
	contestCtl := controllers.NewContestController(userService, contestService, gameService, venueService)

	/*
		====== Setup middlewares ========
	*/
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	/*
		====== Setup routes =============
	*/
	router.GET("/ping", func(c *gin.Context) { c.String(http.StatusOK, "pong") })

	api := router.Group("/api")

	//update or create
	api.POST("/register", userCtl.Register)
	api.POST("/login", userCtl.Login)
	api.POST("/contest", contestCtl.UpdateContest)
	api.POST("/game", gameCtl.UpdateGame)

	router.Run(config.Config.API.Port)
}
