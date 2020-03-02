package initialization

import (
	"log"
	"server/keys"
	"server/libs/mongodb"
)

func InitEnv() {
	keys.GetKeys()

	log.Println("✅ environment variables initialized successfully")
}

func InitDatabase() {
	mongodb.InitiateDatabase()
}
