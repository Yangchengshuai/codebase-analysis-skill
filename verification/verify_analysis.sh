#!/bin/bash
# Analysis Verification Script
# Validates that all claims in analysis documentation reference actual code

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
total_checks=0
passed_checks=0
failed_checks=0
warnings=0

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    ((failed_checks++))
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    ((warnings++))
}

log_check() {
    ((total_checks++))
    echo -e "\n${GREEN}➜${NC} Checking: $1"
}

# Verify file exists
verify_file_exists() {
    local file="$1"

    log_check "File exists: $file"

    if [ -f "$file" ]; then
        log_info "✓ File exists"
        ((passed_checks++))
        return 0
    else
        log_error "✗ File not found: $file"
        return 1
    fi
}

# Verify line number is valid
verify_line_number() {
    local file="$1"
    local line="$2"

    log_check "Line number $line in $file"

    if [ ! -f "$file" ]; then
        log_error "File does not exist"
        return 1
    fi

    local total_lines=$(wc -l < "$file")

    if [ "$line" -le "$total_lines" ] 2>/dev/null; then
        log_info "✓ Line $line exists (file has $total_lines lines)"
        ((passed_checks++))
        return 0
    else
        log_error "✗ Line $line out of range (file has $total_lines lines)"
        return 1
    fi
}

# Verify function exists
verify_function() {
    local file="$1"
    local func="$2"

    log_check "Function '$func' in $file"

    if [ ! -f "$file" ]; then
        log_error "File does not exist"
        return 1
    fi

    if grep -q "$func" "$file"; then
        local matches=$(grep -c "$func" "$file")
        log_info "✓ Found $matches occurrence(s) of '$func'"
        ((passed_checks++))
        return 0
    else
        log_error "✗ Function '$func' not found"
        return 1
    fi
}

# Verify struct/class exists
verify_struct() {
    local file="$1"
    local struct="$2"

    log_check "Struct/Class '$struct' in $file"

    if [ ! -f "$file" ]; then
        log_error "File does not exist"
        return 1
    fi

    if grep -q "struct $struct\|class $struct" "$file"; then
        log_info "✓ Struct/Class '$struct' found"
        ((passed_checks++))
        return 0
    else
        log_error "✗ Struct/Class '$struct' not found"
        return 1
    fi
}

# Verify code quote matches actual code
verify_code_quote() {
    local file="$1"
    local line="$2"
    local expected="$3"

    log_check "Code quote at $file:$line"

    if [ ! -f "$file" ]; then
        log_error "File does not exist"
        return 1
    fi

    local actual=$(sed -n "${line}p" "$file")

    if echo "$actual" | grep -q "$expected"; then
        log_info "✓ Code quote matches"
        ((passed_checks++))
        return 0
    else
        log_warning "Code quote may not match exactly"
        log_info "Expected: $expected"
        log_info "Actual: $actual"
        ((warnings++))
        return 0
    fi
}

# Main verification function
verify_document() {
    local doc_file="$1"

    echo "=========================================="
    echo "Analysis Verification Report"
    echo "=========================================="
    echo "Document: $doc_file"
    echo "Time: $(date)"
    echo

    # Extract all VERIFY tags from document
    local verify_tags=$(grep -o '\[VERIFY: [^]]*\]' "$doc_file" | sort -u)

    if [ -z "$verify_tags" ]; then
        log_warning "No VERIFY tags found in document"
        return
    fi

    echo "Found $(echo "$verify_tags" | wc -l) unique verification tags"
    echo

    # Process each VERIFY tag
    echo "$verify_tags" | while read -r tag; do
        # Parse tag: [VERIFY: file:line:col description]
        local content=$(echo "$tag" | sed 's/\[VERIFY: //; s/\]$//')
        local file=$(echo "$content" | cut -d: -f1)
        local line=$(echo "$content" | cut -d: -f2)
        local desc=$(echo "$content" | cut -d: -f3-)

        echo "---"
        echo "Tag: $tag"
        echo "File: $file, Line: $line"
        echo "Description: $desc"

        # Verify file exists
        verify_file_exists "$file"

        # Verify line exists (if line number provided)
        if [ "$line" != "$desc" ]; then
            verify_line_number "$file" "$line"
        fi
    done

    echo
    echo "=========================================="
    echo "Verification Summary"
    echo "=========================================="
    echo "Total Checks: $total_checks"
    echo -e "${GREEN}Passed: $passed_checks${NC}"
    echo -e "${RED}Failed: $failed_checks${NC}"
    echo -e "${YELLOW}Warnings: $warnings${NC}"
    echo

    if [ $failed_checks -eq 0 ]; then
        echo -e "${GREEN}✓ All checks passed!${NC}"
        return 0
    else
        echo -e "${RED}✗ Some checks failed${NC}"
        return 1
    fi
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 <analysis_document.md>"
    echo "Example: $0 docs/Data-Structures.md"
    exit 1
fi

verify_document "$1"
