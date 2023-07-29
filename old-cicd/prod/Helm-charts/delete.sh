#!/bin/bash

# Specify the file to be deleted
file_to_delete="secret.yaml"

# Specify the root directory to search in
root_directory="."

# Specify the target folder name
target_folder="templates"

# Search for the target folder and delete the file within it
find "$root_directory" -type d -name "$target_folder" -exec rm -f {}/"$file_to_delete" \;

echo "File '$file_to_delete' deleted from target folders within $root_directory"
