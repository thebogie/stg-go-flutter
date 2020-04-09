package services

import (
	"encoding/json"

	"log"
	"math/rand"
	"net/http"

	//"os"
	//"path/filepath"
	"time"

	"github.com/thebogie/stg-go-flutter/config"
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

	if resp.StatusCode == http.StatusOK {

		err = json.NewDecoder(resp.Body).Decode(&dat)

		if err != nil {
			//http.Error(w, err.Error(), http.StatusBadRequest)
			log.Fatal("❌", err)
		}
		return string(dat["word"].(string))

	} else {

		//worknik timeout
		config.GeneralLogger.Println("Worknik timeout. Pay for it.")

		const charset = "abcdefghijklmnopqrstuvwxyz" +
			"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

		var seededRand *rand.Rand = rand.New(
			rand.NewSource(time.Now().UnixNano()))

		b := make([]byte, 20)
		for i := range b {
			b[i] = charset[seededRand.Intn(len(charset))]
		}

		return "FIXCONTESTNAME" + string(b)

	}
}
