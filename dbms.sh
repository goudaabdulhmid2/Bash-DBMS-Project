#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Global state
CURRENT_DB=""

# Load modules
source "$SCRIPT_DIR/validations/common_validations.sh"
source "$SCRIPT_DIR/db_operations.sh"
source "$SCRIPT_DIR/table_operations.sh"
source "$SCRIPT_DIR/table_menu.sh"

clear
echo "==========================================="
echo "        Bash DBMS Main Menu"
echo "==========================================="

PS3="Choose an option: "

select choice in "Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit"
do
    case $choice in
        "Create Database")
            create_db
            clear
            ;;
        "List Databases")
            list_dbs
            clear
            ;;
        "Connect To Database")
            connect_db        
            clear
            ;;
        "Drop Database")
            drop_db
            clear
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
