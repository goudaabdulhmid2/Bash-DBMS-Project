#!/bin/bash

create_table(){

    ensure_db_selected || return

    # Table name
        while true; do
        read -p "Enter table name: " table_name
        table_name=$(trim "$table_name")

        if ! is_valid_name "$table_name"; then
            echo "Invalid table name!"
            continue
        fi

        table_file="$DB_ROOT/$CURRENT_DB/$table_name.table"

        if [ -f "$table_file" ]; then
            echo "Table already exists!"
        else
            break
        fi
    done


    #Number of columns
   
    while true; do
        read -p "Enter number of columns: " col_count
        if is_valid_number "$col_count"; then
            break
        else
            echo "Invalid number!"
        fi
    done

    columns=""
    pk_defined=false
    declare -a column_names=()

    for ((i=1; i<=col_count; i++)); do
        echo "---- Column $i ----"

  
        while true; do
            read -p "Column name: " col_name
            col_name=$(trim "$col_name")

            if ! is_valid_name "$col_name"; then
                echo "Invalid column name!"
            elif [[ " ${column_names[@]} " =~ " $col_name " ]]; then
                echo "Duplicate column name!"
            else
                break
            fi
        done

       
        while true; do
            read -p "Datatype (int/string): " col_type
            col_type=$(trim "$col_type" | tr 'A-Z' 'a-z')

            if is_valid_datatype "$col_type"; then
                break
            else
                echo "Invalid datatype!"
            fi
        done

       
        if [ "$pk_defined" = false ]; then
            while true; do
                read -p "Is Primary Key? (y/n): " is_pk
                [[ $is_pk =~ ^[yYnN]$ ]] && break
                echo "Invalid choice!"
            done
        else
            is_pk="n"
        fi

        if [[ $is_pk =~ ^[yY]$ ]]; then
            pk_defined=true
            col_def="$col_name:$col_type:PK"
        else
            col_def="$col_name:$col_type"
        fi

        column_names+=("$col_name")

        [ -z "$columns" ] && columns="$col_def" || columns="$columns | $col_def"
    done


    # Ensure PK exists 
    if [ "$pk_defined" = false ]; then
        echo "Table must have a primary key!"
        read -p "Press Enter..."
        return
    fi

    #Create table file
    echo "$columns" > "$table_file"
    echo "Table created successfully."
    read -p "Press Enter..."

}

list_tables() {

   
    ensure_db_selected || return

    db_path="$DB_ROOT/$CURRENT_DB"

    echo "Tables in database '$CURRENT_DB':"

    table_files=$(find "$db_path" -maxdepth 1 -type f -name "*.table")

    if [ -z "$table_files" ]; then
        echo "No tables found."
    else
        while read -r table; do
            basename "$table" .table
        done <<< "$table_files"
    fi

    read -p "Press Enter to continue..."
}

insert_into_table() {

    ensure_db_selected || return

    read -p "Enter table name: " table_name
    table_name=$(trim "$table_name")
    table_file="$DB_ROOT/$CURRENT_DB/$table_name.table"

    if [ ! -f "$table_file" ]; then
        echo "Table does not exist !!!"
        read -p "Press Enter to continue..."
        return
    fi

    #  Read metadata 
    meta=$(head -n 1 "$table_file")
    IFS='|' read -ra cols <<< "$meta"

    col_names=()
    col_types=()
    pk_index=-1

    for i in "${!cols[@]}"; do
        col=$(trim "${cols[$i]}")
        IFS=':' read -ra parts <<< "$col"

        col_names+=("${parts[0]}")
        col_types+=("${parts[1]}")

        flag=$(trim "${parts[2]}")

        if [ "$flag" = "PK" ]; then
            pk_index=$i
        fi
    done

    if [ "$pk_index" -lt 0 ]; then
        echo "Invalid table schema !!!"
        read -p "Press Enter to continue..."
        return
    fi

    pk_type="${col_types[$pk_index]}"

    #  Step 4: Read PK FIRST 
    read -p "Enter ${col_names[$pk_index]} (PK): " pk_value
    pk_value=$(trim "$pk_value")

    if ! is_valid_value_by_type "$pk_value" "$pk_type"; then
        echo "Invalid primary key value !!!"
        read -p "Press Enter to continue..."
        return
    fi

    if pk_exists "$table_file" "$pk_index" "$pk_value"; then
        echo "Primary key already exists !!!"
        read -p "Press Enter to continue..."
        return
    fi

    #  Step 5: Read remaining columns 
    values=()

    for i in "${!col_names[@]}"; do
        if [ "$i" -eq "$pk_index" ]; then
            values+=("$pk_value")
            continue
        fi

        while true; do
            read -p "Enter ${col_names[$i]} (${col_types[$i]}): " val
            val=$(trim "$val")

            if is_valid_value_by_type "$val" "${col_types[$i]}"; then
                break
            else
                echo "Invalid value !!!!"
            fi
        done

        values+=("$val")
    done

    row=$(IFS='|'; echo "${values[*]}")
    echo "$row" >> "$table_file"

    echo "Row inserted successfully ✅"
    read -p "Press Enter to continue..."
}



select_from_table(){

    ensure_db_selected || return

    read -p "Enter table name: " table_name
    table_file="$DB_ROOT/$CURRENT_DB/$table_name.table"

    if [ ! -f "$table_file" ]; then
        echo "Table does not exist !!!!!!"
        read -p "Press Enter to continue..."
        return
    fi

    # Read header 
    header=$(head -n 1 "$table_file")

    # column names
    IFS='|' read -ra cols <<< "$header"

    col_names=()

    for col in "${cols[@]}"; do
        col=$(echo "$col" | xargs)
        IFS=':' read -ra parts <<< "$col"
        col_names+=("${parts[0]}")
    done

    # Print header     
    echo
    for name in "${col_names[@]}"; do
        printf "%-15s" "$name"
    done
    echo

    printf '%.0s-' {1..60}
    echo

    # Print rows
    tail -n +2 "$table_file" | while IFS='|' read -ra row; do
        for cell in "${row[@]}"; do
            cell=$(echo "$cell" | xargs)
            printf "%-15s" "$cell"
        done
        echo
    done

    echo
    read -p "Press Enter to continue..."



}

delete_from_table() {

    ensure_db_selected || return

    read -p "Enter table name: " table_name
    table_name=$(trim "$table_name")
    table_file="$DB_ROOT/$CURRENT_DB/$table_name.table"

    if [ ! -f "$table_file" ]; then
        echo "Table does not exist !!!!"
        read -p "Press Enter to continue..."
        return
    fi

    #  Read metadata 
    header=$(head -n 1 "$table_file")
    IFS='|' read -ra cols <<< "$header"

    pk_index=-1
    pk_name=""
    col_types=()

    for i in "${!cols[@]}"; do
        col=$(trim "${cols[$i]}")
        IFS=':' read -ra parts <<< "$col"

        col_types+=("${parts[1]}")
        flag=$(trim "${parts[2]}")

        if [ "$flag" = "PK" ]; then
            pk_index=$i
            pk_name="${parts[0]}"
        fi
    done

    if [ "$pk_index" -lt 0 ]; then
        echo "Invalid table schema !!!!"
        read -p "Press Enter to continue..."
        return
    fi

    pk_type="${col_types[$pk_index]}"

    #  Read PK 
    read -p "Enter $pk_name value to delete: " pk_value
    pk_value=$(trim "$pk_value")

    if ! is_valid_value_by_type "$pk_value" "$pk_type"; then
        echo "Invalid primary key !!!!"
        read -p "Press Enter to continue..."
        return
    fi

    if ! pk_exists "$table_file" "$pk_index" "$pk_value"; then
        echo "Record not found !!!!"
        read -p "Press Enter to continue..."
        return
    fi

    #  Delete using temp file 
    temp_file=$(mktemp)

    head -n 1 "$table_file" > "$temp_file"

    awk -F'|' -v idx=$((pk_index+1)) -v pk="$pk_value" '
        NR > 1 {
            gsub(/^[ \t]+|[ \t]+$/, "", $idx)
            if ($idx != pk) print $0
        }
    ' "$table_file" >> "$temp_file"

    mv "$temp_file" "$table_file"

    echo "Record deleted successfully ✅"
    read -p "Press Enter to continue..."
}