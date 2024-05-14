#!/bin/bash

search_string="prerequisites for a new dev"

# Check if the number of arguments is less than one
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 file1.pdf [file2.pdf ... fileN.pdf]"
    exit 1
fi

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

echo "$output"
echo "END OUPUT"

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
    echo "$i"
    echo "${parts[i]}"
done

exit 0
