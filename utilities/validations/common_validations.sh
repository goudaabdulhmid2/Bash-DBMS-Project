#!/bin/bash

trim() {
    echo "$1" | xargs
}

is_valid_name() {
    [[ $1 =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
}

is_valid_number() {
    [[ $1 =~ ^[1-9][0-9]*$ ]]
}

is_valid_datatype() {
    [[ "$1" == "int" || "$1" == "string" ]]
}

confirm_action() {
    local message="$1"
    read -p "$message (y/n): " answer
    [[ $answer =~ ^[yY]$ ]]
}

is_valid_int() {
    [[ $1 =~ ^-?[0-9]+$ ]]
}

is_non_empty_string() {
    local trimmed
    trimmed=$(trim "$1")
    [ -n "$trimmed" ]
}

is_valid_value_by_type() {
    local value="$1"
    local type="$2"

    case "$type" in
        int)    is_valid_int "$value" ;;
        string) is_non_empty_string "$value" ;;
        *)      return 1 ;;
    esac
}

pk_exists() {
    local table_file="$1"
    local pk_index="$2"
    local pk_value="$3"

    awk -F'|' -v idx=$((pk_index+1)) -v pk="$pk_value" '
        BEGIN { found = 1 }

        NR > 1 {
            gsub(/^[ \t]+|[ \t]+$/, "", $idx)
            if ($idx == pk) {
                found = 0
                exit
            }
        }

        END { exit found }
    ' "$table_file"
}

