package services

import (
	"github.com/thebogie/stg-go-flutter/repos"
	"github.com/thebogie/stg-go-flutter/types"
)

// VenueService interface
type VenueService interface {
	AddVenue(*types.Venue) (*types.Venue, error)
}

type venueService struct {
	Repo repos.VenueRepo
}

// NewVenueService will instantiate User Service
func NewVenueService(
	repo repos.VenueRepo) VenueService {

	return &venueService{
		Repo: repo,
	}
}

func (vs *venueService) AddVenue(in *types.Venue) (*types.Venue, error) {
	//if id == 0 {
	//	return nil, errors.New("id param is required")
	//}
	vs.Repo.AddVenue(in)

	return in, nil
}
