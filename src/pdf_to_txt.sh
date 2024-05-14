#!/bin/bash

output_dir=""
files=()

while [[ $# -gt 0 ]]; do
    case "$1" in
    --output-dir)
        shift
        output_dir="$1"
        shift
        ;;
    *)
        files+=("$1")
        shift
        ;;
    esac
done

if [ "${#files[@]}" -eq 0 ]; then
    echo "Usage: convert_pdf_to_text_per_page [--output-dir <output_directory>] <pdf_file1> [<pdf_file2> ...]" >&2
    return 1
fi

for input_file in "${files[@]}"; do
    if [ ! -f "$input_file" ]; then
        echo "File '$input_file' not found." >&2
        continue
    fi

    file_name=$(basename -- "$input_file")
    file_name_no_ext="${file_name%.*}"

    output_path="$input_file"

    if [ -n "$output_dir" ]; then
        mkdir -p "$output_dir" || {
            echo "Error creating output directory '$output_dir'." >&2
            return 1
        }
        output_path="$output_dir/__doc_$file_name_no_ext"
    fi

    pages=$(pdfinfo "$input_file" | grep "Pages" | awk '{print $2}')

    for ((i = 1; i <= $pages; i++)); do
        pdftotext -f $i -l $i "$input_file" "${output_path}__page_${i}.txt"
    done
done
