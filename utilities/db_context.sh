#!/bin/bash

ensure_db_selected() {
    if [ -z "$CURRENT_DB" ]; then
        echo "No database selected !!!!"
        read -p "Press Enter to continue..."
        return 1
    fi
    return 0
}
