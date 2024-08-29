from sqlalchemy import create_engine, text

# def create_database(options):
#     server = options.get('server')
#     database_name = options.get('database_name')
#     connection_string = f'mssql+pyodbc://{server}/master?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes'
#     engine = create_engine(connection_string)

#     # Connect to the server and create a new database
#     with engine.connect() as connection:
#         connection.execute(text(f"CREATE DATABASE [{database_name}]"))
#         print(f"SQL Server database '{database_name}' created successfully.")

def create_sql_server_database(server, username, password, db_name):
    # Connection string to connect to the SQL Server
    connection_string = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};UID={username};PWD={password};DATABASE=master"
    
    try:
        # Establish a connection to the SQL Server
        with pyodbc.connect(connection_string) as conn:
            # Create a cursor object using the connection
            cursor = conn.cursor()
            
            # Execute the SQL command to create the database
            cursor.execute(f"CREATE DATABASE [{db_name}]")
            print(f"SQL Server database '{db_name}' created successfully.")
            
            # Commit the transaction
            conn.commit()
    except pyodbc.Error as e:
        print(f"An error occurred: {e}")