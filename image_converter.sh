#!/bin/bash

# Function to display elapsed time while downloads are in progress
display_elapsed_time() {
  local elapsed=0
  while [ "$(jobs -r | wc -l)" -gt 0 ]; do
    sleep 1
    elapsed=$((elapsed + 1))
    printf "\rElapsed time: %02d:%02d:%02d" $((elapsed/3600)) $((elapsed%3600/60)) $((elapsed%60))
  done
}

# Function to count images in different formats
count_images() {
    echo "Analyzing images in $1 directory..."
    find "$1" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.svg" -o -iname "*.ico" \) -exec sh -c 'echo ${0##*.}' {} \; | sort | uniq -c
}

# Prompt user for the directory path
echo "Please enter the full path to the directory containing the images:"
read directory_path

# Check if the directory exists
if [ ! -d "$directory_path" ]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Count images in different formats
count_images "$directory_path"

# Create temporary directory
temp_dir=$(mktemp -d)

# Save original image names with extensions to an array
image_array=()
while IFS= read -r -d $'\0' image; do
    image_array+=("$(basename "$image")")
done < <(find "$directory_path" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.svg" -o -iname "*.ico" \) -print0)

read -n 1 -s -r -p "Press any key to continue..."

# Prompt user to choose the target format using fzf
target_format=$(printf "JPG\nPNG\nSVG\nICO" | fzf --header "Choose target format (JPG, PNG, SVG, or ICO):")

# Perform conversion operations and wait for them to finish
echo -e "\nConverting images to $target_format format..."
for image in "${image_array[@]}"; do
    original_name="${image%.*}"
    case "$target_format" in
        "JPG"|"JPEG")
            convert "$directory_path/$image" "$temp_dir/$original_name.jpg" &
            ;;
        "PNG")
            convert "$directory_path/$image" "$temp_dir/$original_name.png" &
            ;;
        "SVG")
            convert "$directory_path/$image" "$temp_dir/$original_name.svg" &
            ;;
        "ICO")
            convert "$directory_path/$image" "$temp_dir/$original_name.ico" &
            ;;
        *)
            echo "Invalid target format. Aborting."
            exit 1
            ;;
    esac
done

# Display elapsed time
display_elapsed_time

wait

# Delete original images
echo -e "\nDeleting original images..."
for image in "${image_array[@]}"; do
    rm -f "$directory_path/$image" 
done

# Move converted images from temporary directory to original directory
echo "Moving converted images to original directory..."
mv "$temp_dir"/* "$directory_path"/

# Remove temporary directory
rm -rf "$temp_dir"

echo "Conversion completed successfully."
