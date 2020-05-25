package main

import (
	"encoding/xml"
	"io"
	"log"
	"os"
)

// Dictionary was generated 2020-05-25 17:45:52 by christopher.loessl on PinkRobin.
type Dictionary struct {
	XMLName        xml.Name `xml:"dictionary"`
	Text           string   `xml:",chardata"`
	Comment        string   `xml:"comment,attr"`
	Created        string   `xml:"created,attr"`
	LastChanged    string   `xml:"last-changed,attr"`
	Name           string   `xml:"name,attr"`
	SourceLanguage string   `xml:"source-language,attr"`
	TargetLanguage string   `xml:"target-language,attr"`
	Version        string   `xml:"version,attr"`
	License        string   `xml:"license,attr"`
	LicenseComment string   `xml:"licenseComment,attr"`
	OriginURL      string   `xml:"originURL,attr"`
	Word           []struct {
		Text        string `xml:",chardata"`
		Class       string `xml:"class,attr"`
		Comment     string `xml:"comment,attr"`
		Lang        string `xml:"lang,attr"`
		Value       string `xml:"value,attr"`
		Translation []struct {
			Text    string `xml:",chardata"`
			Comment string `xml:"comment,attr"`
			Value   string `xml:"value,attr"`
		} `xml:"translation"`
		Phonetic struct {
			Text      string `xml:",chardata"`
			SoundFile string `xml:"soundFile,attr"`
			Value     string `xml:"value,attr"`
		} `xml:"phonetic"`
		See []struct {
			Text  string `xml:",chardata"`
			Type  string `xml:"type,attr"`
			Value string `xml:"value,attr"`
		} `xml:"see"`
		Example []struct {
			Text        string `xml:",chardata"`
			Value       string `xml:"value,attr"`
			Translation struct {
				Text  string `xml:",chardata"`
				Value string `xml:"value,attr"`
			} `xml:"translation"`
		} `xml:"example"`
		Definition struct {
			Text        string `xml:",chardata"`
			Value       string `xml:"value,attr"`
			Translation struct {
				Text  string `xml:",chardata"`
				Value string `xml:"value,attr"`
			} `xml:"translation"`
		} `xml:"definition"`
		Idiom []struct {
			Text        string `xml:",chardata"`
			Value       string `xml:"value,attr"`
			Translation struct {
				Text  string `xml:",chardata"`
				Value string `xml:"value,attr"`
			} `xml:"translation"`
		} `xml:"idiom"`
		Related []struct {
			Text        string `xml:",chardata"`
			Type        string `xml:"type,attr"`
			Value       string `xml:"value,attr"`
			Comment     string `xml:"comment,attr"`
			Translation struct {
				Text  string `xml:",chardata"`
				Value string `xml:"value,attr"`
			} `xml:"translation"`
		} `xml:"related"`
		Explanation struct {
			Text        string `xml:",chardata"`
			Value       string `xml:"value,attr"`
			Translation struct {
				Text  string `xml:",chardata"`
				Value string `xml:"value,attr"`
			} `xml:"translation"`
		} `xml:"explanation"`
		Paradigm []struct {
			Text       string `xml:",chardata"`
			Comment    string `xml:"comment,attr"`
			Inflection []struct {
				Text    string `xml:",chardata"`
				Value   string `xml:"value,attr"`
				Comment string `xml:"comment,attr"`
			} `xml:"inflection"`
		} `xml:"paradigm"`
		Compound []struct {
			Text        string `xml:",chardata"`
			Comment     string `xml:"comment,attr"`
			Value       string `xml:"value,attr"`
			Inflection  string `xml:"inflection,attr"`
			Translation struct {
				Text  string `xml:",chardata"`
				Value string `xml:"value,attr"`
			} `xml:"translation"`
		} `xml:"compound"`
		URL []struct {
			Text  string `xml:",chardata"`
			Type  string `xml:"type,attr"`
			Value string `xml:"value,attr"`
		} `xml:"url"`
		Synonym []struct {
			Text  string `xml:",chardata"`
			Level string `xml:"level,attr"`
			Value string `xml:"value,attr"`
		} `xml:"synonym"`
		Derivation []struct {
			Text        string `xml:",chardata"`
			Value       string `xml:"value,attr"`
			Inflection  string `xml:"inflection,attr"`
			Translation struct {
				Text  string `xml:",chardata"`
				Value string `xml:"value,attr"`
			} `xml:"translation"`
		} `xml:"derivation"`
		Grammar []struct {
			Text    string `xml:",chardata"`
			Value   string `xml:"value,attr"`
			Comment string `xml:"comment,attr"`
		} `xml:"grammar"`
		Variant []struct {
			Text    string `xml:",chardata"`
			Alt     string `xml:"alt,attr"`
			Value   string `xml:"value,attr"`
			Comment string `xml:"comment,attr"`
		} `xml:"variant"`
		Use struct {
			Text  string `xml:",chardata"`
			Value string `xml:"value,attr"`
		} `xml:"use"`
	} `xml:"word"`
}

var macfolket Dictionary

func main() {
	macfolket, err := decodeFromFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	log.Printf("Having words: %d", len(macfolket.Word))
}

func decodeFromReader(r io.Reader) (*Dictionary, error) {
	var d Dictionary
	decoder := xml.NewDecoder(r)
	// decoder.CharsetReader = charset.NewReaderLabel
	// decoder.Strict = false
	err := decoder.Decode(&d)
	if err != nil {
		return nil, err
	}
	return &d, nil
}

func decodeFromFile(path string) (*Dictionary, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	return decodeFromReader(f)
}
