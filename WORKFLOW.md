# Codebase Analysis Mandatory Workflow

> **CRITICAL**: This workflow is **mandatory** for all codebase analysis tasks.
> Skipping any step compromises analysis integrity.

---

## Core Principle (核心原则)

> **All claims MUST be verified against actual code. No exceptions.**

**分析必须结合代码，所有断言必须可追溯到代码实现。**

---

## Workflow Overview (流程概览)

```
┌─────────────────────────────────────────────────────────────┐
│          Mandatory Analysis & Verification Workflow         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐│
│  │ 1. Code      │───▶│ 2. Generate  │───▶│ 3. Verify    ││
│  │    Reading   │    │    Draft     │    │   Against    ││
│  │              │    │              │    │    Code      ││
│  └──────────────┘    └──────────────┘    └──────────────┘│
│         │                                       │          │
│         │ Mandatory                              │ Mandatory │
│         ▼                                       ▼          │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 4. Fix Discrepancies (iterate until 100% match)     │  │
│  └──────────────────────────────────────────────────────┘  │
│                             │                               │
│                             ▼                               │
│                    ┌──────────────┐                        │
│                    │ 5. Final     │                        │
│                    │    Output    │                        │
│                    └──────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Step-by-Step Workflow (详细步骤)

### Step 1: Code Reading (代码阅读) ⚠️ **MANDATORY**

**Rule**: **Cannot generate any analysis without reading actual code.**

**Required Actions**:

1.1 **Read Source Files**
```bash
# Must read ALL files mentioned in analysis
Read /path/to/file.cpp
Read /path/to/file.hpp
Grep "pattern" /path/to/codebase/src/
```

**Checkpoint**:
- [ ] Have I read the actual implementation files?
- [ ] Do I understand the code structure?
- [ ] Can I locate specific lines for claims?

1.2 **Trace Execution Flow**
```bash
# Follow actual code paths, not assumptions
Grep "function_name" src/ --include="*.cpp" --include="*.hpp"
```

1.3 **Verify Data Structures**
```bash
# Read actual struct/class definitions
Grep -A 20 "struct StructName" src/
Grep -A 20 "class ClassName" src/
```

**Forbidden**:
- ❌ Describing features without reading code
- ❌ Assuming "standard" implementations
- ❌ Inferring from project name or documentation

---

### Step 2: Generate Draft (生成草稿)

**With Mandatory Verification Tags**

**Every claim MUST include**:

```markdown
**Claim**: [Description]

**Evidence**:
- [VERIFY: /relative/path/to/file:line]  # Specific code reference
```

**Example**:

```markdown
### Algorithm: Voxel Map Downsampling

**Implementation**:
```cpp
// [VERIFY: VoxelSLAM/src/voxel_map.hpp:24-65]
void down_sampling_pvec() {
  // Actual code from file
  pp.first.pnt = (pp.first.pnt * pp.second + pv.pnt) / (pp.second + 1);
}
```

**Line-by-line analysis**:
- Line 46: Updates running mean
- Line 47: Propagates variance

**Checkpoint**:
- [ ] Every claim has [VERIFY:] tag?
- [ ] File paths are correct relative paths?
- [ ] Line numbers are accurate?
```

---

### Step 3: Verify Against Code (代码校验) ⚠️ **MANDATORY**

**3.1 Automated Verification**

Run automated checks:

```bash
# Extract all VERIFY tags
grep -o "VERIFY: [^:]*:[0-9]*" document.md | sort | uniq > verify_tags.txt

# Check each reference
while read tag; do
  file=$(echo $tag | cut -d: -f2)
  line=$(echo $tag | cut -d: -f3)
  echo "Checking $file:$line"
  # Verify file exists
  # Verify line exists and contains relevant code
done < verify_tags.txt
```

**3.2 Manual Verification Checklist**

For **each** [VERIFY:] tag in document:

```markdown
## Verification for [VERIFY: path/to/file:line]

- [ ] File exists at specified path?
- [ ] Line number is accurate (±5 lines)?
- [ ] Code at line supports the claim?
- [ ] No misinterpretation of code logic?
- [ ] Function/class names are correct?
```

**3.3 Cross-Reference Validation**

```bash
# Verify all cross-references resolve
grep -o "See.*\[VERIFY:" document.md | \
  while read ref; do
    # Check referenced section exists
    # Check referenced code exists
  done
```

**3.4 Mathematical Verification**

For all mathematical formulas:

- [ ] Formula matches code implementation?
- [ ] Variable names correspond to code variables?
- [ ] Indices and bounds are correct?
- [ ] Derivation is mathematically sound?

**Example Verification**:

```
Claim: "The algorithm uses running average formula: μ_new = (μ_old * n + x_new) / (n+1)"

Code evidence:
[VERIFY: VoxelSLAM/src/voxel_map.hpp:47]
pp.first.pnt = (pp.first.pnt * pp.second + pv.pnt) / (pp.second + 1);

Verification:
✓ Formula matches code exactly
✓ pp.first.pnt = μ_new
✓ pp.second = n_old
✓ pv.pnt = x_new
✓ Line 47 contains this formula
```

---

### Step 4: Fix Discrepancies (修正差异)

**Iterative Process**:

```
While (discrepancies exist):
  1. Identify discrepancy:
     - Wrong line number?
     - Misinterpreted logic?
     - Hallucinated feature?

  2. Re-read code:
     Read /correct/file/path
     Grep "correct_pattern" src/

  3. Fix document:
     - Correct [VERIFY:] tag
     - Rewrite claim
     - Remove hallucinated content

  4. Re-verify:
     - Go back to Step 3
```

**Common Fixes**:

| Issue | Fix |
|-------|-----|
| Wrong line number | Update tag: `[VERIFY: file:NEW_LINE]` |
| Wrong file path | Use relative path from repo root |
| Misinterpreted logic | Re-read code, rewrite description |
| Hallucinated feature | **DELETE** entirely if not in code |

**Exit Condition**:

```
✓ All [VERIFY:] tags resolve correctly
✓ 100% of claims backed by code evidence
✓ No discrepancies found
```

---

### Step 5: Final Output Generation

**Final Checklist**:

```markdown
## Pre-Publication Verification

### Code References
- [ ] All [VERIFY:] tags tested and valid
- [ ] File paths use correct relative format
- [ ] Line numbers accurate (±2 lines)

### Content Integrity
- [ ] No hallucinated features
- [ ] No speculation without evidence
- [ ] All code snippets from actual files

### Cross-References
- [ ] All internal links resolve
- [ ] All external references exist

### Mathematical Correctness
- [ ] All formulas verified against code
- [ ] Derivations are sound
- [ ] Variables map to code correctly

### Completeness
- [ ] All promised sections present
- [ ] All examples have code evidence
- [ ] All claims explained

**Only when ALL checkboxes are ticked, generate final output.**
```

---

## Quality Gates (质量关卡)

### Gate 1: Pre-Analysis
```
✓ Read actual source files
✓ Understand code structure
✓ Can locate specific implementations
→ If NO: STOP and read more code
```

### Gate 2: Post-Draft
```
✓ Every claim has [VERIFY:] tag
✓ Tags use correct file:line format
→ If NO: Add missing tags before proceeding
```

### Gate 3: Post-Verification
```
✓ 100% of [VERIFY:] tags validated
✓ All discrepancies fixed
→ If NO: Iterate verification until 100%
```

### Gate 4: Pre-Publication
```
✓ Zero hallucinations detected
✓ All mathematical derivations verified
✓ Code snippets match actual files exactly
→ If NO: Fix issues, do not publish
```

---

## Anti-Hallucination Protocol (防幻觉协议)

### Rule 1: No Speculation Without Evidence

```markdown
❌ FORBIDDEN:
"The system probably uses Kalman filtering for state estimation"

✓ REQUIRED:
[VERIFY: src/filter.cpp:145]
"The system uses Kalman filter (KalmanFilter::predict() at line 145)"

❌ FORBIDDEN:
"The algorithm likely runs in O(n log n) time"

✓ REQUIRED:
[VERIFY: src/algorithm.cpp:78-92]
"The algorithm uses binary search, achieving O(log n) per query"
```

### Rule 2: Verify Before Writing

```
Before writing ANY claim:
1. Search codebase for evidence
2. Read actual implementation
3. Add [VERIFY:] tag with exact location
4. Only then write the claim
```

### Rule 3: Delete When Uncertain

```
If cannot find code evidence:
→ DELETE the claim entirely
→ Do not use "likely", "probably", "should"
```

---

## Example Workflow (工作流示例)

### Task: Analyze voxel downsampling algorithm

**Step 1: Read Code**
```bash
# Find implementation
Grep -r "down_sample" VoxelSLAM/src/

# Read actual file
Read VoxelSLAM/src/voxel_map.hpp
# Lines 24-65 contain down_sampling_pvec()
```

**Step 2: Generate Draft with Tags**
```markdown
## Voxel Downsampling

The system uses hash-based voxel grid downsampling:
[VERIFY: VoxelSLAM/src/voxel_map.hpp:24-65]

**Implementation**:
```cpp
// [VERIFY: VoxelSLAM/src/voxel_map.hpp:46-48]
pp.first.pnt = (pp.first.pnt * pp.second + pv.pnt) / (pp.second + 1);
```

This implements running average: μ_new = (μ_old * n + x) / (n+1)
```

**Step 3: Verify**
```bash
# Check file exists
ls VoxelSLAM/src/voxel_map.hpp  # ✓ Exists

# Check line numbers
sed -n '46,48p' VoxelSLAM/src/voxel_map.hpp
# Output: pp.first.pnt = (pp.first.pnt * pp.second + pv.pnt) / (pp.second + 1);
# ✓ Correct

# Verify formula matches
# pp.first.pnt = μ_new ✓
# pp.second = n ✓
# pv.pnt = x ✓
```

**Step 4: Fix if needed**
```markdown
# If line number wrong, update:
[VERIFY: VoxelSLAM/src/voxel_map.hpp:47]  # Fixed line number
```

**Step 5: Final Output**
```markdown
## Voxel Downsampling

[Complete analysis with verified code references]
```

---

## Mandatory Scripts (必需脚本)

### verify_all_refs.sh

```bash
#!/bin/bash
# Verify all [VERIFY:] tags in document

echo "Extracting VERIFY tags..."
grep -o "VERIFY: [^:]*:[0-9]*" $1 | sort | uniq > refs.txt

echo "Checking references..."
while read tag; do
  file=$(echo $tag | cut -d: -f2)
  line=$(echo $tag | cut -d: -f3)

  if [ ! -f "$file" ]; then
    echo "❌ FILE NOT FOUND: $file"
    exit 1
  fi

  if [ $(wc -l < "$file") -lt $line ]; then
    echo "❌ LINE $line OUT OF RANGE in $file"
    exit 1
  fi

  echo "✓ $tag"
done < refs.txt

echo "All references verified!"
```

---

## Summary (总结)

### Non-Negotiable Requirements (不可妥协的要求)

1. ✅ **Must read actual code** before any analysis
2. ✅ **Must include [VERIFY:] tags** for every claim
3. ✅ **Must verify all tags** against code
4. ✅ **Must fix all discrepancies** before output
5. ✅ **Zero tolerance** for hallucinations

### Red Flags (警示信号)

🚩 **Stop if you notice**:
- Analysis without [VERIFY:] tags
- Claims about "typical" implementations
- Speculation about "likely" behavior
- Missing file paths or line numbers
- Code that doesn't match description

### Success Criteria (成功标准)

✅ **Analysis is complete when**:
- 100% of claims have verified code references
- All [VERIFY:] tags tested and valid
- No discrepancies between analysis and code
- Mathematical formulas match implementation
- Zero hallucinations detected

---

**Remember**: The integrity of codebase analysis depends on **rigorous verification against actual code**. Shortcuts compromise the entire analysis.

**Workflow Status**: MANDATORY for all codebase-analysis tasks
**Version**: 2.0
**Last Updated**: 2026-03-27
