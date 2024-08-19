import os
import subprocess

# Get the directory where the script is located
script_dir = os.path.dirname(os.path.abspath(__file__))
script_name = os.path.basename(__file__)

# Define the output executable name
EXEC_FILE = "program"

# Find all .s files in the script directory
ASM_FILES = [f for f in os.listdir(script_dir) if f.endswith('.s')]
OBJ_FILES = [f.replace('.s', '.o') for f in ASM_FILES]

# Function to format file list with backslashes
def format_files(files):
    formatted = ""
    for file in files:
        formatted += f"{file} \\\n\t"
    # Remove the trailing backslash and tab
    return formatted.rstrip("\\\n\t")

# Create the Makefile content
makefile_content = f"""
# Makefile for assembling and linking all assembly programs in the directory

# Variables
ASM_FILES = {format_files(ASM_FILES)}
OBJ_FILES = {format_files(OBJ_FILES)}
EXEC_FILE = {EXEC_FILE}

# Rule to assemble each .s file into an object file
%.o: %.s
\tas -o $@ $<

# Rule to link all object files into an executable
$(EXEC_FILE): $(OBJ_FILES)
\tld -o $(EXEC_FILE) $(OBJ_FILES)

# Clean rule to remove generated files
clean:
\trm -f $(OBJ_FILES) $(EXEC_FILE)

.PHONY: clean
"""

# Write the Makefile content to a file in the script directory
makefile_path = os.path.join(script_dir, 'Makefile')
with open(makefile_path, 'w') as f:
    f.write(makefile_content)

print("Makefile created successfully.")

# Create the tar.gz and zip archive commands
tar_gz_command = f"tar --exclude='{script_name}' --exclude='*.tar.gz' --exclude='*.zip' -czf archive.tar.gz -C {script_dir} ."
zip_command = f"zip -r archive.zip . -x '{script_name}' '*.tar.gz' '*.zip'"

# Execute the commands
print("Creating tar.gz archive...")
subprocess.run(tar_gz_command, shell=True, check=True)
print("tar.gz archive created successfully.")

print("Creating zip archive...")
subprocess.run(zip_command, shell=True, check=True)
print("zip archive created successfully.")