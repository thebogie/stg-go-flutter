package services

import (
	"crypto/rand"
	"crypto/subtle"
	"encoding/base64"
	"encoding/json"
	"fmt"

	mathrand "math/rand"
	"net/http"
	"strings"

	"time"

	"golang.org/x/crypto/argon2"

	"github.com/thebogie/stg-go-flutter/config"
	"github.com/thebogie/stg-go-flutter/types"
)

// FetchWordnikWord returns one word
func FetchWordnikWord(typeofword string) string {

	var dat map[string]interface{}

	var apikey = config.Config.Wordnik.Apikey

	var url = "http://api.wordnik.com/v4/words.json/randomWord?api_key=" + apikey + "&includePartOfSpeech=" + typeofword

	resp, err := http.Get(url)

	if err != nil {
		config.Apex.Fatalf("wordnik issue %v", err)
	}

	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {

		err = json.NewDecoder(resp.Body).Decode(&dat)

		if err != nil {
			config.Apex.Fatalf("wordnik issue %v", err)
		}
		return string(dat["word"].(string))

	} else {

		//worknik timeout
		config.Apex.Error("Worknik timeout. Pay for it.")

		const charset = "abcdefghijklmnopqrstuvwxyz" +
			"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

		var seededRand *mathrand.Rand = mathrand.New(
			mathrand.NewSource(time.Now().UnixNano()))

		b := make([]byte, 20)
		for i := range b {
			b[i] = charset[seededRand.Intn(len(charset))]
		}

		return "FIXCONTESTNAME" + string(b)

	}
}

// GeneratePassword is used to generate a new password hash for storing and
// comparing at a later date.
func GeneratePassword(c *types.PasswordConfig, password string) (string, error) {

	// Generate a Salt
	salt := make([]byte, 16)
	if _, err := rand.Read(salt); err != nil {
		return "", err
	}

	hash := argon2.IDKey([]byte(password), salt, c.Time, c.Memory, c.Threads, c.KeyLen)

	// Base64 encode the salt and hashed password.
	b64Salt := base64.RawStdEncoding.EncodeToString(salt)
	b64Hash := base64.RawStdEncoding.EncodeToString(hash)

	format := "$argon2id$v=%d$m=%d,t=%d,p=%d$%s$%s"
	full := fmt.Sprintf(format, argon2.Version, c.Memory, c.Time, c.Threads, b64Salt, b64Hash)
	return full, nil
}

// ComparePassword is used to compare a user-inputted password to a hash to see
// if the password matches or not.
func ComparePassword(password, hash string) (bool, error) {

	parts := strings.Split(hash, "$")

	c := &types.PasswordConfig{}
	_, err := fmt.Sscanf(parts[3], "m=%d,t=%d,p=%d", &c.Memory, &c.Time, &c.Threads)
	if err != nil {
		return false, err
	}

	config.Apex.Warnf("PASSWRODCONFIG: %v", c)

	salt, err := base64.RawStdEncoding.DecodeString(parts[4])
	if err != nil {
		return false, err
	}

	decodedHash, err := base64.RawStdEncoding.DecodeString(parts[5])
	if err != nil {
		return false, err
	}
	c.KeyLen = uint32(len(decodedHash))

	comparisonHash := argon2.IDKey([]byte(password), salt, c.Time, c.Memory, c.Threads, c.KeyLen)

	return (subtle.ConstantTimeCompare(decodedHash, comparisonHash) == 1), nil
}
