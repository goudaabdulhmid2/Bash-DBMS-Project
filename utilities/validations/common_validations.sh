#!/bin/bash


is_valid_name() {
    # valid identifier: starts with letter/_ then letters/numbers/_
    [[ $1 =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
}

is_valid_number() {
    # positive integer >= 1
    [[ $1 =~ ^[1-9][0-9]*$ ]]
}

is_valid_datatype() {
    # supported datatypes
    [[ "$1" == "int" || "$1" == "string" ]]
}

confirm_action() {
    # generic yes/no confirmation
    local message="$1"
    read -p "$message (y/n): " answer
    [[ $answer =~ ^[yY]$ ]]
}
