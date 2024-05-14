#!/bin/bash

# Ensure at least two arguments are given (search string and at least one PDF file)
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 search_string file1.pdf [file2.pdf ...]"
    exit 1
fi

# Extract the search string
search_string=$1
shift

# Variable to hold the entire text content
all_text=""

# Loop through all provided PDF files
for pdf_file in "$@"; do
    if [[ -f "$pdf_file" && "$pdf_file" == *.pdf ]]; then
        # Convert PDF to text
        pdf_text=$(pdftotext "$pdf_file" -)
        # Append the text content to the variable
        all_text+="$pdf_text"
    else
        echo "Warning: '$pdf_file' is not a valid PDF file."
    fi
done

# Get the directory of the currently executed Bash script
src_dir="$(dirname "$(realpath "$0")")"

# Execute the Python script and capture its output and error
output=$(python3 "${src_dir}/top5_sentences.py" "${all_text}" "$search_string")
status=$?

# Check if the Python script exited with an error
if [ $status -ne 0 ]; then
    echo "The script ${src_dir}/top5_sentences.py failed with the following error:"
    echo "$output"
    exit 1
fi

# Set the delimiter
IFS="|"

# Read the string into an array
read -ra parts <<<"$output"

# Print each part except the first one
for ((i = 1; i < ${#parts[@]}; i++)); do
    echo "---------------------------------------------------------------------------------"
    echo "MATCH $i"
    echo "\"${parts[i]}\""
    bash "${src_dir}/show_sentence_context.sh" "${parts[i]}" "$@"
    echo "---------------------------------------------------------------------------------"
    echo
done

exit 0
