#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
DB_ROOT="$SCRIPT_DIR/DBMS"

# Load modules
source "$SCRIPT_DIR/validations/common_validations.sh"

# Create DB root directory if not exists
mkdir -p "$DB_ROOT"

create_db() {
    read -p "Enter database name: " db_name

    if ! is_valid_name "$db_name"; then
        echo "Invalid database name !!!!!"
        read -p "Press Enter to continue..."
        return
    fi

    if [ -d "$DB_ROOT/$db_name" ]; then
        echo "Database already exists !!!!!"
    else
        mkdir "$DB_ROOT/$db_name"
        echo "Database '$db_name' created successfully ✅"
    fi

    read -p "Press Enter to continue..."
}

list_dbs() {
    echo "Available Databases:"
    if [ "$(ls -A "$DB_ROOT")" ]; then
        ls "$DB_ROOT"
    else
        echo "No databases found."
    fi

    read -p "Press Enter to continue..."
}

drop_db() {
    read -p "Enter database name to drop: " db_name

    if [ ! -d "$DB_ROOT/$db_name" ]; then
        echo "Database does not exist !!!!!"
        read -p "Press Enter to continue..."
        return
    fi

    if confirm_action "Are you sure you want to delete '$db_name'?";  then
        rm -r "$DB_ROOT/$db_name"
        echo "Database '$db_name' deleted successfully ✅"
    else
        echo "Operation cancelled."
    fi

    read -p "Press Enter to continue..."
}

connect_db(){
    read -p "Enter database name to connect: " db_name
    if [ ! -d "$DB_ROOT/$db_name" ]; then
        echo "Database does not exist !!!!"
        read -p "Press Enter to continue..."
        return
    fi

    CURRENT_DB="$db_name"
    echo "Connected to database '$CURRENT_DB' ✅"
    read -p "Press Enter to continue..."

    table_menu
}