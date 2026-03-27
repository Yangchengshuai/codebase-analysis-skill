#!/bin/bash
# Code Reference Formatter
# Formats code references consistently: file:line:column

# Format code reference
# Usage: format_ref "file.cpp" "line_number" "column_number" "description"
format_ref() {
    local file="$1"
    local line=${2:-0}
    local col=${3:-0}
    local desc="$4"

    if [ $col -gt 0 ]; then
        echo "**[VERIFY: $file:$line:$col]** $desc"
    else
        echo "**[VERIFY: $file:$line]** $desc"
    fi
}

# Extract function definition with context
# Usage: extract_function "file.cpp" "function_name" "context_lines"
extract_function() {
    local file="$1"
    local func_name="$2"
    local context=${3:-5}

    grep -n -A "$context" "$func_name" "$file" || echo "Function not found"
}

# Create code block with reference
# Usage: code_block "file.cpp" "start_line" "end_line" "language"
code_block() {
    local file="$1"
    local start=$2
    local end=$3
    local lang=${4:-cpp}

    echo "\`\`\`$lang"
    sed -n "${start},${end}p" "$file"
    echo "\`\`\`"
    echo ""
    echo "**Evidence**: \`$file:$start-$end\`"
}

# Generate cross-reference link
# Usage: xref "document.md" "section_id" "link_text"
xref() {
    local doc="$1"
    local section="$2"
    local text="$3"

    echo "[$text]($doc#$section)"
}

# Verification checklist item
# Usage: verify_check "description" "file:line"
verify_check() {
    local desc="$1"
    local ref="$2"

    echo "- [ ] $desc"
    echo "  **Evidence**: \`$ref\`"
}

# Example usage
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "=== Code Reference Formatter Tests ==="
    echo

    echo "1. Format Reference:"
    format_ref "src/test.cpp" "42" "15" "Function definition"
    echo

    echo "2. Verification Checklist:"
    verify_check "Read struct definition" "include/struct.h:45"
    echo

    echo "3. Cross-Reference:"
    xref "data_structures.md" "structure-a" "See Structure A details"
    echo
fi
