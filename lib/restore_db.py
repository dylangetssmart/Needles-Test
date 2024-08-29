import os
import subprocess
import tkinter as tk
from tkinter import filedialog

def select_bak_backup_file():
    root = tk.Tk()
    root.withdraw()
    initial_dir = os.path.join(os.getcwd(), 'backups')
    backup_file = filedialog.askopenfile(
        title="Select the .bak backup_file to restore",
        filetypes=[("SQL Backup backup_files", "*.bak")],
        initialdir=initial_dir
    )
    if backup_file:
        return backup_file.name  # Return the path to the file
    return None

def restore_db(options):
    server = options.get('server')
    database = options.get('database')
    virgin = options.get('virgin', False)

    if not server:
        print("Missing server parameter.")
        return

    if not database:
        print("Missing database parameter.")
        return

    if virgin:
        backup_file = r"C:\LocalConv\_virgin\SADatabase\SADatabase\SAModel_backup_2024_07_25_010001_5737827.bak"
    else:
        # Prompt user to select .bak backup_file using backup_file dialog
        print("Select the .bak backup_file to restore:")
        backup_file = select_bak_backup_file()

        if not backup_file:
            print("No backup_file selected. Exiting script.")
            return

    print(f'Revert database: {server}.{database}')

    # Put the database in single user mode
    print(f"\nPutting database {database} in single user mode ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', server, '-Q', f"ALTER database [{database}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;", '-b', '-d', 'master'],
            check=True
        )
    except subprocess.CalledProcessError:
        print(f"Failed to set database {database} to single user mode. Exiting script.")
        return

    # Restore the database
    print(f"\nRestoring database {database} from {backup_file} ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', server, '-Q', f"RESTORE database [{database}] FROM DISK='{backup_file}' WITH REPLACE, RECOVERY;", '-b', '-d', 'master'],
            check=True
        )
        print(f"database {database} restored successfully from {backup_file}.")
    except subprocess.CalledProcessError:
        print("database restore failed. Check the SQL server error log for details.")
        return

    # Set the database back to multi-user mode
    print(f"\nPutting database {database} back in multi-user mode ...")
    try:
        subprocess.run(
            ['sqlcmd', '-S', server, '-Q', f"ALTER database [{database}] SET MULTI_USER;", '-b', '-d', 'master'],
            check=True
        )
    except subprocess.CalledProcessError:
        print(f"Failed to set database {database} back to multi-user mode. Manual intervention may be required.")