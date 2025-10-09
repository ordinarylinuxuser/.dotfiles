#!/bin/bash

# Check if exiftool is installed
if ! command -v exiftool &> /dev/null; then
    echo "Error: exiftool is not installed. Please install it first."
    echo "Try: sudo pacman -S libimage-exiftool-perl"
    exit 1
fi

# Set target directory (default: current directory)
target_dir="${1:-.}"

# Process files recursively
find "$target_dir" -type f -print0 | while IFS= read -r -d '' file; do
    # Skip files in root directory (no parent folder)
    if [ "$(dirname -- "$file")" = "/" ]; then
        echo "Skipping root file: $file"
        continue
    fi

    # Get filename without extension
    filename=$(basename -- "$file")
    title="${filename%.*}"
    [[ -z "$title" ]] && title="$filename"  # Handle dotfiles

    # Get parent folder name for author
    #parent_dir=$(dirname -- "$file")
    #author=$(basename -- "$parent_dir")

    # Update metadata
    echo "Processing: $file"
#    echo "  Title:  $title"
#    echo "  Author: $author"
    
    #exiftool -Title="$title" -Author="$author" -overwrite_original "$file" >/dev/null
    
    exiftool -Title="$title" -overwrite_original "$file" >/dev/null
    
    if [ $? -eq 0 ]; then
        echo "  Status: Success"
    else
        echo "  Status: Failed (unsupported file type)"
    fi
    echo
done

echo "Metadata update complete!"
