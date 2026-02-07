#!/bin/bash

# Configuration
DB_DIR="./databases"

# Create databases directory if it doesn't exist
mkdir -p "$DB_DIR"

clear
echo "================================="
echo "Welcome to Bash DBMS"
echo "================================="

function main_menu {
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Connect to Database"
    echo "4. Drop Database"
    echo "5. Exit"
    read -p "Enter choice: " choice

    case $choice in
        1) create_db ;;
        2) list_dbs ;;
        3) connect_db ;;
        4) drop_db ;;
        5) exit 0 ;;
        *) echo "Invalid choice" ;;
    esac
}

function create_db {
    read -p "Enter database name: " dbname
    # Validate input (basic check against empty string and special chars)
    if [[ -z "$dbname" || "$dbname" =~ [^a-zA-Z0-9_] ]]; then
        echo "Invalid database name. Use alphanumeric characters and underscores only."
        return
    fi

    if [ -d "$DB_DIR/$dbname" ]; then
        echo "Database already exists!"
    else
        mkdir "$DB_DIR/$dbname"
        echo "Database '$dbname' created successfully."
    fi
}

function list_dbs {
    echo "Databases:"
    if [ -z "$(ls -A "$DB_DIR")" ]; then
        echo "No databases found."
    else
        ls -1 "$DB_DIR"
    fi
}

function connect_db {
    read -p "Enter database name to connect: " dbname
    if [ -d "$DB_DIR/$dbname" ]; then
        echo "Connected to '$dbname'."
        # TODO: Implement table operations menu here
        # For now, just listing tables in that DB
        ls "$DB_DIR/$dbname"
    else
        echo "Database not found!"
    fi
}

function drop_db {
    read -p "Enter database name to drop: " dbname
    if [ -d "$DB_DIR/$dbname" ]; then
        rm -r "$DB_DIR/$dbname"
        echo "Database '$dbname' dropped successfully."
    else
        echo "Database not found!"
    fi
}

# Main loop
while true; do
    main_menu
    echo "" # Empty line for readability
done