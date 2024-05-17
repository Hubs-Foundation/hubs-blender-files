#!/bin/bash

# Define the directory containing the Markdown files
MD_DIR="ghost-to-md-output"

# Define the base URL
BASE_URL="https://hubs.mozilla.com/labs"

# Define the output directory
OUTPUT_DIR="./"

# Ensure the directory exists and is writable
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Ensure the directory is writable
if [ ! -w "$OUTPUT_DIR" ]; then
    echo "Output directory '$OUTPUT_DIR' is not writable."
    exit 1
fi

# Ensure the directory exists
if [ ! -d "$MD_DIR" ]; then
    echo "Directory '$MD_DIR' not found."
    exit 1
fi

# Find all Markdown files in the directory
md_files=$(find "$MD_DIR" -type f -name "*.md")

# Initialize variables
total_count=0

# Loop through each Markdown file
for file in $md_files; do
    # Extract image URLs with file extensions from Markdown file
    image_urls=$(grep -oE '!\[[^]]*]\((__GHOST_URL__\/[^)]+\.(png|jpg|jpeg|gif|bmp|svg))\)' "$file" | sed -E 's/!\[.*\]\((__GHOST_URL__\/[^)]+\.(png|jpg|jpeg|gif|bmp|svg))\)/\1/')
    
    # Increment total count
    count=$(echo "$image_urls" | wc -l)
    total_count=$((total_count + count))
    
    # Loop through each image URL
    while IFS= read -r url; do
        # Replace __GHOST_URL__ with BASE_URL
        new_url="${url//__GHOST_URL__/$BASE_URL}"
        
        # Extract the path and filename from the URL
        path=$(echo "$new_url" | sed "s|$BASE_URL||")
        dir=$(dirname "$path")
        filename=$(basename "$path")
        
        # Create the directory structure
        mkdir -p "$OUTPUT_DIR/$dir"
        
        # Download the file
        curl -o "$OUTPUT_DIR/$path" "$new_url"
        
        # Check if the download was successful
        if [ $? -eq 0 ]; then
            echo "Downloaded $new_url to $OUTPUT_DIR/$path"
        else
            echo "Failed to download $new_url"
        fi
    done <<< "$image_urls"
done

# Print total count
echo "Total number of image URLs with file extensions: $total_count"
