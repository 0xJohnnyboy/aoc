#!/bin/bash

DIGITS=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine")
REVERSE_DIGITS=("eno" "owt" "eerht" "ruof" "evif" "xis" "neves" "thgie" "enin")

star_two() {
    local line="$1"
    local first
    local last

    for ((i=0; i<${#line}; i++)); do
        first=$(find_digit "${line:$i}" "${DIGITS[@]}")
        [ -n "$first" ] && break
    done

    for ((i=${#line}-1; i>=0; i--)); do
        last=$(find_digit "$(reverse_string "${line:0:i+1}")" "${REVERSE_DIGITS[@]}")
        [ -n "$last" ] && break
    done

    echo "$((first * 10 + last))"
}

find_digit() {
    local input="$1"
    shift
    local -a mappings=("$@")

    for ((idx=0; idx<${#mappings[@]}; idx++)); do
        if [[ "${mappings[$idx]}" == "$input" ]]; then
            echo "$((idx + 1))"
            return
        fi
    done

    echo ""
}

reverse_string() {
    local input="$1"
    echo "$input" | rev
}

input="two1nine"
result=$(star_two "$input")
echo "Result: $result"

