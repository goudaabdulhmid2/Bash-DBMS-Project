#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
DB_ROOT="$SCRIPT_DIR/DBMS"


# Create root diretory if not exists
if [ ! -d "$DB_ROOT" ]
    then
        mkdir -p "$DB_ROOT"

fi

create_db(){
    read -p "Enter database name: " db_name

    if [[ ! $db_name =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
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

list_dbs(){
    echo "Available Databases:"
    if [ "$(ls -A $DB_ROOT)" ]; then
        ls "$DB_ROOT"
    else
        echo "No databases found."
    fi

    read -p "Press Enter to continue..."

}

drop_db(){
    read -p "Enter database name to drop: " db_name

    if [ ! -d "$DB_ROOT/$db_name" ]; then
        echo "Database does not exist !!!!"
        read -p "Press Enter to continue..."
        return
    fi

    read -p "Are you sure you want to delete '$db_name'? (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        rm -r "$DB_ROOT/$db_name"
        echo "Database '$db_name' deleted successfully ✅"
    else
        echo "Operation cancelled."
    fi

    read -p "Press Enter to continue..."
}



clear 
echo " ==========================================="
echo " Bash DBMS Main Menu"
echo " ==========================================="

PS3="Choose an option: "

select choice in  "Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit"
do 
    case $choice in
        "Create Database")
            create_db
            ;;
        "List Databases")
            list_dbs
            ;;
        "Connect To Database")
            echo ">> Connect To Database selected"
            ;;
        "Drop Database")
            drop_db
            ;;
        "Exit")
            echo "Goodbye 👋"
            break
            ;;
        *)
            echo "Invalid option, try again"
            ;;
    esac
done

