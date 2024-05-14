#!/bin/bash

# Ensure at least two arguments are given (search string and at least one PDF file)
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 search_string file1.pdf [file2.pdf ...]"
    exit 1
fi

# Extract the search string
search_string=$1
shift

# Process each PDF file provided as an argument
for pdf in "$@"; do
    # Get the number of pages in the PDF
    num_pages=$(pdfinfo "$pdf" | grep Pages | awk '{print $2}')

    # Process each page
    for ((i = 1; i <= num_pages; i++)); do
        # Store the text in a variable
        text=$(pdftotext -f $i -l $i "$pdf" -)
        pattern=".{0,100}(?s)${search_string// /\.}.{0,100}"
        result=$(echo "$text" | grep -oPz "$pattern" | tr -d '\0' | tr '\n' ' ')
        if [ -n "$result" ]; then
            echo "---------------------------------------------------------------------------------"
            echo "Document: $pdf"
            echo "Page: $i"
            echo "Context:...${result}..."
            echo "---------------------------------------------------------------------------------"
        fi

    done
done

exit 0
