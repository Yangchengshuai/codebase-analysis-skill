# Fresh Codebase Handling Guide

> **Purpose**: How to analyze freshly git cloned codebases
> **Date**: 2026-03-27
> **Key Principle**: Skill auto-enhances context via /init if CLAUDE.md is missing, with graceful fallback to code-only analysis

---

## Core Decision: Auto-Enhance with /init, Graceful Fallback (自动增强，优雅降级)

### Strategy (v2.1)

**✅ Auto-run /init if CLAUDE.md is missing, but NEVER fail if /init is unavailable**:

1. **Auto-enhancement**
   - If CLAUDE.md missing → automatically run `/init` to generate it
   - Provides better context: build commands, conventions, architecture
   - One-time cost (~1-3 min), reused for subsequent analyses

2. **Graceful fallback**
   - If `/init` fails or is unavailable → continue with code-only analysis
   - If `/init` produces poor CLAUDE.md → detect and ignore
   - Analysis always completes regardless of /init success

3. **Standalone capability preserved**
   - Git repository has all essential information:
     - Code structure (directories, files)
     - Build system (CMakeLists.txt, package.xml)
     - Git history (commits, branches)
     - Documentation (README.md)
   - `/init` is an **enhancement**, not a **requirement**

4. **User experience**
   - "Just works" out of the box — no manual /init needed
   - Transparent: user sees what's happening during auto-/init
   - Best quality by default (with CLAUDE.md) without extra steps

---

## CLAUDE.md Detection Strategy (CLAUDE.md检测策略)

### Principle: Detect, Don't Depend (检测但不依赖)

```
┌─────────────────────────────────────────────────────────────┐
│ Codebase Analysis Workflow with CLAUDE.md Detection        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Start: User runs /codebase-analysis /path/to/repo         │
│                                                             │
│  Step 1: Check for CLAUDE.md                                │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ if exists(CLAUDE.md):                                │   │
│  │     print("Found CLAUDE.md, reading project info...")│   │
│  │     context = read_CLAUDE_md()                       │   │
│  │     use_context = True                                │   │
│  │ else:                                                 │   │
│  │     print("No CLAUDE.md - auto-running /init...")    │   │
│  │     /init  # Auto-generate CLAUDE.md (v2.1)          │   │
│  │     if exists(CLAUDE.md):                            │   │
│  │         context = read_CLAUDE_md()                   │   │
│  │         use_context = True                            │   │
│  │     else:                                             │   │
│  │         print("/init failed, using code structure")  │   │
│  │         context = None                                │   │
│  │         use_context = False                           │   │
│  │ ✓ Continue analysis either way                        │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                             │
│  Step 2: Analyze Code Structure (Primary)                 │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ This is the MAIN analysis, independent of CLAUDE.md   │   │
│  │ - Scan directory structure                            │   │
│  │ - Identify build system                               │   │
│  │ - Find main entry points                              │   │
│  │ - Detect programming language                         │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                             │
│  Step 3: Incorporate CLAUDE.md Context (If Available)    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ if use_context:                                      │   │
│  │     - Look for build commands in CLAUDE.md          │   │
│  │     - Check for project-specific conventions          │   │
│  │     - Note team-specific guidelines                  │   │
│  │ - Cross-reference with code structure findings       │   │
│  │ else:                                                │   │
│  │     - Use standard analysis heuristics               │   │
│  │     - Infer from directory structure                 │   │
│  │     - Use build files (CMakeLists.txt, etc.)         │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                             │
│  Step 4: Generate Analysis Output                        │
│  └─→ Markdown documents (independent of CLAUDE.md)       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Implementation: CLAUDE.md Detection

### In skill.md - Add Early Detection

```markdown
## Phase 0: Project Context Detection (项目上下文检测)

**Purpose**: Detect and utilize existing project documentation

### Step 0.1: Check for CLAUDE.md

```bash
# Check if CLAUDE.md exists
if [ -f "CLAUDE.md" ]; then
  echo "✓ Found CLAUDE.md - reading project context"
  # Read key sections:
  # - Project type
  # - Build commands
  # - Key conventions
else
  echo "ℹ No CLAUDE.md - using code structure analysis only"
  # Continue with standard analysis
fi
```

**Important**: Analysis continues regardless of CLAUDE.md existence!

### Step 0.2: Detect Project Type

**From code structure (not CLAUDE.md)**:

```bash
# Detect project type automatically
if [ -f "package.xml" ] || [ -f "CMakeLists.txt" ]; then
  PROJECT_TYPE="ROS/Catkin"
elif [ -f "Cargo.toml" ]; then
  PROJECT_TYPE="Rust"
elif [ -f "package.json" ]; then
  PROJECT_TYPE="Node.js"
elif [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
  PROJECT_TYPE="Python"
elif [ -f "go.mod" ]; then
  PROJECT_TYPE="Go"
else
  PROJECT_TYPE="Generic"
fi
```

### Step 0.3: Detect Build System

```bash
# Auto-detect build system
if [ -f "CMakeLists.txt" ]; then
  BUILD_SYSTEM="CMake"
  BUILD_CMD="cmake && make"
elif [ -f "Makefile" ]; then
  BUILD_SYSTEM="Make"
  BUILD_CMD="make"
elif [ -f "package.json" ]; then
  BUILD_SYSTEM="npm"
  BUILD_CMD="npm install && npm build"
else
  BUILD_SYSTEM="Unknown"
  BUILD_CMD="Unknown"
fi
```

---

## What Information from CLAUDE.md? (从CLAUDE.md获取什么信息？)

### If CLAUDE.md Exists, Extract:

1. **Project Type** (项目类型)
   ```markdown
   ## Project Overview
   - **Type**: ROS package, Rust crate, etc.
   ```

2. **Build Commands** (构建命令)
   ```markdown
   ## Build and Run
   ```bash
   cd ~/catkin_ws && catkin_make
   ```
   ```

3. **Key Conventions** (关键约定)
   ```markdown
   ## Important Implementation Notes
   - Thread-unsafe: XXX
   - Memory limit: YYY
   ```

4. **Team-Specific Guidelines** (团队指南)
   ```markdown
   ## Instructions
   - Always use FATAL for errors
   - Don't use C++ exceptions
   ```

### If CLAUDE.md Missing, Infer:

1. **Project Type** from directory structure
2. **Build Commands** from build files
3. **Conventions** from code patterns
4. **Guidelines** from common practices

---

## Example: Fresh Voxel-SLAM Clone

### Scenario

```bash
# User clones repo
git clone https://github.com/hku-mars/Voxel-SLAM.git
cd Voxel-SLAM

# No CLAUDE.md (fresh clone!)
$ ls CLAUDE.md
ls: CLAUDE.md: No such file or directory

# User runs analysis
/codebase-analysis .

# Skill detects:
✓ Project type: ROS/Catkin (from package.xml)
✓ Build system: CMake (from CMakeLists.txt)
✓ Language: C++ (from .cpp files)
✓ No CLAUDE.md - using code structure analysis

# Analysis continues normally
→ ANALYSIS_00-SystemOverview.md
→ ANALYSIS_01-DataStructures.md
→ ALGORITHM_XX-*.md
```

### With CLAUDE.md (if user created one)

```bash
# User adds CLAUDE.md (optional)
cat > CLAUDE.md << 'EOF'
# Voxel-SLAM

## Build
cd ~/catkin_ws && catkin_make

## Important
- Multi-threaded: 4 threads
- Memory limit: 8GB
EOF

# Skill detects:
✓ Found CLAUDE.md - reading context
✓ Project type: ROS (from package.xml) [confirmed]
✓ Build commands: cd ~/catkin_ws && catkin_make [from CLAUDE.md]
✓ Key info: 4 threads, 8GB limit [from CLAUDE.md]

# Enhanced analysis with CLAUDE.md context
```

---

## CLAUDE.md Handling (CLAUDE.md处理策略)

### Important Constraints

✅ **DO** auto-generate CLAUDE.md via `/init` if missing
- Only runs when CLAUDE.md doesn't exist
- Uses `/init` (Claude Code native command) to generate
- Transparent: user sees progress messages

✅ **DO** work without CLAUDE.md if /init fails
- Skill is standalone — /init failure is non-fatal
- Analysis based on code alone
- Graceful fallback with clear messaging

❌ **DON'T** prompt user to manually create CLAUDE.md
- Auto-/init handles this transparently
- No extra steps required from user

✅ **DO** document this in skill output
- Mention CLAUDE.md was auto-generated or not found
- Analysis proceeds either way
- User can regenerate CLAUDE.md later if needed

---

## Quality: With vs Without CLAUDE.md

| Aspect | Without CLAUDE.md | With CLAUDE.md |
|--------|------------------|----------------|
| **Analysis possible?** | ✅ Yes | ✅ Yes |
| **Project type detection** | ✅ Auto (from files) | ✅ Auto + confirmed |
| **Build commands** | ⚠ Inferred | ✅ Accurate |
| **Team conventions** | ❌ Not available | ✅ Available |
| **Analysis depth** | ✅ Same | ✅ Same (maybe enhanced) |
| **Time to analyze** | ✅ Same | ✅ Same |
| **User setup required** | ✅ None | ✅ None |

**Conclusion**: CLAUDE.md provides **enhancement**, not **requirement**

---

## Updated Skill Methodology

### Phase 0: Context Detection (NEW)

```markdown
## Phase 0: Project Context Detection & Auto-Initialization

**Purpose**: Detect project type, auto-generate CLAUDE.md if missing
**Time**: < 1 second (if CLAUDE.md exists) or 1-3 minutes (auto-/init)

**Steps**:
1. Detect CLAUDE.md (if exists, read it; if not, auto-run /init)
2. Detect project type from code structure
3. Detect build system from build files
4. Store context for later phases

**Output**:
- PROJECT_TYPE: ROS/Rust/Python/etc.
- BUILD_SYSTEM: CMake/Cargo/npm/etc.
- HAS_CLAUDE_MD: true/false
- PROJECT_CONTEXT: dict (if CLAUDE.md exists)

**Verification**:
- [ ] Detection works without CLAUDE.md?
- [ ] Detection enhanced with CLAUDE.md?
- [ ] No failure if CLAUDE.md missing?
```

---

## Summary (总结)

### For Your Questions

**Q1: 是否需要/init步骤？**

**A**: ✅ **自动执行（v2.1），但非必需**

**理由**：
- v2.1 自动在缺少 CLAUDE.md 时运行 /init（零配置）
- /init 失败时优雅降级，继续代码分析
- 用户无需手动运行 /init
- Git clone的代码已包含足够信息用于基础分析

**Q2: 是否需要CLAUDE.md判断？**

**A**: ✅ **需要，但要正确处理**

**策略**：
```
if exists(CLAUDE.md):
  read it, use context  # Enhancement
else:
  auto_run_init()       # Auto-generate CLAUDE.md (v2.1)
  if init_succeeded:
    read CLAUDE.md      # Use enhanced context
  else:
    continue analysis   # Graceful fallback
```

**关键原则**：
1. ✅ **检测CLAUDE.md**：有就读取
2. ✅ **自动增强**：没有时自动 /init 生成（v2.1）
3. ✅ **不依赖CLAUDE.md**：/init 失败也能分析
4. ✅ **代码优先**：主要依赖代码结构本身

---

## Implementation Plan

### Update skill.md

Add Phase 0 with CLAUDE.md detection.

### Update WORKFLOW.md

Add "Fresh Clone Handling" section.

### Test on Voxel-SLAM

```bash
# Test 1: Fresh clone (no CLAUDE.md)
/codebase-analysis /path/to/your/project

# Test 2: Verify all threads analyzed
# Should generate 7 algorithm documents, ~13,000 lines

# Test 3: Verify output quality
# Run verification script on all generated documents
```

---

**Status**: Ready to implement and test
**Key Decision**: Auto-/init enhancement with graceful fallback, CLAUDE.md is optional but auto-generated
**Next**: Update skill and test on fresh Voxel-SLAM copy
