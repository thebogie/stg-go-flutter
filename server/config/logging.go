package config

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	apex "github.com/apex/log"

	"github.com/apex/log/handlers/multi"
	"github.com/apex/log/handlers/text"
)

//Apex is this
var Apex *apex.Entry
var ContestLogger *log.Logger

func init() {

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

	// backup logs

	ContestLogger = log.New(contestLog, "", 0)

	apex.SetLevel(apex.DebugLevel)

	//General logs
	apex.SetHandler(multi.New(
		text.New(os.Stderr),
		text.New(generalLog),
	))

	Apex = apex.WithFields(apex.Fields{})

}

/*

	// GeneralLogger exported
	GeneralLogger *log.Logger

	// ErrorLogger exported
	ErrorLogger *log.Logger

	// ContestLogger exported
	ContestLogger *log.Logger


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

	//GeneralLogger = log.New(generalLog, "General Logger:\t", log.Ldate|log.Ltime|log.Lshortfile)

	GeneralLogger = log.New(generalLog, "General Logger:\t", log.Ldate|log.Ltime|log.Lshortfile)

	ErrorLogger = log.New(generalLog, "Error Logger:\t", log.Ldate|log.Ltime|log.Lshortfile)

	ContestLogger = log.New(contestLog, "", 0)

*/
