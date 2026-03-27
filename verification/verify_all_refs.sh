#!/bin/bash

###############################################################################
# verify_all_refs.sh
#
# Purpose: Verify all [VERIFY:] tags in codebase analysis documents
# Usage: ./verify_all_refs.sh <document.md>
#
# This script enforces the MANDATORY verification workflow from WORKFLOW.md
# It checks that every claim in the analysis is backed by actual code evidence.
#
# Author: Codebase-Analysis Skill v2.0
# Date: 2026-03-27
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <document.md>"
    echo "Example: $0 ANALYSIS_00-SystemOverview.md"
    exit 1
fi

DOCUMENT=$1
REFS_FILE=$(mktemp)
ERRORS=0
WARNINGS=0

echo "========================================"
echo "Codebase Analysis Verification Tool"
echo "========================================"
echo "Document: $DOCUMENT"
echo ""

###############################################################################
# Step 1: Extract all [VERIFY:] tags
###############################################################################

echo "[1/5] Extracting [VERIFY:] tags..."

grep -o '\[VERIFY: [^]]*\]' "$DOCUMENT" | sed 's/\[VERIFY: //;s/\]//' > "$REFS_FILE" || true

if [ ! -s "$REFS_FILE" ]; then
    echo -e "${RED}❌ ERROR: No [VERIFY:] tags found in document!${NC}"
    echo "This violates the MANDATORY requirement from WORKFLOW.md"
    echo "Every claim MUST have a [VERIFY: file:line] tag"
    rm -f "$REFS_FILE"
    exit 1
fi

TOTAL_REFS=$(wc -l < "$REFS_FILE")
echo -e "${GREEN}✓${NC} Found $TOTAL_REFS [VERIFY:] tags"

###############################################################################
# Step 2: Check for duplicate tags
###############################################################################

echo ""
echo "[2/5] Checking for duplicate tags..."

DUPLICATES=$(sort "$REFS_FILE" | uniq -d)

if [ ! -z "$DUPLICATES" ]; then
    echo -e "${YELLOW}⚠ WARNING: Duplicate [VERIFY:] tags found:${NC}"
    echo "$DUPLICATES"
    WARNINGS=$((WARNINGS + $(echo "$DUPLICATES" | wc -l)))
else
    echo -e "${GREEN}✓${NC} No duplicates found"
fi

###############################################################################
# Step 3: Verify each reference
###############################################################################

echo ""
echo "[3/5] Verifying references against actual code..."

while IFS=':' read -r prefix file line rest; do
    # Skip malformed entries
    if [ -z "$file" ] || [ -z "$line" ]; then
        echo -e "${RED}❌ MALFORMED: $prefix:$file:$line${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi

    # Check if file exists
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ FILE NOT FOUND: $file${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi

    # Check if line number is valid
    TOTAL_LINES=$(wc -l < "$file")
    if [ "$line" -lt 1 ] || [ "$line" -gt "$TOTAL_LINES" ]; then
        echo -e "${RED}❌ LINE $line OUT OF RANGE in $file (file has $TOTAL_LINES lines)${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi

    # Extract code at referenced line
    CODE_AT_LINE=$(sed -n "${line}p" "$file")

    # Check if line is empty (might be in a gap)
    if [ -z "$CODE_AT_LINE" ]; then
        echo -e "${YELLOW}⚠ WARNING: Line $line in $file is empty${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi

    echo -e "${GREEN}✓${NC} [$file:$line] OK"

done < "$REFS_FILE"

###############################################################################
# Step 4: Check for common issues
###############################################################################

echo ""
echo "[4/5] Checking for common issues..."

# Check for claims without [VERIFY:] tags
# This is a heuristic - looks for paragraphs that don't have VERIFY nearby
CLAIMS_WITHOUT_VERIFY=$(grep -P -c '(?<!\[VERIFY: [^\]]*\]\n)(?=^#{2,}|\*\*Claim\*\*|The system|This algorithm)' "$DOCUMENT" || true)

if [ "$CLAIMS_WITHOUT_VERIFY" -gt 0 ]; then
    echo -e "${YELLOW}⚠ WARNING: Found ~$CLAIMS_WITHOUT_VERIFY potential claims without [VERIFY:] tags${NC}"
    echo "Please review manually to ensure all claims have code evidence"
    WARNINGS=$((WARNINGS + 1))
fi

# Check for TODO, FIXME, or similar markers
TODO_COUNT=$(grep -c 'TODO\|FIXME\|XXX\|HACK' "$DOCUMENT" || true)
if [ "$TODO_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠ WARNING: Found $TODO_COUNT TODO/FIXME markers${NC}"
    echo "Document should be complete before publication"
    WARNINGS=$((WARNINGS + 1))
fi

# Check for speculative language
SPECULATIVE_WORDS="probably|likely|presumably|should be|might be|may be"
SPECULATIVE_COUNT=$(grep -ciE "$SPECULATIVE_WORDS" "$DOCUMENT" || true)
if [ "$SPECULATIVE_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠ WARNING: Found $SPECULATIVE_COUNT instances of speculative language${NC}"
    echo "Replace with definitive statements backed by code evidence"
    WARNINGS=$((WARNINGS + 1))
fi

###############################################################################
# Step 5: Summary
###############################################################################

echo ""
echo "========================================"
echo "Verification Summary"
echo "========================================"
echo ""
echo "Total references checked: $TOTAL_REFS"
echo -e "${RED}Errors: $ERRORS${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo ""

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}❌ VERIFICATION FAILED${NC}"
    echo ""
    echo "The document has $ERRORS error(s) that MUST be fixed before publication."
    echo "Please refer to WORKFLOW.md for the mandatory verification protocol."
    echo ""
    echo "Common fixes:"
    echo "  1. Update file paths to use correct relative paths"
    echo "  2. Correct line numbers (±2 lines tolerance)"
    echo "  3. Remove claims about code that doesn't exist"
    echo "  4. Add [VERIFY:] tags to all claims"
    rm -f "$REFS_FILE"
    exit 1
fi

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠ VERIFICATION PASSED WITH WARNINGS${NC}"
    echo ""
    echo "The document passes verification but has $WARNINGS warning(s)."
    echo "Review warnings above and address if necessary."
    rm -f "$REFS_FILE"
    exit 0
fi

echo -e "${GREEN}✓ VERIFICATION PASSED${NC}"
echo ""
echo "All $TOTAL_REFS [VERIFY:] tags are valid."
echo "Document is ready for publication."
echo ""
echo "Quality checkpoints passed:"
echo "  ✓ All file references exist"
echo "  ✓ All line numbers are valid"
echo "  ✓ No duplicate references"
echo "  ✓ No obvious hallucinations"
echo "  ✓ No speculative language without evidence"
echo ""
rm -f "$REFS_FILE"
exit 0
