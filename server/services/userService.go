package services

import (
	//"errors"

	"github.com/thebogie/stg-go-flutter/repos"
	"github.com/thebogie/stg-go-flutter/types"
)

// UserService interface
type UserService interface {
	GetByID(*types.User) (*types.User, error)
	GetByName(*types.User) (*types.User, error)
	AddUser(*types.User) (*types.User, error)
}

type userService struct {
	Repo repos.UserRepo
}

// NewUserService will instantiate User Service
func NewUserService(
	repo repos.UserRepo) UserService {

	return &userService{
		Repo: repo,
	}
}

func (us *userService) AddUser(in *types.User) (*types.User, error) {
	//if id == 0 {
	//	return nil, errors.New("id param is required")
	//}

	us.Repo.AddUser(in)

	return in, nil
}

func (us *userService) GetByID(in *types.User) (*types.User, error) {
	//if id == 0 {
	//	return nil, errors.New("id param is required")
	//}

	us.Repo.AddUser(in)

	return in, nil
}

func (us *userService) GetByName(in *types.User) (*types.User, error) {
	us.Repo.AddUser(in)

	return in, nil
}
