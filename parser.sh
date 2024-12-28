#!/usr/bin/env bash

# Usage:
#   ./parser.sh <exported_txt_file>
#
# This script reconstructs text files from the specified TXT file (exported by your "Source Code To Text" script).
# All restored text files are placed in the "restored_source_code" directory.
# Any files marked as non-text (based on a specific line in the TXT) are listed at the end.

if [ $# -lt 1 ]; then
  echo "Usage: $0 <txt_input_file>"
  exit 1
fi

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: File '$INPUT_FILE' not found."
  exit 1
fi

OUTPUT_DIR="restored_source_code"
mkdir -p "$OUTPUT_DIR"

non_text_files=()

current_filename=""
current_path=""
collecting_content=false
file_content=""

while IFS= read -r line || [ -n "$line" ]; do
  if [[ "$line" == "=====================" ]]; then
    
    if [ "$collecting_content" = true ]; then
      if [[ "$file_content" =~ ^\".*\"[[:space:]]is[[:space:]]not[[:space:]]a[[:space:]]text[[:space:]]file.* ]]; then
        non_text_files+=("$current_path")
      else
        target_path="$OUTPUT_DIR/$current_path"
        mkdir -p "$(dirname "$target_path")"

        echo -n "$file_content" > "$target_path"
      fi
      
      collecting_content=false
      file_content=""

    else

      IFS= read -r filename_line || break
      IFS= read -r path_line || break

      current_filename="$filename_line"
      current_path="$path_line"

      IFS= read -r sep_line || break
      if [[ "$sep_line" != "=====================" ]]; then
        echo "Format error: expected '=====================' before file content"
        exit 1
      fi

      collecting_content=true
      file_content=""
    fi

  else
    if [ "$collecting_content" = true ]; then
      file_content+="$line"
      file_content+=$'\n'
    fi
  fi
done < "$INPUT_FILE"

if [ ${#non_text_files[@]} -gt 0 ]; then
  echo ""
  echo "The following files were identified as non-text and were not restored:"
  i=1
  for nf in "${non_text_files[@]}"; do
    echo "$i. $nf"
    ((i++))
  done
fi

echo ""
echo "Reconstruction finished."
echo "Restored files are in: $OUTPUT_DIR"