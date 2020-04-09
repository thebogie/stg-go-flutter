package config

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/spf13/viper"
)

//Schema for config
type Schema struct {
	Database struct {
		Address  string `mapstructure:"address"`
		Database string `mapstructure:"database"`
		Username string `mapstructure:"username"`
		Password string `mapstructure:"password"`
		Debug    bool   `mapstructure:"debug"`
		Port     int    `mapstructure:"port"`
	} `mapstructure:"database"`
	API struct {
		Token string `mapstructure:"token"`
	} `mapstructure:"api"`
	Wordnik struct {
		Apikey string `mapstructure:"apikey"`
	} `mapstructure:"wordnik"`
}

var (
	// Config is
	Config *Schema
	// GeneralLogger exported
	GeneralLogger *log.Logger

	// ErrorLogger exported
	ErrorLogger *log.Logger

	// ContestLogger exported
	ContestLogger *log.Logger
)

func init() {
	config := viper.New()
	config.SetConfigName("config")
	config.AddConfigPath(".")
	config.AddConfigPath("config/")
	config.AddConfigPath("../config/")
	config.AddConfigPath("../")
	config.SetEnvKeyReplacer(strings.NewReplacer(".", "__"))
	config.AutomaticEnv()

	err := config.ReadInConfig()
	if err != nil {
		panic(fmt.Errorf("Fatal error config file: %s ", err))
	}
	err = config.Unmarshal(&Config)
	if err != nil {
		panic(fmt.Errorf("Fatal error config file: %s ", err))
	}

	absPath, err := filepath.Abs("log")
	if err != nil {
		fmt.Println("Error reading given path:", err)
	}

	generalLog, err := os.OpenFile(absPath+"/general-log.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		fmt.Println("Error opening file:", err)
		os.Exit(1)
	}

	contestLog, err := os.OpenFile(absPath+"/contests.json", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		fmt.Println("Error opening file:", err)
		os.Exit(1)
	}

	GeneralLogger = log.New(generalLog, "General Logger:\t", log.Ldate|log.Ltime|log.Lshortfile)
	ErrorLogger = log.New(generalLog, "Error Logger:\t", log.Ldate|log.Ltime|log.Lshortfile)

	ContestLogger = log.New(contestLog, "", 0)

}
