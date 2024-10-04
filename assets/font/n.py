import os

def list_files_in_directory(directory_path):
    try:
        # Get the list of all files and directories
        files = os.listdir(directory_path)
        
        # Filter out directories, keeping only files
        file_list = [f for f in files if os.path.isfile(os.path.join(directory_path, f))]
        
        return file_list
    except FileNotFoundError:
        return "Directory not found!"
    except Exception as e:
        return f"An error occurred: {e}"

# Example usage
directory_path = "/Users/imghonst/Downloads/Nunito/static"  # Replace with the actual directory path
file_names = list_files_in_directory(directory_path)

print(file_names)
