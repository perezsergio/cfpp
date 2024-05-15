#!/bin/bash

function printHBar() {
    echo "---------------------------------------------------------------------------------"
    return 0
}

function printTitle() {
    echo "+----------------------------------------------+--------------------------------+"
    echo "|   _____ _        _     ______                |                                |"
    echo "|  / ____| |      | |   |  ____|    _     _    |                                |"
    echo "| | |    | |_ _ __| |   | |__     _| |_ _| |_  |     Showing top 5 search       |"
    echo "| | |    | __| '__| |   |  __|   |_   _|_   _| |   results for the provided     |"
    echo "| | |____| |_| |  | |_  | |        |_|   |_|   |          pdf files             |"
    echo "|  \_____|\__|_|  |_(_) |_|                    |                                |"
    echo "|                                              |                                |"
    echo "+----------------------------------------------+--------------------------------+"
    echo "Search:     $1"
    echo
    return 0
}

## PARSE CLI ARGS
# Ensure at least two arguments are given (search string and at least one PDF file)
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 search_string file1.pdf [file2.pdf ...]"
    exit 1
fi
# The search string is the first arg, the rest are the paths to the pdf files
search_string=$1
shift
# Get the path of the cfpp/src directory
src_dir="$(dirname "$(realpath "$0")")"

## GET PDF TEXT
# Loop through all provided PDF files, store all the text in a variable
all_text=""
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

## GET TOP 5 RESULTS
# This python script prints the top 5 results to stdout
sentences=$(python3 "${src_dir}/top5_sentences.py" "${all_text}" "$search_string")
# Check if the Python script exited with an error
status=$?
if [ $status -ne 0 ]; then
    echo "The script ${src_dir}/top5_sentences.py failed with the following error:"
    echo "$sentences"
    exit 1
fi

## PRINT RESULTS
# Print title art
printTitle "$search_string"
# Set deilimiter that splits the sentences
IFS="|"
# Divide sentences by delimiter
read -ra parts <<<"$sentences"
# Loop through the sentences. 1st iter is skipped because the format
# of sentences is "| s1 | s2 ..." so the firs element is empty
for ((i = 1; i < ${#parts[@]}; i++)); do
    # Top separator
    printHBar
    # print match number (1 to 5)
    echo "MATCH $i"
    # print sentence
    echo "\"${parts[i]}\""
    # print sentence
    bash "${src_dir}/show_sentence_context.sh" "${parts[i]}" "$@"
    # Bottom separator
    printHBar
    echo
done

exit 0
