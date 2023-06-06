#!/bin/bash

# Specify the file to be copied
file_to_delete="secret-dev.yml"

# Specify the root directory to search in
root_directory="."

# Specify the target folder name
target_folder="templates"

# Search for the target folder and copy the file into it
# find "$root_directory" -type d -name "$target_folder" -exec cp "$source_file" {}/ \;
find "$root_directory" -type d -name "$target_folder" -exec rm -f {}/"$file_to_delete" \;

echo "File copied to target folders within $root_directory"