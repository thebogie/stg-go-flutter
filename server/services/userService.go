package services

import (
	//"errors"

	"github.com/thebogie/stg-go-flutter/config"
	"github.com/thebogie/stg-go-flutter/repos"
	"github.com/thebogie/stg-go-flutter/types"
)

// UserService interface
type UserService interface {
	GetUserByID(*types.User) (*types.User, error)
	GetUserByEmail(*types.User) bool
	AddUser(*types.User)
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

func (us *userService) AddUser(in *types.User) {

	if !us.GetUserByEmail(in) {
		us.Repo.AddUser(in)
	} else {
		config.Apex.Infof("User already exists: %+v", in)
	}

	return
}

func (us *userService) GetUserByID(in *types.User) (*types.User, error) {
	//if id == 0 {
	//	return nil, errors.New("id param is required")
	//}

	us.Repo.AddUser(in)

	return in, nil
}

func (us *userService) GetUserByEmail(in *types.User) bool {

	return us.Repo.FindUserByEmail(in)
}
