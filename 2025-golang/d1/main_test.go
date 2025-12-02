package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

const TEST_INPUT string = "input_test.txt"

func TestD1(t *testing.T) {
	t.Run("should read test input", func(t *testing.T) {
		lines := GetLinesFromInput(TEST_INPUT)

		expectedLength := 10
		assert.Equal(t, expectedLength, len(lines))
	})

	t.Run("should give next position", func(t *testing.T) {
		type PositionTestCase = struct {
			Desc     string
			Position int
			Rotation string
			Expected int
		}

		cases := []PositionTestCase{
			{"L1 from 0 should give 99", 0, "L1", 99},
			{"R1 from 0 should give 1", 0, "R1", 1},
			{"L10 from 5 should give 95", 5, "L10", 95},
			{"R5 from 95 should give 0", 95, "R5", 0},
		}

		for _, c := range cases {
			t.Run(c.Desc, func(t *testing.T) {
				rot, value, _ := ParseRotation(c.Rotation)
				actual := GetNextPosition(c.Position, rot, value)
				assert.Equal(t, c.Expected, actual)
			})
		}
	})

	t.Run("should parse the rotation", func(t *testing.T) {
		type RotTestCase = struct {
			Desc          string
			Rotation      string
			ExpectedRot   Rotation
			ExpectedValue int
			ExpectedError error
		}

		cases := []RotTestCase{
			{"L1 should give Left and 1", "L1", Left, 1, nil},
			{"R34 should give Right and 34", "R34", Right, 34, nil},
			{"L112 should give Left and 112", "L112", Left, 112, nil},
			{"R90 should give Right and 90", "R90", Right, 90, nil},
			{"RL1 should give error", "RL1", 0, 0, ErrInvalidRotation},
			{"E21 should give error", "E12", 0, 0, ErrInvalidRotation},
		}

		for _, c := range cases {
			t.Run(c.Desc, func(t *testing.T) {
				actualRot, actualValue, actualError := ParseRotation(c.Rotation)
				assert.Equal(t, c.ExpectedRot, actualRot)
				assert.Equal(t, c.ExpectedValue, actualValue)
				assert.Equal(t, c.ExpectedError, actualError)
			})
		}
	})

	type PassTestCase = struct {
		Desc      string
		Position  int
		Rotations []string
		Expected  int
	}
	t.Run("should solve part 1", func(t *testing.T) {
		cases := []PassTestCase{
			{"simple L1R1L1R1 from 0 should give 2", 0, []string{"L1", "R1", "L1", "R1"}, 2},
			{"R10L1L1L3 from 95 should give 1", 95, []string{"R10", "L1", "L1", "L3"}, 1},
			{"R10R10L32 from 50 should give 0", 50, []string{"R10", "R10", "L32"}, 0},
			{"example from README should give 3", 50, []string{"L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"}, 3},
		}

		for _, c := range cases {
			t.Run(c.Desc, func(t *testing.T) {
				actual := SolvePart1(c.Position, c.Rotations)
				assert.Equal(t, c.Expected, actual)
			})
		}
	})

	t.Run("should solve part 2", func(t *testing.T) {
		cases := []PassTestCase{
			{"R1000 from 50 should give 10", 50, []string{"R1000"}, 10},
			{"example from README should give 6", 50, []string{"L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"}, 6},
		}

		for _, c := range cases {
			t.Run(c.Desc, func(t *testing.T) {
				actual := SolvePart2(c.Position, c.Rotations)
				assert.Equal(t, c.Expected, actual)
			})
		}
	})

}
