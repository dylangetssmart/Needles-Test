import os
import pandas as pd
import time
from sqlalchemy import create_engine
from dotenv import load_dotenv
from datetime import datetime
from rich.console import Console
from rich.progress import Progress, TextColumn, BarColumn, TaskProgressColumn, TimeElapsedColumn, SpinnerColumn

# Load environment variables
load_dotenv()
SERVER = os.getenv('SERVER')
LITIFY_DB = os.getenv('SOURCE_DB') # Import data to the source_db

# Set up the database connection using SQLAlchemy
connection_string = f'mssql+pyodbc://{SERVER}/{LITIFY_DB}?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes'
engine = create_engine(connection_string)

# Path to the directory containing the CSV files
base_dir = os.path.dirname(os.path.abspath(__file__))
csv_directory = os.path.join(base_dir, 'data')

# Path to the .txt file containing CSV file information
info_file_path = os.path.join(csv_directory, 'AllCSV_NumLines.txt')

# Path to save the progress Excel file
progress_file_path = os.path.join(base_dir, 'import_progress.xlsx')

console = Console()

# Parse the .txt file to get the list of files with data status
files_with_data = {}
with open(info_file_path, 'r', encoding='utf-16') as file:
    for line in file:
        parts = line.split()
        if len(parts) >= 4 and parts[3] == '1':
            file_path = os.path.join(parts[0], parts[1])
            file_name = os.path.basename(file_path)
            files_with_data[file_name] = {
                'line_count': int(parts[4])  # Number of lines from source file
            }

# DataFrame to record progress
progress_df = pd.DataFrame(columns=[
    'File Name', 'Lines in Source', 'Records Imported', 'Difference',
    'Time to Import (s)', 'Status', 'Timestamp', 'Encoding'
])

# Function to read CSV with fallback encoding
def read_csv_with_fallback(file_path):
    encodings = ['utf-8', 'ISO-8859-1', 'latin1', 'cp1252']
    for encoding in encodings:
        try:
            # return pd.read_csv(file_path, encoding=encoding, low_memory=False)
            df = pd.read_csv(file_path, encoding=encoding, low_memory=False)
            return df, encoding
        except (UnicodeDecodeError, pd.errors.ParserError) as e:
            console.print(f"[yellow]Encoding error {file_path} with {encoding}. Error: {e}")
            continue
    raise ValueError(f"Unable to read the file {file_path} with known encodings.")

# Function to import data from CSV to SQL Server
def import_csv_to_sql(file_path, table_name, total_task, file_task, progress):
    start_time = time.time()
    file_name = os.path.basename(file_path)
    line_count = files_with_data[file_name]['line_count'] - 1 # Account for header row

    try:
        df, encoding_used = read_csv_with_fallback(file_path)
        if not df.empty:
            # Write the DataFrame to the SQL table in chunks
            chunk_size = 2000
            for i, chunk in enumerate(range(0, len(df), chunk_size)):
                df_chunk = df.iloc[chunk:chunk + chunk_size]
                df_chunk.to_sql(table_name, engine, if_exists='append', index=False)
                progress.update(file_task, advance=len(df_chunk))

            # df.to_sql(table_name, engine, if_exists='replace', index=False)
            records_imported = len(df)
            record_diff = line_count - records_imported
            status = 'Success'
            progress.console.print(f"[green]Success: Imported {file_name} into table {table_name}.")
        else:
            records_imported = 0
            status = 'Skipped: Empty'
            progress.console.print(f"[yellow]Skipped: {file_name} is empty.")

    except Exception as e:
        records_imported = 0
        status = f'Failure: {e}'
        progress.console.print(f"[red]Failure: Could not import {file_name}. Error: {e}")

    end_time = time.time()
    time_to_import = end_time - start_time
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # Record progress
    progress_df.loc[len(progress_df)] = [
        file_name,
        f"{line_count:,}",
        f"{records_imported:,}",
        record_diff,
        time_to_import,
        status,
        timestamp,
        encoding_used
    ]

    # Explicitly mark file task as complete
    progress.update(file_task, completed=line_count)
    progress.update(total_task, advance=1)
    progress.remove_task(file_task)

# Record start time
start_time = time.time()

# Setup progress bar for total import and each file
with Progress(
    SpinnerColumn(),
    TextColumn("[progress.description]{task.description}"),
    BarColumn(),
    TaskProgressColumn(),
    "•",
    TimeElapsedColumn(),
    "•",
    TextColumn("{task.completed:,}/{task.total:,}"),
    console=console,
) as progress:

    total_task = progress.add_task("[cyan]Importing CSV files", total=len(files_with_data))

    for file_name, data in files_with_data.items():
        file_path = os.path.join(csv_directory, file_name)
        table_name = os.path.splitext(file_name)[0]  # Use file name (without extension) as table name
        
        # Create a task for each file
        file_task = progress.add_task(f"[yellow]Importing {file_name}", total=data['line_count'])
        
        # Import CSV to SQL
        import_csv_to_sql(file_path, table_name, total_task, file_task, progress)

# Save progress to Excel
progress_df.to_excel(progress_file_path, index=False)

# Record the end time and calculate execution time
end_time = time.time()
execution_time_seconds = end_time - start_time

# Convert execution time to hours, minutes, and seconds
hours = int(execution_time_seconds // 3600)
minutes = int((execution_time_seconds % 3600) // 60)
seconds = int(execution_time_seconds % 60)

console.print(f"[bold green]Execution time: {hours} hours, {minutes} minutes, {seconds} seconds")
