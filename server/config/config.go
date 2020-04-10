package config

import (
	"fmt"

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
		Port  string `mapstructure:"port"`
	} `mapstructure:"api"`
	Wordnik struct {
		Apikey string `mapstructure:"apikey"`
	} `mapstructure:"wordnik"`
	Password struct {
		Time    uint32 `mapstructure:"time"`
		Memory  uint32 `mapstructure:"memory"`
		Threads uint8  `mapstructure:"threads"`
		Keylen  uint32 `mapstructure:"keylen"`
	} `mapstructure:"password"`
}

var (
	// Config is
	Config *Schema
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

}
