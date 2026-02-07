#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Load DB operations
source "$SCRIPT_DIR/db_operations.sh"

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
            echo ">> Connect To Database (Step 3)"
            read -p "Press Enter to continue..."
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
