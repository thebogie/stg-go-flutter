package main

import (
	//"bytes"

	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"

	//"net/http"
	"os"

	"github.com/tidwall/gjson"
	//"time"
)

// userObj : player
type UserObj struct {
	Userid    string `json:"userid,omitempty"`
	Email     string `json:"email,omitempty"`
	FirstName string `json:"firstName,omitempty"`
	LastName  string `json:"lastName,omitempty"`
	Password  string `json:"password,omitempty"`
	Birthdate string `json:"birthdate,omitempty"`
	Nickname  string `json:"nickname,omitempty"`
}

func main() {

	//timelayout := "2006-01-02T15:04:05"

	//timelayout := "2006-01-02T15:04:05-07:00"

	// Open our jsonFile
	jsonFile, err := os.Open("stg_records.json")
	// if we os.Open returns an error then handle it
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println("Successfully Opened stg_records.json")
	// defer the closing of our jsonFile so that we can parse it later on
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)

	var result map[string]interface{}
	json.Unmarshal([]byte(byteValue), &result)

	//JSON
	for _, a := range result {

		//pull out all the users to setup fake passwords
		for _, contest := range a.([]interface{}) {

			log.Printf("Contest: %+v\n", contest)

			contestJSON, err := json.Marshal(contest)
			if err != nil {
				log.Fatalln(err)
			}

			outcome := gjson.Get(string(contestJSON), "outcome.#.playerid")

			for _, player := range outcome.Array() {
				//player := gjson.Get(string(people), "playerid")

				var user UserObj
				user.Email = player.String()
				user.Password = "letmein"

				requestByte, _ := json.Marshal(user)

				//log.Printf("JSON%+v", spew.Sdump(user))
				//log.Printf("marhalled%+v", spew.Sdump(requestByte))

				resp, err := http.Post("http://localhost:9090/api/register", "application/json", bytes.NewReader(requestByte))
				if err != nil {
					log.Fatalln(err)
				}
				defer resp.Body.Close()

				body, err := ioutil.ReadAll(resp.Body)
				if err != nil {
					log.Fatalln(err)
				}

				log.Println(string(body))

			}

		}

		//contests
		for _, contest := range a.([]interface{}) {
			log.Printf("Contest: %+v\n", contest)

			requestBody, err := json.Marshal(contest)
			if err != nil {
				log.Fatalln(err)
			}

			resp, err := http.Post("http://localhost:9090/api/contest", "application/json", bytes.NewBuffer((requestBody)))
			if err != nil {
				log.Fatalln(err)
			}

			defer resp.Body.Close()

			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				log.Fatalln(err)
			}

			log.Println(string(body))

			time.Sleep(45 * time.Second)

			//	fmt.Print("Press 'Enter' to continue...")
			//	bufio.NewReader(os.Stdin).ReadBytes('\n')
		}
	}

}

//delete
