import os
import re
from lib.backup_db import backup_db
from lib.sql_runner import sql_runner
from rich.console import Console
from rich.progress import Progress, TextColumn, BarColumn, TaskProgressColumn, TimeElapsedColumn, SpinnerColumn

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SQL_SCRIPTS_DIR = os.path.join(BASE_DIR, '../sql-scripts/conv/')

# Possible options are 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
# https://docs.python.org/3/library/stdtypes.html#typesseq-range
sequence_patterns = {
    i: re.compile(rf'^{i}.*\.sql$', re.I) for i in range(10)
}

# sequence_patterns = {
#     # 'A': re.compile(r'^.*\.sql$', re.I),
#     0: re.compile(r'^0.*\.sql$', re.I),
#     1: re.compile(r'^1.*\.sql$', re.I),
#     2: re.compile(r'^2.*\.sql$', re.I),
#     3: re.compile(r'^3.*\.sql$', re.I),
#     4: re.compile(r'^4.*\.sql$', re.I),
#     5: re.compile(r'^5.*\.sql$', re.I),
#     'p': re.compile(r'^post.*\.sql$', re.I)
# }

console = Console()

def exec_conv(options):
    server = options.get('server')
    database = options.get('database')
    sequence = options.get('sequence')
    backup = options.get('backup', False)
    
    # Check if sequence is exactly 0
    # Python considers numeric 0 to be false
    # https://stackoverflow.com/questions/34376441/if-not-condition-statement-in-python
    if sequence == 0:
        selected_pattern = sequence_patterns[sequence]
    else:
        if not sequence or sequence not in sequence_patterns:
            console.print('Invalid sequence option.', style="bold red")
            return

    selected_pattern = sequence_patterns[sequence]

    # console.print(f'Executing scripts sequence {sequence} against {server}.{database}...', style="bold blue")

    try:
        all_files = os.listdir(SQL_SCRIPTS_DIR)
        files = [file for file in all_files if selected_pattern.match(file)]

        if not files:
            console.print(f'No scripts found for pattern: {selected_pattern}', style="bold yellow")
        else:
            with Progress(
                SpinnerColumn(),
                TextColumn("[progress.description]{task.description}"),
                BarColumn(),
                TaskProgressColumn(),
                "•",
                TimeElapsedColumn(),
                "•",
                TextColumn("{task.completed:,}/{task.total:,}"),
                console=console
            ) as progress:
                task = progress.add_task(f"[cyan]Executing SQL Scripts Sequence: {sequence}", total=len(files))
                for file in files:
                    # progress.console.log(f"Processing file: {file}")
                    script_task = progress.add_task(f"[yellow]Running {file}")
                    sql_runner(
                        os.path.join(SQL_SCRIPTS_DIR, file),
                        server,
                        database,
                        script_task,
                        progress
                    )
                    progress.update(task, advance=1)
                    # console.print(f'Executed {file}', style="green")
    except Exception as e:
        console.print(f'Error reading directory {SQL_SCRIPTS_DIR}\n{str(e)}', style="bold red")


    if backup:    
        backup_db({
            'database': database,
            'directory': os.path.join(BASE_DIR, '../backups'),
            'sequence': sequence,
            'server': server
        })