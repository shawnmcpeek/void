import os
import glob
from pathlib import Path

def rename_tiles():
    # Path to the backgrounds folder
    backgrounds_path = "assets/backgrounds"
    
    # Check if the folder exists
    if not os.path.exists(backgrounds_path):
        print(f"Error: Folder '{backgrounds_path}' not found!")
        return
    
    # Get all PNG files in the folder
    png_files = glob.glob(os.path.join(backgrounds_path, "*.png"))
    
    if not png_files:
        print(f"No PNG files found in '{backgrounds_path}'")
        return
    
    print(f"Found {len(png_files)} PNG files to rename:")
    
    # Sort files to ensure consistent ordering
    png_files.sort()
    
    # Rename files sequentially
    for i, old_path in enumerate(png_files, 1):
        # Get the directory and file extension
        directory = os.path.dirname(old_path)
        extension = os.path.splitext(old_path)[1]
        
        # Create new filename with 3-digit zero-padded number
        new_filename = f"{i:03d}{extension}"
        new_path = os.path.join(directory, new_filename)
        
        # Rename the file
        try:
            os.rename(old_path, new_path)
            print(f"Renamed: {os.path.basename(old_path)} → {new_filename}")
        except Exception as e:
            print(f"Error renaming {os.path.basename(old_path)}: {e}")
    
    print(f"\nRenamed {len(png_files)} files successfully!")
    
    # Also rename any .import files if they exist
    import_files = glob.glob(os.path.join(backgrounds_path, "*.png.import"))
    if import_files:
        print(f"\nFound {len(import_files)} .import files to rename:")
        
        for i, old_import_path in enumerate(import_files, 1):
            directory = os.path.dirname(old_import_path)
            new_import_filename = f"{i:03d}.png.import"
            new_import_path = os.path.join(directory, new_import_filename)
            
            try:
                os.rename(old_import_path, new_import_path)
                print(f"Renamed: {os.path.basename(old_import_path)} → {new_import_filename}")
            except Exception as e:
                print(f"Error renaming {os.path.basename(old_import_path)}: {e}")

if __name__ == "__main__":
    rename_tiles()
