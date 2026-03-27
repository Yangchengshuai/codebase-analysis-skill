#!/bin/bash
# ASCII Diagram Generator Helpers
# Usage: Source this file and use the functions

# Box drawing function
# Usage: draw_box "title" "content" "width"
draw_box() {
    local title="$1"
    local content="$2"
    local width=${3:-50}

    echo "┌$(printf '─%.0s' $(seq 1 $width))┐"
    echo "│ $title"
    echo "├$(printf '─%.0s' $(seq 1 $width))┤"
    echo "│ $content"
    echo "└$(printf '─%.0s' $(seq 1 $width))┘"
}

# Flow diagram with arrows
# Usage: draw_flow "step1" "step2" "step3"
draw_flow() {
    local steps=("$@")
    local i=0

    for step in "${steps[@]}"; do
        echo "┌─────────────┐"
        echo "│  $step     │"
        echo "└─────────────┘"
        if [ $i -lt $((${#steps[@]} - 1)) ]; then
            echo "      │"
            echo "      ▼"
        fi
        ((i++))
    done
}

# Tree structure diagram
# Usage: draw_tree "root" "child1 child2" "grandchild1 grandchild2"
draw_tree() {
    local level=0
    for level_data in "$@"; do
        local indent=$(printf '  %.0s' $(seq 1 $level))
        echo "$indent├── $level_data"
        ((level++))
    done
}

# Data structure diagram
# Usage: draw_structure "StructureName" "field1 field2 field3"
draw_structure() {
    local name="$1"
    shift
    local fields=("$@")

    echo "$name"
    echo "│"
    for field in "${fields[@]}"; do
        echo "├── $field"
    done
}

# Table generator
# Usage: draw_table "header1,header2" "row1col1,row1col2" "row2col1,row2col2"
draw_table() {
    local IFS=','
    local headers=($1)
    shift
    local rows=("$@")

    # Calculate column widths
    local col_count=${#headers[@]}
    local widths=()

    for ((i=0; i<col_count; i++)); do
        local max_width=${#headers[$i]}
        for row in "${rows[@]}"; do
            local cols=($row)
            local width=${#cols[$i]}
            if [ $width -gt $max_width ]; then
                max_width=$width
            fi
        done
        widths[$i]=$max_width
    done

    # Print header separator
    local separator="+"
    for width in "${widths[@]}"; do
        separator+="$(printf '-%.0s' $(seq 1 $((width + 2))))+"
    done
    echo "$separator"

    # Print headers
    local header_line="|"
    for ((i=0; i<col_count; i++)); do
        local padding=$((widths[$i] - ${#headers[$i]}))
        header_line+=" ${headers[$i]}$(printf ' %.0s' $(seq 1 $padding))|"
    done
    echo "$header_line"
    echo "$separator"

    # Print rows
    for row in "${rows[@]}"; do
        local cols=($row)
        local row_line="|"
        for ((i=0; i<col_count; i++)); do
            local padding=$((widths[$i] - ${#cols[$i]}))
            row_line+=" ${cols[$i]}$(printf ' %.0s' $(seq 1 $padding))|"
        done
        echo "$row_line"
    done

    echo "$separator"
}

# Example usage and test
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "=== ASCII Diagram Generator Tests ==="
    echo

    echo "1. Box Diagram:"
    draw_box "Test Box" "This is test content" 40
    echo

    echo "2. Flow Diagram:"
    draw_flow "Input" "Process" "Output"
    echo

    echo "3. Tree Diagram:"
    draw_tree "Root" "Child1 Child2" "Grandchild1 Grandchild2"
    echo

    echo "4. Structure Diagram:"
    draw_structure "MyStruct" "field1 (int)" "field2 (float)" "field3 (string)"
    echo

    echo "5. Table Diagram:"
    draw_table "Name,Type,Size" "field1,int,4" "field2,float,8" "field3,string,var"
    echo
fi
