package services

import (
	"encoding/json"
	"net/http"

	"github.com/thebogie/stg-go-flutter/config"

	"github.com/labstack/gommon/log"
)

// FetchWordnikWord returns one word
func FetchWordnikWord(typeofword string) string {

	var dat map[string]interface{}

	var apikey = config.Config.Wordnik.Apikey

	var url = "http://api.wordnik.com/v4/words.json/randomWord?api_key=" + apikey + "&includePartOfSpeech=" + typeofword

	resp, err := http.Get(url)

	if err != nil {
		log.Fatal("❌", err)
	}

	defer resp.Body.Close()

	err = json.NewDecoder(resp.Body).Decode(&dat)

	if err != nil {
		//http.Error(w, err.Error(), http.StatusBadRequest)
		log.Fatal("❌", err)
	}

	return string(dat["word"].(string))

}
