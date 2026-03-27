# Gotchas: Common Pitfalls in Codebase Analysis

> **TL;DR**: This is the most valuable section in this skill. These patterns represent predictable failures that occur during code analysis. Learn them, watch for them, and prevent them.

---

## Core Principle

> **All analysis MUST be based on actual code. If you cannot point to a specific file, line, and column, it doesn't exist.**

---

## Gotcha #1: Hallucinating Features

### Pattern
Describing functionality that doesn't exist in the codebase.

### Why It Happens
- Claude's pattern completion tendency
- Assuming "standard" implementations exist
- Inferring from similar projects
- Filling gaps in understanding

### Detection
```
❌ Bad: "The system uses a factory pattern for object creation"
✓ Good: "The system uses factory pattern (src/factory.cpp:45-82, Factory::create())"
```

**Verification Check:**
```bash
# Before documenting any feature, verify it exists:
grep -r "Factory::create" src/
```

### Prevention Checklist
- [ ] Can I provide file:line for this claim?
- [ ] Have I read the actual implementation?
- [ ] Does the code confirm this behavior?
- [ ] Am I projecting from another codebase?

---

## Gotcha #2: Misinterpreting Data Structures

### Pattern
Incorrectly describing data structure relationships or fields.

### Why It Happens
- Reading struct definitions without understanding usage
- Assuming conventional naming patterns
- Missing typedefs or macros
- Not seeing the full inheritance hierarchy

### Real Example from fastlivo2
```
❌ Wrong: "VoxelPlane is a class with methods"
✓ Correct: "VoxelPlane is actually a typedef struct (include/voxel_map.h:405)"
```

**Verification Check:**
```cpp
// Always read the ACTUAL definition, not assumptions
typedef struct VoxelPlane {
    // ... actual fields
} VoxelPlane;  // It's a struct, not a class!
```

### Detection
```bash
# Find actual definitions, not declarations
grep -A 20 "struct VoxelPlane" include/voxel_map.h
grep -A 20 "class VoxelPlane" include/voxel_map.h  # Won't find it!
```

### Prevention Checklist
- [ ] Read the full struct/class definition
- [ ] Check for typedef vs class
- [ ] Verify field types and sizes
- [ ] Understand memory layout
- [ ] Check for macros that change meaning
- [ ] Look for inheritance/polymorphism

---

## Gotcha #3: Wrong Data Flow Direction

### Pattern
Reversing or misrouting data flow through the system.

### Why It Happens
- Assuming conventional patterns
- Not tracing actual execution
- Confusing producer/consumer
- Missing intermediate transformations

### Real Example
```
❌ Wrong: "IMU data flows to ESIKF, then to laser processor"
✓ Correct: "Laser processor → ESIKF update → IMU propagation → next frame"
```

**Verification Check:**
```bash
# Trace actual function calls in order
grep -n "stateEstimationAndMapping" src/LIVMapper.cpp
# Read the function, follow the flow line by line
```

### Detection
- **Always read the main loop/entry function**
- **Follow execution line-by-line**
- **Don't assume "standard" patterns**

### Prevention Checklist
- [ ] Have I read the main execution path?
- [ ] Can I trace data from input to output?
- [ ] Do I understand each transformation step?
- [ ] Have I verified the order with actual code?

---

## Gotcha #4: Missing Code Paths

### Pattern
Documenting only the happy path, ignoring error handling, edge cases, or alternative flows.

### Why It Happens
- Focusing on main logic
- Assuming error paths are "obvious"
- Not reading conditionals fully
- Missing macro-based code paths

### Real Example
```
❌ Incomplete: "UpdateOctoTree inserts points into the octree"
✓ Complete: "UpdateOctoTree handles 4 cases:
   1. Uninitialized → accumulate points (src/voxel_map.cpp:1057-1067)
   2. Already plane → update if enabled (src/voxel_map.cpp:1070-1087)
   3. Not plane, depth < max → recurse to children (src/voxel_map.cpp:1090-1116)
   4. Not plane, depth = max → accumulate and try plane fit (src/voxel_map.cpp:1119-1134)"
```

**Verification Check:**
```cpp
// Always read ALL branches of conditionals
if (condition1) {
    // Branch 1
} else if (condition2) {
    // Branch 2  // Don't miss this!
} else {
    // Branch 3  // Or this!
}
```

### Prevention Checklist
- [ ] Have I identified all if/else branches?
- [ ] Are there early returns I missed?
- [ ] Do error paths have side effects?
- [ ] Are there macro-based conditional compilations?
- [ ] Do all enum values have case handlers?

---

## Gotcha #5: Assuming Function Behavior

### Pattern
Describing what a function "should" do instead of what it actually does.

### Why It Happens
- Inferring from function names
- Assuming standard library behavior
- Not reading the implementation
- Missing overloaded versions

### Real Example
```
❌ Assumption: "addFrameRef() adds a frame reference to the end of the list"
✓ Reality: "addFrameRef() uses push_front, adds to the FRONT (include/visual_point.h:135)"
```

**Verification Check:**
```cpp
// Always read the function body, never assume from name
void VisualPoint::addFrameRef(Feature *ftr) {
    obs_.push_front(ftr);  // NOT push_back!
}
```

### Detection
```bash
# Find the implementation, not just declaration
grep -A 10 "void.*addFrameRef" src/vio.cpp
# Or
grep -A 10 "addFrameRef" include/visual_point.h
```

### Prevention Checklist
- [ ] Have I read the function implementation?
- [ ] Did I check for overloaded versions?
- [ ] Do I understand the actual behavior vs name?
- [ ] Are there side effects I missed?
- [ ] Does it modify state in unexpected ways?

---

## Gotcha #6: Incorrect Algorithm Complexity

### Pattern
Stating wrong time/space complexity without analyzing the actual implementation.

### Why It Happens
- Assuming "standard" algorithm implementations
- Not considering hidden loops
- Missing recursive calls
- Ignoring data structure choices

### Real Example
```
❌ Wrong: "Voxel lookup is O(log n) due to tree structure"
✓ Correct: "Voxel lookup is O(1) hash table + O(log n) tree traversal"
```

**Verification Check:**
```cpp
// Count actual operations, not assumptions
auto iter = voxel_map_.find(location);  // O(1) hash
if (iter != voxel_map_.end()) {
    VoxelOctoTree *tree = iter->second->find_correspond(pw);  // O(log n)
}
// Total: O(1) + O(log n)
```

### Prevention Checklist
- [ ] Have I identified all loops?
- [ ] Are there recursive calls?
- [ ] What data structures are used?
- [ ] Are there hidden iterations (e.g., std::vector::erase)?
- [ ] Do early returns affect worst case?

---

## Gotcha #7: Missing Initialization/Setup Code

### Pattern
Documenting the "steady state" behavior without understanding initialization.

### Why It Happens
- Focusing on main loop
- Assuming constructors are "obvious"
- Missing static initializers
- Not reading setup scripts

### Real Example
```
❌ Incomplete: "ESIKF processes sensor data"
✓ Complete: "ESIKF requires:
   1. Static initialization: gravity, bias estimation (src/LIVMapper.cpp:200-250)
   2. State vector initialization (include/common_lib.h:StatesGroup)
   3. Covariance matrix setup (src/IMU_Processing.cpp:estimateBias())
   Then processes sensor data..."
```

**Verification Check:**
```bash
# Find constructors and initialization functions
grep -n "StatesGroup::" src/*.cpp
grep -n "init\|setup\|initialize" src/main.cpp
```

### Prevention Checklist
- [ ] Have I found the initialization code?
- [ ] Do I understand what's set up before main loop?
- [ ] Are there static/global initializers?
- [ ] What's the startup sequence?
- [ ] Are required preconditions documented?

---

## Gotcha #8: Ignoring Macro Magic

### Pattern
Missing behavior changes caused by macros, template specialization, or code generation.

### Why It Happens
- Macros are hard to search
- Template code looks the same but behaves differently
- Preprocessor output not visible
- Configuration macros change behavior

### Real Example
```
❌ Missed: "plane_ptr_->is_plane_ determines if it's a plane"
✓ Complete: "#ifdef USE_NEW_PLANE_DETECTION changes plane fitting behavior
   (include/voxel_map.h:line 89)"
```

**Verification Check:**
```bash
# Search for macro definitions
grep -r "define.*PLANE" include/
grep -r "#ifdef" src/voxel_map.cpp
```

### Prevention Checklist
- [ ] Are there #ifdef/#ifndef blocks?
- [ ] Do macros change behavior?
- [ ] Are there template specializations?
- [ ] Is code generated (macros, templates)?
- [ ] What configuration options exist?

---

## Gotcha #9: Forgetting Thread Safety

### Pattern
Documenting single-threaded behavior when code is multi-threaded.

### Why It Happens
- Reading one function in isolation
- Missing mutex/lock usage
- Not seeing thread creation
- Assuming sequential execution

### Real Example
```
❌ Wrong: "updateReferencePatch() updates normal vectors"
✓ Complete: "updateReferencePatch() runs in separate thread (src/vio.cpp:1895),
   uses mutex for feat_map access (include/vio.h:VOXEL_POINTS)"
```

**Verification Check:**
```bash
# Search for threading keywords
grep -rn "thread\|mutex\|lock\|async" src/
grep -rn "pthread\|std::thread" src/
```

### Prevention Checklist
- [ ] Are there multiple threads?
- [ ] What locks protect shared data?
- [ ] Are there race conditions?
- [ ] What's the synchronization model?
- [ ] Can functions run concurrently?

---

## Gotcha #10: Verification Blind Spots

### Pattern
Making claims without verification checkpoints.

### Why It Happens
- Tiredness/complacency
- Time pressure
- Overconfidence
- Forgetting to add tags

### The Fix: Mandatory Verification Tags

Every claim MUST have a verification tag:

```markdown
## Claim: The system uses octree for spatial indexing

**Evidence**:
- [VERIFY: src/voxel_map.cpp:VoxelOctoTree::find_correspond()] - Recursive tree traversal
- [VERIFY: include/voxel_map.h:352] - VoxelOctoTree structure definition
- [VERIFY: src/voxel_map.cpp:460] - Child node indexing: `leafnum = 4*xyz[0] + 2*xyz[1] + xyz[2]`

**Verification Steps**:
1. Read VoxelOctoTree class definition ✓
2. Trace find_correspond() execution ✓
3. Verify 8-child structure in code ✓
```

### Prevention Checklist
- [ ] Does every claim have a VERIFY tag?
- [ ] Can I provide file:line for each point?
- [ ] Have I actually read that code?
- [ ] Would a skeptic be convinced?

---

## Anti-Hallucination Protocol

Before finalizing ANY analysis document:

### Step 1: Code Evidence Audit
```bash
# For each claim, verify evidence exists
grep -n "claimed_function_name" src/actual_file.cpp
```

### Step 2: Cross-Reference Check
```markdown
Claim: "Function A calls Function B"

Check:
- [ ] Can I find Function A in code? (file:line)
- [ ] Can I find Function B in code? (file:line)
- [ ] Does Function A actually call B? (verified by reading)
- [ ] Is the call site marked? (FunctionA:line_number)
```

### Step 3: Sanity Check
- [ ] Does this make sense architecturally?
- [ ] Are there contradictions elsewhere?
- [ ] Would a developer familiar with the code agree?
- [ ] Can I defend this under code review?

---

## Gotcha #11: Insufficient Depth (⭐ NEW - Most Important for fastlivo2-style Analysis)

### Pattern
Generating superficial overview documents instead of deep, fastlivo2-style analysis with mathematical derivations, step-by-step flows, and code-level details.

### Why It Happens
- Stopping at "what" instead of explaining "why" and "how"
- Skipping mathematical derivations
- Providing high-level descriptions without step-by-step breakdown
- Not drilling down to individual code sections
- Missing comparison with alternative approaches

### Real Example from Voxel-SLAM Analysis

❌ **Insufficient Depth** (Current output):
```markdown
## IMU EKF
The system uses an EKF for IMU state estimation.
It estimates position, velocity, and orientation.
[VERIFY: ekf_imu.hpp]
```

✅ **fastlivo2-Style Depth** (What we should generate):
```markdown
## IMU EKF State Estimation

### Mathematical Model

**State Vector** (19维):
```
x = [δθ (3), δp (3), δt_exp (1), δv (3), δb_g (3), δb_a (3), δg (3)]
```

**State Transition**:
```
x_{k+1} = f(x_k, u_k) + w_k
```
Where:
- `f()`: Nonlinear state transition function
- `u_k`: IMU measurements (acceleration, angular velocity)
- `w_k`: Process noise ~ N(0, Q_k)

### Step-by-Step Update Flow

**Step 0: IMU Preintegration** (ekf_imu.hpp:150-200)
```cpp
// [VERIFY: ekf_imu.hpp:175-189]
void IMUEKF::propagation() {
    // 1. Get IMU measurements
    // 2. Compensate for bias
    // 3. Integrate using RK4
}
```
- Input: Raw IMU data
- Output: Preintegrated ΔR, Δv, Δp
- Complexity: O(1) per IMU sample

**Step 1: State Prediction** (ekf_imu.hpp:201-250)
- Propagate state: x̂_{k|k-1} = f(x̂_{k-1|k-1}, u_k)
- Propagate covariance: P_{k|k-1} = F_k P_{k-1|k-1} F_k^T + Q_k
- [Detailed math with each matrix element]

[Continue with 10+ more steps...]

### Code-Level Analysis

**Function: propagate_state()** (Lines 201-250)
```cpp
// Section 1: Jacobian calculation (Lines 201-220)
F_k = I + F*dt + 0.5*F²*dt²  // [VERIFY: line 215]

// Section 2: Covariance propagation (Lines 221-235)
P_new = F_k * P * F_k.transpose() + Q  // [VERIFY: line 230]

// Section 3: State update (Lines 236-250)
x_new = x + f(x, u) * dt  // [VERIFY: line 245]
```
- Line 215: Uses first-order approximation
- Line 230: Cholesky decomposition for numerical stability
- Line 245: RK4 integration with adaptive step size

### Design Rationale

**Why RK4 instead of Euler?**
| Method | Accuracy | Stability | Speed | Choice |
|--------|----------|-----------|-------|--------|
| Euler | O(dt) | Poor | Fast | ❌ Rejected |
| RK2 | O(dt²) | Fair | Medium | ❌ Rejected |
| **RK4** | **O(dt⁴)** | **Good** | **Slow but acceptable** | **✅ Chosen** |
| RK45 | O(dt⁵) | Excellent | Very slow | ❌ Overkill |

**Evidence**: [VERIFY: ekf_imu.hpp:180] Comment "RK4 for accuracy"
```

### Detection

**Symptoms of insufficient depth**:
- ❌ Documents < 1000 lines
- ❌ Missing mathematical derivations
- ❌ No step-by-step breakdowns
- ❌ No code-level line-by-line analysis
- ❌ No comparison tables
- ❌ No "why this design" explanations

**Verification check**:
```bash
# Count lines - should be 1500-3000 for deep analysis
wc -l ALGORITHM_XX-*.md

# Check for math derivations
grep -n "derivation\|formula\|equation" ALGORITHM_XX-*.md

# Check for step-by-step
grep -n "Step [0-9]:" ALGORITHM_XX-*.md

# Check for code snippets
grep -n "```cpp" ALGORITHM_XX-*.md | wc -l  # Should be 20+
```

### Prevention Checklist

For each algorithm/module:
- [ ] Have I provided complete mathematical formulation?
- [ ] Are all variables defined with types and ranges?
- [ ] Have I derived key formulas step-by-step?
- [ ] Is there a detailed step-by-step execution flow?
- [ ] Have I analyzed the code at line level?
- [ ] Are there comparison tables for design decisions?
- [ ] Have I explained "why" for each major choice?
- [ ] Is the document > 1500 lines (for complex algorithms)?
- [ ] Are there 20+ code snippets with line references?
- [ ] Have I identified bottlenecks with evidence?

### Required Depth Targets

**For Algorithm Flow Documents**:
- **Minimum length**: 1500 lines
- **Math sections**: 3+ complete derivations
- **Step breakdown**: 10+ detailed steps
- **Code snippets**: 20+ with line numbers
- **Comparison tables**: 3+ design decision comparisons
- **ASCII diagrams**: 5+ detailed flowcharts

**For Q&A Documents**:
- **Minimum length**: 800 lines
- **Questions**: 10+ answered in depth
- **Each answer**: 50+ lines with code evidence
- **Comparison tables**: 5+ for design choices
- **Config guidance**: Scenario-specific recommendations

---

## Gotcha #12: Missing Mathematical Derivations

### Pattern
Stating formulas without showing derivation steps or explaining variable meanings.

### Why It Happens
- Assuming formulas are self-evident
- Not understanding the math deeply enough
- Time pressure to skip derivations
- Copying formulas without comprehension

### Real Example

❌ **Missing Derivation**:
```markdown
The covariance propagates as:
P_{k|k-1} = F_k P_{k-1|k-1} F_k^T + Q_k
```

✅ **Complete Derivation**:
```markdown
### Covariance Propagation Derivation

**Starting from linearized system**:
```
x_{k+1} = F_k x_k + w_k
```

**Covariance definition**:
```
P_k = E[(x_k - μ_k)(x_k - μ_k)^T]
```

**Step 1: Substitute state equation**
```
P_{k+1} = E[(F_k x_k + w_k - F_k μ_k)(F_k x_k + w_k - F_k μ_k)^T]
```

**Step 2: Expand and simplify**
```
P_{k+1} = E[F_k(x_k - μ_k)(x_k - μ_k)^T F_k^T] + E[w_k w_k^T]
        = F_k E[(x_k - μ_k)(x_k - μ_k)^T] F_k^T + Q_k
        = F_k P_k F_k^T + Q_k
```

**Where**:
- `F_k`: Jacobian matrix ∂f/∂x evaluated at current state
- `Q_k`: Process noise covariance, diagonal matrix
- Assumption: State noise and process noise uncorrelated

**Evidence**:
- [VERIFY: ekf_imu.hpp:230] - Actual implementation
- [VERIFY: ekf_imu.hpp:45-60] - Q_k definition
```

### Detection
- [ ] Does every formula have variable definitions?
- [ ] Are derivation steps shown?
- [ ] Can I reproduce the derivation myself?
- [ ] Are assumptions stated?

### Prevention Checklist
- [ ] Define every variable (symbol, meaning, type, range)
- [ ] Show step-by-step derivation
- [ ] State all assumptions
- [ ] Link to implementation code
- [ ] Provide numerical examples if helpful

---

## Gotcha #13: Skipping Step-by-Step Flows

### Pattern
Describing algorithms at high level without detailed step breakdown.

### Why It Happens
- Summarizing instead of expanding
- Not reading all the code paths
- Assuming readers can fill gaps
- Effort avoidance (detailed analysis is hard work)

### Real Example

❌ **High-Level Only**:
```markdown
The function processes point clouds by first downsampling,
then transforming to world frame, and finally inserting
into the voxel map.
```

✅ **Step-by-Step Breakdown**:
```markdown
### Complete Point Cloud Processing Flow

**Input**: Raw point cloud from LiDAR sensor

**Step 0: Validate Input** (voxel_map.cpp:1042-1045)
```cpp
if (feats_undistort.empty()) return;  // Early exit
```
- Check: Empty cloud?
- Action: Skip processing if empty

**Step 1: Voxel Grid Downsampling** (voxel_map.cpp:1048-1062)
```cpp
down_sampling_pvec(feats_undistort, voxel_size, feats_down);
```
- Method: Hash-based voxel grid
- Parameters: voxel_size from config
- Output: feats_down (reduced points)
- Complexity: O(n) where n = input points

**Step 2: Transform to World Frame** (voxel_map.cpp:1065-1075)
```cpp
for (auto &pt : feats_down) {
    V3D pw = R_wb * pt + t_wb;  // Transform
    // [VERIFY: voxel_map.cpp:1070]
}
```
- Transformation: p_w = R_wb * p_b + t_wb
- Source: R_wb, t_wb from current state estimate
- Method: Eigen::Matrix3d multiplication

**Step 3: Update Voxel Map** (voxel_map.cpp:1078-1095)
```cpp
voxelmap_manager_->BuildVoxelMap(feats_down_world);
```
- Calls: BuildVoxelMap with transformed points
- Sub-operation: Insert into octree
- Sub-operation: Plane fitting if enough points
- [Continue with 5 more sub-steps...]

**Step 4: Cleanup** (voxel_map.cpp:1098-1100)
```cpp
feats_down.clear();
pl_keep.clear();
```
- Free memory
- Prepare for next iteration

**Total: 4 main steps + 12 sub-steps**
```

### Detection
- [ ] Can I break the algorithm into 10+ steps?
- [ ] Does each step have code location?
- [ ] Are intermediate states shown?
- [ ] Is the flow diagrammed?

### Prevention Checklist
- [ ] Identify all major steps (aim for 8-15)
- [ ] For each step: provide code location
- [ ] Show input/output for each step
- [ ] Document any branching/conditionals
- [ ] Include ASCII flow diagram
- [ ] Note complexity for each step

---

## Gotcha #14: No Design Rationale

### Pattern
Describing what the code does without explaining why it was designed that way.

### Why It Happens
- Easy to see "what", harder to understand "why"
- Design decisions not documented in code
- Not comparing with alternatives
- Missing git history/context

### Real Example

❌ **What-Only Description**:
```markdown
The system uses a hash table + octree hybrid structure
for voxel storage.
```

✅ **With Design Rationale**:
```markdown
### Data Structure Choice: Hash Table + Octree Hybrid

**What**: Two-level indexing structure
- Level 1: Hash table maps voxel coordinate → octree root
- Level 2: Octree stores points within voxel

**Why Hybrid?**

**Alternative 1: Pure Octree**
```
Pros:
  - Hierarchical culling
  - Natural spatial clustering
Cons:
  - O(log n) lookup even for empty voxels
  - High memory overhead for sparse data
  - Complex rebalancing
```
**Rejected because**: Voxel-SLAM operates in large sparse environments

**Alternative 2: Pure Hash Table**
```
Pros:
  - O(1) average lookup
  - Low memory overhead
  - Simple implementation
Cons:
  - No hierarchical structure
  - Can't cull empty space efficiently
  - Poor cache locality
```
**Rejected because**: Need hierarchical queries for plane fitting

**Chosen: Hybrid (Hash + Octree)**
```
Pros:
  - O(1) voxel lookup (hash table)
  - O(log n) point query within voxel (octree)
  - Memory efficient for sparse data
  - Hierarchical plane fitting
Cons:
  - Slightly higher complexity
  - Two data structures to maintain
```

**Evidence for design decision**:
- [VERIFY: voxel_map.hpp:340] Comment: "Hash-based outer, octree inner"
- [VERIFY: git commit abc123] "Switched to hybrid structure for sparsity"
- [VERIFY: CLAUDE.md:82] Rationale documented

**Performance impact**:
- Lookup: O(1) + O(log n) vs O(log n) for pure octree
- Memory: 40% lower for sparse environments
- Plane fitting: 3x faster due to hierarchical culling
```

### Detection
- [ ] For each major choice, do I explain why?
- [ ] Have I listed alternatives considered?
- [ ] Is there a comparison table?
- [ ] Are trade-offs documented?

### Prevention Checklist
- [ ] Identify 3-5 major design choices
- [ ] For each: list 2-3 alternatives
- [ ] Create comparison table (pros/cons)
- [ ] Search code/git for rationale evidence
- [ ] Document trade-offs explicitly

---

## Gotcha #15: Missing Performance Analysis

### Pattern
Not analyzing computational complexity, bottlenecks, or optimization opportunities.

### Why It Happens
- Focusing on correctness, not performance
- Not profiling the code
- Missing timing/performance comments
- Not considering scalability

### Real Example

❌ **No Performance Analysis**:
```markdown
The function processes all points and updates the map.
```

✅ **With Performance Analysis**:
```markdown
### Performance Analysis of Voxel Update

**Profiling Results** (from built-in profiler):
```
Total time: 15.3 ms per frame
├── Hash lookup: 1.2 ms (7.8%)
├── Octree traversal: 3.4 ms (22.2%) ← BOTTLENECK
├── Plane fitting: 8.9 ms (58.2%) ← BOTTLENECK
└── Memory allocation: 1.8 ms (11.8%)
```

**Bottleneck 1: Plane Fitting (58.2% of time)**

**Code location**: [VERIFY: voxel_map.cpp:1200-1250]

**Why it's slow**:
1. SVD computation: O(n³) where n = points in voxel (avg 50)
2. Repeated for every updated voxel (avg 100 voxels/frame)
3. No early termination for degenerate cases

**Optimization opportunities**:
```
Current: Full SVD for every voxel
Option A: Incremental SVD (update from previous fit)
  Speedup: ~3x for sequential updates
  Effort: Medium (need to store previous SVD)
  Status: Not implemented (comment at line 1245)

Option B: Early termination if variance low
  Speedup: ~2x for planar voxels
  Effort: Low (simple variance check)
  Status: IMPLEMENTED [VERIFY: line 1210]

Option C: Parallel plane fitting
  Speedup: ~4x on 4-core
  Effort: Low (#pragma omp parallel)
  Status: TODO [VERIFY: line 1199: // TODO: parallelize]
```

**Implemented optimizations**:
1. **Variance pre-check** (line 1210-1215)
   - If point variance < threshold, skip SVD
   - Speedup: 25% for planar scenes
   - Evidence: [VERIFY: git log --oneline] "Optimization: early plane termination"

2. **Cached plane parameters** (line 1255)
   - Store previous fit, reuse if points similar
   - Speedup: 40% for static scenes
   - Evidence: [VERIFY: voxel_map.hpp:Plane::last_fit]

**Memory bandwidth analysis**:
- Random access pattern: Poor cache locality
- Suggested optimization: Sort points by voxel before processing
- Expected speedup: 1.5x
- Status: Not implemented
```

### Detection
- [ ] Have I identified the bottleneck?
- [ ] Are there timing breakdowns?
- [ ] Are optimization opportunities listed?
- [ ] Is complexity analysis correct?

### Prevention Checklist
- [ ] Profile the code (or infer complexity)
- [ ] Identify the slowest operation
- [ ] Suggest 2-3 optimization opportunities
- [ ] Document any existing optimizations
- [ ] Analyze memory access patterns
- [ ] Consider scalability with input size

---

## Summary Table

| Gotcha | Detection | Prevention | Priority |
|--------|-----------|------------|----------|
| **Insufficient depth** | Line count, math sections | 1500+ lines, 3+ derivations | ⭐⭐⭐ |
| **Missing math** | Check for formulas with derivations | Derive every formula | ⭐⭐⭐ |
| **Skipping steps** | Count steps in flow | 10+ detailed steps | ⭐⭐⭐ |
| **No rationale** | Look for "why" explanations | Compare alternatives | ⭐⭐ |
| **No performance** | Check for profiling | Analyze bottlenecks | ⭐⭐ |
| Hallucinating features | grep for evidence | Always provide file:line | ⭐⭐⭐ |
| Misinterpreting structs | Read actual definition | Check typedef vs class | ⭐⭐ |
| Wrong data flow | Trace execution path | Read main loop line-by-line | ⭐⭐ |
| Missing code paths | Check all conditionals | Map all branches | ⭐⭐ |
| Assuming behavior | Read implementation | Never trust function names | ⭐⭐ |
| Wrong complexity | Count operations | Analyze actual loops/calls | ⭐ |
| Missing init | Find constructors | Document startup sequence | ⭐ |
| Macro magic | Search #ifdef | List all config macros | ⭐ |
| Thread safety | Search thread/mutex | Document concurrency model | ⭐ |
| No verification | Add VERIFY tags | Mandatory evidence tags | ⭐⭐⭐ |

---

**Remember (Updated)**:
- **OLD**: Be RIGHT, not interesting. Boring but accurate is better than exciting but wrong.
- **NEW**: Be RIGHT AND DEEP. fastlivo2-style means:
  - Complete mathematical derivations
  - Step-by-step algorithm breakdowns
  - Code-level line-by-line analysis
  - Design rationale with comparisons
  - Performance profiling and optimization
  - 1500-3000 lines per algorithm document
  - 800-1000 lines per Q&A document

**Depth is not optional** - it's the core value of technical documentation.
