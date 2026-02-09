table_menu() {
    clear
    echo "==========================================="
    echo " Database: $CURRENT_DB"
    echo " Table Menu"
    echo "==========================================="

    PS3="Choose an option: "

    select table_choice in \
        "Create Table" \
        "List Tables" \
        "Drop Table" \
        "Insert Into Table" \
        "Select From Table" \
        "Delete From Table" \
        "Update Table" \
        "Back"
    do
        case $table_choice in
            "Create Table")
               create_table
               clear
                ;;
            "List Tables")
                list_tables
                clear
                ;;
            "Drop Table")
                drop_table
                clear
                ;;
            "Insert Into Table")
                insert_into_table
                clear
                ;;
            "Select From Table")
                select_from_table
                clear
                ;;
            "Delete From Table")
                delete_from_table
                clear
                ;;
            "Update Table")
                update_table
                clear
                ;;
            "Back")
                CURRENT_DB=""
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}
