package services

import (
	"github.com/thebogie/stg-go-flutter/repos"
	"github.com/thebogie/stg-go-flutter/types"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

// GameService interface
type GameService interface {
	GetByID(id primitive.ObjectID) (*types.Game, error)
	GetByName(string) (*types.Game, error)
	AddGame(*types.Game) (*types.Game, error)
}

type gameService struct {
	Repo repos.GameRepo
}

// NewGameService will instantiate User Service
func NewGameService(
	repo repos.GameRepo) GameService {

	return &gameService{
		Repo: repo,
	}
}

func (gs *gameService) AddGame(in *types.Game) (*types.Game, error) {
	//if id == 0 {
	//	return nil, errors.New("id param is required")
	//}
	gs.Repo.AddGame(in)

	return in, nil
}

func (gs *gameService) GetByID(id primitive.ObjectID) (*types.Game, error) {
	//if id == 0 {
	//	return nil, errors.New("id param is required")
	//}
	var game types.Game

	return &game, nil
}

func (gs *gameService) GetByName(name string) (*types.Game, error) {
	//if id == 0 {
	//	return nil, errors.New("id param is required")
	//}
	var game types.Game

	//gs.Repo.FindGameByName

	return &game, nil
}
