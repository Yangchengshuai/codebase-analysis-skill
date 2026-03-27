# Code Reference Checklist

Use this checklist to verify all claims in analysis documentation.

## Before Starting Analysis

- [ ] **Understand the Goal**: What specific aspect am I analyzing?
- [ ] **Locate Source Files**: Where is the relevant code located?
- [ ] **Identify Key Files**: List all files to be analyzed

## During Analysis

### For Each Claim Made

- [ ] **Can I provide file:line:column evidence?**
  - File exists: ✓ Verified with \`ls\` or \`find\`
  - Line exists: ✓ Verified with \`wc -l\`
  - Content matches: ✓ Verified with \`grep\` or direct reading

- [ ] **Have I read the actual code?**
  - Not just the function signature
  - Not just comments
  - Actual implementation logic

- [ ] **Is the code quote accurate?**
  - No typos in variable names
  - Correct logic operators
  - Proper indentation maintained

- [ ] **Are there edge cases I missed?**
  - Early returns
  - Error handling paths
  - Conditional branches
  - Macro-based variations

### For Data Structures

- [ ] **Is it a struct or class?**
  - [ ] Verified: \`typedef struct\` vs \`class\`
  - [ ] Checked for inheritance
  - [ ] Verified all fields

- [ ] **Memory layout correct?**
  - [ ] Field sizes verified
  - [ ] Alignment considered
  - [ ] Padding understood

### For Functions/Methods

- [ ] **Function signature correct?**
  - [ ] Return type verified
  - [ ] All parameters listed
  - [ ] Default values noted

- [ ] **Implementation understood?**
  - [ ] Main logic traced
  - [ ] All branches identified
  - [ ] Side effects noted

- [ ] **Dependencies identified?**
  - [ ] Functions called
  - [ ] Global state used
  - [ ] External dependencies

### For Algorithms

- [ ] **Complexity analysis correct?**
  - [ ] Loops identified
  - [ ] Recursion traced
  - [ ] Hidden iterations found

- [ ] **Edge cases covered?**
  - [ ] Boundary conditions
  - [ ] Empty inputs
  - [ ] Maximum values

## After Analysis

### Cross-Verification

- [ ] **Do all references resolve?**
  - [ ] File paths valid
  - [ ] Line numbers in range
  - [ ] Links work

- [ ] **Are there contradictions?**
  - [ ] No conflicting claims
  - [ ] Consistent terminology
  - [ ] Logical flow maintained

### Final Review

- [ ] **No hallucinations**
  - [ ] Every claim has evidence
  - [ ] No assumptions without proof
  - [ ] No speculation presented as fact

- [ ] **Verification tags present**
  - [ ] \`[VERIFY: file:line]\` tags used
  - [ ] Tags are specific
  - [ ] Tags are accurate

- [ ] **ASCII diagrams accurate**
  - [ ] Match code structure
  - [ ] Relationships correct
  - [ ] Flow direction proper

## Common Gotchas Check

### Hallucinating Features
- [ ] Feature actually exists in code
- [ ] Not confused with similar project
- [ ] Not assuming "standard" implementation

### Misinterpreting Structures
- [ ] Read actual definition
- [ ] Checked typedef vs class
- [ ] Verified all fields exist

### Wrong Data Flow
- [ ] Traced actual execution
- [ ] Not assuming direction
- [ ] Verified order of operations

### Missing Code Paths
- [ ] All if/else branches documented
- [ ] Early returns noted
- [ ] Error paths included

### Assuming Behavior
- [ ] Read implementation
- [ ] Not trusted function name
- [ ] Verified side effects

## Sign-Off

**Analyst**: ____________________

**Date**: ____________________

**Verification Method**:
- [ ] Automated script (verify_analysis.sh)
- [ ] Manual review
- [ ] Both

**Result**:
- [ ] ✓ All checks passed
- [ ] ⚠ Passed with warnings
- [ ] ✗ Failed - corrections needed

---

**Remember**: When in doubt, read the code again. Being right is more important than being interesting.
