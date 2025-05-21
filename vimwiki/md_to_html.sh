#!/bin/bash

SOURCE_DIR="$HOME/skrevolve.github.io/vimwiki/src/md"
OUTPUT_DIR="$HOME/skrevolve.github.io/vimwiki/src/html"
TEMPLATE_FILE="$HOME/skrevolve.github.io/vimwiki/src/html/common/template.html"

if ! command -v pandoc &> /dev/null; then
    echo "pandoc is not installed"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

find "$SOURCE_DIR" -name "*.md" | while read file; do

    relative_path=${file#$SOURCE_DIR/}
    output="$OUTPUT_DIR/${relative_path%.md}.html"

    echo "Converting: $file -> $output"

    mkdir -p "$(dirname "$output")"

    pandoc "$file" \
    --template="$TEMPLATE_FILE" \
    --metadata title="$(basename "$file" .md)" \
    -s -o "$output"

    if [ $? -eq 0 ]; then
        echo "Success: $output"
    else
        echo "Error converting: $file"
    fi
done

echo "transform complete"
