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

is_valid_int() {
    [[ $1 =~ ^-?[0-9]+$ ]]
}

is_non_empty_string() {
    local trimmed
    trimmed=$(echo "$1" | xargs)
    [ -n "$trimmed" ]
}

is_pk_unique() {
    local table_file="$1"
    local pk_index="$2"
    local pk_value="$3"

    awk -F'|' -v idx=$((pk_index+1)) -v pk="$pk_value" '
        BEGIN { found = 0 }

        NR > 1 {
            gsub(/^[ \t]+|[ \t]+$/, "", $idx)
            if ($idx == pk) {
                found = 1
                exit
            }
        }

        END {
            if (found) exit 1
            else exit 0
        }
    ' "$table_file"
}
