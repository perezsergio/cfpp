#!/bin/bash

input_string="; The end user needs a basic knowledge of how to control the program flow but does not necessarily have to know object-oriented programming or C++. ; New requirements, such as requests for new functionality, are presented to and decided by the Steering Board (SB).
; Status of this Document An introduction to the Geant4 Toolkit.
; A serious problem with previous simulation codes was the difficulty of adding new or variant physics models; development was difficult due to the increased size, complexity and interdependency of the procedure-based code.
; This requires the development of new classes overloading standard Geant4 functionality and hence a solid understanding of object-oriented Programming."

# Set the delimiter
IFS=";"

# Read the string into an array
read -ra parts <<<"$input_string"

# Print each part
for part in "${parts[@]}"; do
    echo "$part"
done
