#!/bin/bash

SOURCE_DIR="$HOME/skrevolve.github.io/vimwiki/src/md"
OUTPUT_DIR="$HOME/skrevolve.github.io/vimwiki/src/html"
TEMPLATE_FILE="$HOME/skrevolve.github.io/vimwiki/src/html/template.html"
INDEX_FILE="$HOME/skrevolve.github.io/vimwiki/src/md/index.md"

# pandoc check
if ! command -v pandoc &> /dev/null; then
    echo "pandoc is not installed"
    exit 1
fi

# output directory check or create
mkdir -p "$OUTPUT_DIR"

# find md file and transform
find "$SOURCE_DIR" -name "*.md" | while read file; do

    # output file path create
    relative_path=${file#$SOURCE_DIR/}
    output="$OUTPUT_DIR/${relative_path%.md}.html"

    echo "Converting: $file -> $output"

    # output directory create
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
