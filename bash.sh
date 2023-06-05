#!/bin/bash

# Specify the file to be copied
source_file="./hpa.yaml"

# Specify the root directory to search in
root_directory="."

# Specify the target folder name
target_folder="templates"

# Search for the target folder and copy the file into it
find "$root_directory" -type d -name "$target_folder" -exec cp "$source_file" {}/ \;

echo "File copied to target folders within $root_directory"