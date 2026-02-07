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
                echo ">> Drop Table "
                ;;
            "Insert Into Table")
                echo ">> Insert Into Table "
                ;;
            "Select From Table")
                echo ">> Select From Table "
                ;;
            "Delete From Table")
                echo ">> Delete From Table "
                ;;
            "Update Table")
                echo ">> Update Table "
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
