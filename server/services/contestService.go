package services

import (
	"github.com/thebogie/stg-go-flutter/repos"
	"github.com/thebogie/stg-go-flutter/types"
)

// ContestService interface
type ContestService interface {
	UpdateContest(*types.Contest) (string, error)
}

type contestService struct {
	Repo repos.ContestRepo
}

// NewContestService will instantiate User Service
func NewContestService(
	repo repos.ContestRepo) ContestService {

	return &contestService{
		Repo: repo,
	}
}

func (cs *contestService) UpdateContest(contest *types.Contest) (string, error) {
	var retVal string

	contestname, err := cs.inventcontestname()

	if err != nil {
		return retVal, err
	}
	contest.Contestname = contestname
	cs.Repo.AddContest(contest)

	return contestname, nil
}

/* private */
func (cs *contestService) inventcontestname() (string, error) {

	noun := FetchWordnikWord("noun")
	adj := FetchWordnikWord("adjective")

	//check for error
	return "The " + adj + " " + noun, nil
}
