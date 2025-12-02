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
const LENGTH = 100

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

func GetNextPosition(current int, rotation Rotation, value int) int {

	return (current + ((value*int(rotation))+LENGTH)%LENGTH) % LENGTH
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

func SolvePart1(position int, rotations []string) int {
	var password int
	for _, r := range rotations {
		rot, value, _ := ParseRotation(r)
		position = GetNextPosition(position, rot, value)
		if position == 0 {
			password++
		}
	}

	return password
}

func GetTimesPassingZero(position int, rotation Rotation, value int) int {
	var timesPassingZero int
	if rotation == Right {
		timesPassingZero = (position + value - 1) / LENGTH
	} else {
		if value > position && position > 0 {
			timesPassingZero = 1 + (value-position-1)/LENGTH
		}
	}

	return timesPassingZero
}

func SolvePart2(position int, rotations []string) int {
	var password int
	for _, r := range rotations {
		rot, value, _ := ParseRotation(r)
		password += GetTimesPassingZero(position, rot, value)
		position = GetNextPosition(position, rot, value)

		if position == 0 {
			password++
		}
	}

	return password
}

func main() {
	position := INITIAL_POSITION
	rotations := GetLinesFromInput(INPUT)

	password := SolvePart2(position, rotations)
	fmt.Println(password)
}
