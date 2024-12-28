#!/usr/bin/env bash

echo ""
echo "░██████╗██████╗░░█████╗░████████╗░█████╗░████████╗"
echo "██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗╚══██╔══╝"
echo "╚█████╗░██████╔╝██║░░╚═╝░░░██║░░░██║░░██║░░░██║░░░"
echo "░╚═══██╗██╔══██╗██║░░██╗░░░██║░░░██║░░██║░░░██║░░░"
echo "██████╔╝██║░░██║╚█████╔╝░░░██║░░░╚█████╔╝░░░██║░░░"
echo "╚═════╝░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░░╚════╝░░░░╚═╝░░░"
echo ""
echo "Source Code To Text"
echo "github.com/utsmannn"
echo ""

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: This directory is not a Git repository. Script aborted."
  exit 1
fi

FOLDER_NAME="$(basename "$(pwd)")"
FOLDER_NAME_NORMALIZED="$(echo "$FOLDER_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr '_' '-')"
OUTPUT_FILE="${FOLDER_NAME_NORMALIZED}-codes.txt"

> "$OUTPUT_FILE"

files_to_process=()
while IFS= read -r file; do
  if [[ "$file" =~ (^\.|/\.) ]]; then
    continue
  fi
  files_to_process+=("$file")
done < <(git ls-files)

num_files=${#files_to_process[@]}
if [[ $num_files -eq 0 ]]; then
  echo "No files found. Process aborted."
  exit 0
fi

echo "Found $num_files file(s) to process."
echo ""

i=0
for file in "${files_to_process[@]}"; do
  ((i++))
  pct=$(( 100 * i / num_files ))

  echo -ne "Processing file $i of $num_files ... ($pct%)\r"

  filename=$(basename "$file")
  path="$file"
  mime_type=$(file --mime-type -b "$file")

  echo "=====================" >> "$OUTPUT_FILE"
  echo "$filename" >> "$OUTPUT_FILE"
  echo "$path" >> "$OUTPUT_FILE"
  echo "=====================" >> "$OUTPUT_FILE"

  if [[ "$mime_type" =~ ^text/ ]]; then
    cat "$file" >> "$OUTPUT_FILE"
  else
    echo "" >> "$OUTPUT_FILE"
    echo "\"$filename\" is not a text file (MIME type: $mime_type)" >> "$OUTPUT_FILE"
  fi

  echo "" >> "$OUTPUT_FILE"
  echo "=====================" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
done

echo ""
echo "Process complete. Export result: $OUTPUT_FILE"