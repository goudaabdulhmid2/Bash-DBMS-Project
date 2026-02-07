#!/bin/bash

create_table(){

    if [ -z "$CURRENT_DB" ]; then
        echo "No database selected !!!"
        read -p "Press Enter to continue..."
        return
    fi

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