# Bash DBMS Project

A simple Database Management System (DBMS) written entirely in Bash. This project allows users to create and manage databases and tables using a command-line interface.

## 🚀 Features

### Database Operations
- **Create Database**: Create a new database (directory).
- **List Databases**: View all available databases.
- **Connect To Database**: Select a database to perform table operations.
- **Drop Database**: Delete an existing database.

### Table Operations
Once connected to a database, you can perform the following operations:
- **Create Table**: Define a new table with columns and data types.
- **List Tables**: View all tables in the current database.
- **Drop Table**: Delete an existing table.
- **Insert Into Table**: Add a new row to a table.
- **Select From Table**: View all data in a table.
- **Delete From Table**: Remove a row based on the Primary Key.
- **Update Table**: Modify an existing row based on the Primary Key.

## 📁 Project Structure

```
Bash-DBMS-Project/
├── dbms.sh                 # Main entry point for the application
├── db_operations.sh        # Functions for database management
├── table_menu.sh           # Menu interface for table operations
├── table_operations.sh     # Functions for table management
├── utilities/              # Helper scripts and validations
└── DBMS/                   # Directory where databases and tables are stored
```

## 🛠️ Requirements

- Bash shell (Linux/macOS/WSL)

## 💻 How to Run

1.  Clone the repository or download the source code.
2.  Navigate to the project directory:
    ```bash
    cd Bash-DBMS-Project
    ```
3.  Make the main script executable (if necessary):
    ```bash
    chmod +x dbms.sh
    ```
4.  Run the application:
    ```bash
    ./dbms.sh
    ```

## 📝 Usage

- Upon running `./dbms.sh`, you will be presented with the main menu.
- Use the number keys to select an option.
- Follow the on-screen prompts to manage your databases and tables.
