#!/bin/bash

input_file="./inputs/day_1.txt"

awk '{gsub(/[^0-9]/, ""); sum += substr($0,1,1) substr($0,length)} END {print "Somme:", sum}' "$input_file"
