package main

import (
	"bufio"
	"errors"
	"fmt"
	"log"
	"os"
	"strconv"
)

const INPUT = "input.txt"
const INITIAL_POSITION = 50

type Rotation int

const (
	Left  Rotation = -1
	Right Rotation = 1
)

func GetLinesFromInput(inputFileName string) []string {
	f, err := os.Open(inputFileName)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	lines := []string{}

	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return lines
}

func GetNextPosition(current int, rotation string) int {
	rot, value, err := ParseRotation(rotation)

	if err != nil {
		return -1
	}

	return (current + ((value*int(rot))+100)%100) % 100
}

var rotationsMap = map[string]Rotation{
	"L": Left,
	"R": Right,
}

var ErrInvalidRotation = errors.New("Failed to parse rotation, invalid format")

func ParseRotation(rotation string) (Rotation, int, error) {
	first := rotation[:1]
	rest := rotation[1:]

	rot, ok := rotationsMap[first]
	if !ok {
		return 0, 0, ErrInvalidRotation
	}

	value, err := strconv.Atoi(rest)
	if err != nil {
		return 0, 0, ErrInvalidRotation

	}

	return rot, value, nil
}

func GetPassword(position int, rotations []string) int {
	var password int
	for _, r := range rotations {
		position = GetNextPosition(position, r)
		if position == 0 {
			password++
		}
	}

	return password
}

func main() {
	position := INITIAL_POSITION
	rotations := GetLinesFromInput(INPUT)

	password := GetPassword(position, rotations)
	fmt.Println(password)
}
