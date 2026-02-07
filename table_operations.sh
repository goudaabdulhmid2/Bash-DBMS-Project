#!/bin/bash

create_table(){

    ensure_db_selected || return

    # Table name
    while true; do
        read -p "Enter table name: " table_name
        if is_valid_name "$table_name"; then
            table_file="$DB_ROOT/$CURRENT_DB/$table_name.table"
            if [ -f "$table_file" ]; then
                echo "Table already exists !!!!"
            else
                break
            fi
        else
            echo "Invalid table name !!!!"
        fi
    done


    #Number of columns
    while true; do
        read -p "Enter number of columns: " col_count
        if is_valid_number "$col_count"; then
            break
        else
            echo "Invalid number of columns !!!!"
        fi
    done

    columns=""
    pk_defined=false
    declare -a column_names=()

for ((i=1; i<=col_count; i++)); do
        echo "---- Column $i ----"

  
        while true; do
            read -p "Column name: " col_name
            if ! is_valid_name "$col_name"; then
                echo "Invalid column name !!!"
            elif [[ " ${column_names[@]} " =~ " $col_name " ]]; then
                echo "Duplicate column name !!!"
            else
                break
            fi
        done

       
        while true; do
            read -p "Datatype (int/string): " col_type
            col_type=$(echo "$col_type" | tr 'A-Z' 'a-z')
            if is_valid_datatype "$col_type"; then
                break
            else
                echo "Invalid datatype !!!"
            fi
        done

       
        if [ "$pk_defined" = false ]; then
            while true; do
                read -p "Is Primary Key? (y/n): " is_pk
                if [[ $is_pk =~ ^[yYnN]$ ]]; then
                    break
                else
                    echo "Invalid choice !!!"
                fi
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

        if [ -z "$columns" ]; then
            columns="$col_def"
        else
            columns="$columns | $col_def"
        fi
    done


    # Ensure PK exists 
    if [ "$pk_defined" = false ]; then
        echo "Table must have a primary key !!!!"
        read -p "Press Enter to continue..."
        return
    fi

    #Create table file
    echo "$columns" > "$table_file"
    echo "Table '$table_name' created successfully ✅"
    read -p "Press Enter to continue..."


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
        col=$(echo "${cols[$i]}" | xargs)
        IFS=':' read -ra parts <<< "$col"

        name="${parts[0]}"
        type="${parts[1]}"
        flag=$(echo "${parts[2]}" | xargs)

        col_names+=("$name")
        col_types+=("$type")

        if [ "$flag" = "PK" ]; then
            pk_index=$i
        fi
    done

    if [ "$pk_index" -lt 0 ]; then
        echo "Invalid table schema (no PK) !!!"
        read -p "Press Enter to continue..."
        return
    fi

    #  Step 4: Read PK FIRST 
    read -p "Enter ${col_names[$pk_index]} (PK): " pk_value
    pk_value=$(echo "$pk_value" | xargs)

    if ! is_valid_int "$pk_value"; then
        echo "Primary key must be integer !!!"
        read -p "Press Enter to continue..."
        return
    fi

    if ! is_pk_unique "$table_file" "$pk_index" "$pk_value"; then
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
            val=$(echo "$val" | xargs)

            if [ "${col_types[$i]}" = "int" ]; then
                if is_valid_int "$val"; then
                    break
                else
                    echo "Invalid integer !!!"
                fi
            else
                if is_non_empty_string "$val"; then
                    break
                else
                    echo "Value cannot be empty !!!"
                fi
            fi
        done

        values+=("$val")
    done

    #  Step 6: Insert row 
    row=$(IFS='|'; echo "${values[*]}")
    echo "$row" >> "$table_file"

    echo "Row inserted successfully ✅"
    read -p "Press Enter to continue..."
}
