#!/bin/bash

# 1. Create a Temporary File for the Output
OUTPUT_FILE=$(mktemp)
CURRENT_DIR=$(pwd)

echo "Gathering files in $CURRENT_DIR ..."

# 2. Determine File List Strategy
# Check if we are in a git repo.
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "✅ Git repository detected. Respecting .gitignore..."
    # Use Git to list files (handles ignores automatically)
    # -z for null termination (spaces in filenames)
    CMD="git ls-files -z -c -o --exclude-standard"
else
    echo "⚠️  Not a git repository. Falling back to all files (excluding .git/)..."
    # Use 'find' to list all files, excluding the .git directory
    # -print0 for null termination (spaces in filenames)
    CMD="find . -type f -not -path '*/.git/*' -print0"
fi

# 3. Process Files
# We execute $CMD and pipe it into the loop
eval "$CMD" | while IFS= read -r -d '' file; do

    # Clean up "./" prefix if find adds it, for prettier headers
    clean_filename="${file#./}"

    # Skip this script specifically
    if [[ "$clean_filename" == "copyall.sh" ]]; then
        continue
    fi

    # 4. CONTENT DETECTION
    # grep -Iq . "$file": Checks for non-binary content
    # OR [ ! -s ]: Checks if file is empty (we keep empty text files)
    if grep -Iq . "$file" 2>/dev/null || [ ! -s "$file" ]; then
        
        echo "Processing: $clean_filename"

        # Formatting output
        echo "===============================================================================" >> "$OUTPUT_FILE"
        echo "START FILE: $clean_filename" >> "$OUTPUT_FILE"
        echo "===============================================================================" >> "$OUTPUT_FILE"
        
        cat "$file" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE" # Ensure newline
        
        echo "===============================================================================" >> "$OUTPUT_FILE"
        echo "END FILE: $clean_filename" >> "$OUTPUT_FILE"
        echo "===============================================================================" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        
    else
        # It's binary (image, pdf, compiled code, etc.)
        # We don't print "Skipping" to terminal to keep output clean, 
        # but the script silently ignores it.
        true 
    fi

done

# 5. Detect OS and Copy to Clipboard
if command -v pbcopy &> /dev/null; then
    cat "$OUTPUT_FILE" | pbcopy
    echo "✅ Success! Copied to clipboard (macOS)."
elif command -v wl-copy &> /dev/null; then
    cat "$OUTPUT_FILE" | wl-copy
    echo "✅ Success! Copied to clipboard (Wayland)."
elif command -v clip.exe &> /dev/null; then
    cat "$OUTPUT_FILE" | clip.exe
    echo "✅ Success! Copied to clipboard (WSL/Windows)."
elif command -v xclip &> /dev/null; then
    cat "$OUTPUT_FILE" | xclip -selection clipboard
    echo "✅ Success! Copied to clipboard (X11)."
elif command -v xsel &> /dev/null; then
    cat "$OUTPUT_FILE" | xsel --clipboard --input
    echo "✅ Success! Copied to clipboard (xsel)."
else
    echo "❌ No clipboard tool found."
    echo "-----------------------------------"
    cat "$OUTPUT_FILE"
fi

# Cleanup
rm "$OUTPUT_FILE"
