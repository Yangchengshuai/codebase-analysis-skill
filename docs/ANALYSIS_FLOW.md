# Codebase Analysis Flow Diagram

> **Process Overview**: How the codebase-analysis skill processes a codebase
> **Date**: 2026-03-27
> **Pattern**: Global-first, then local deep-dive

---

## Analysis Flow (分析流程)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Codebase Analysis Process                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Phase 1: Global Exploration (全局探索)                              │
│  ─────────────────────────────────────────────────────────────────   │
│  "What are the main components and how do they relate?"             │
│                                                                      │
│  Output: ANALYSIS_00-SystemOverview.md (558 lines)                  │
│    ├─ Architecture overview                                         │
│    ├─ Module identification (5 modules for Voxel-SLAM)              │
│    ├─ Threading model (4 threads) ← 您看到的这个！                  │
│    ├─ Data flow pipeline                                           │
│    └─ Key dependencies                                              │
│                                                                      │
│  ⬇ Creates "map" of the codebase                                   │
│                                                                      │
│  Phase 2: Data Structure Analysis (关键数据结构)                    │
│  ─────────────────────────────────────────────────────────────────   │
│  "What are the core data structures?"                               │
│                                                                      │
│  Output: ANALYSIS_01-DataStructures.md (702 lines)                 │
│    ├─ IMUST (IMU state)                                             │
│    ├─ pointVar (point with variance)                                │
│    ├─ Plane (voxel plane parameters)                                │
│    ├─ VOXEL_LOC (spatial indexing)                                  │
│    ├─ ScanPose/Keyframe                                             │
│    └─ STD (loop descriptor)                                         │
│                                                                      │
│  ⬇ Identifies "building blocks"                                    │
│                                                                      │
│  Phase 3: Data Flow Analysis (数据流分析)                            │
│  ─────────────────────────────────────────────────────────────────   │
│  "How does data move through the system?"                           │
│                                                                      │
│  Output: ANALYSIS_02-DataFlow.md (optional, not always generated)   │
│    ├─ Point cloud flow: sensor → voxel map → optimization           │
│    ├─ IMU flow: raw → preintegration → state estimation             │
│    ├─ Threading communication                                       │
│    └─ Inter-module dependencies                                     │
│                                                                      │
│  ⬇ Shows "how things connect"                                      │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │    Decision Point: Which modules need deep analysis?        │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  Phase 4: Algorithm Deep Dive (算法深度分析) ⭐ CORE               │
│  ─────────────────────────────────────────────────────────────────   │
│  "How does each algorithm work in detail?"                          │
│                                                                      │
│  For EACH major algorithm/module:                                  │
│    ┌─────────────────────────────────────────────────────────┐     │
│  ──│ Module 1: Voxel Map Construction (体素地图构建)          │     │
│    │ Output: ALGORITHM_02-体素地图构建与维护.md (2,219 lines) │     │
│    │   ├─ Mathematical formulation (坐标变换、PCA)             │     │
│    │   ├─ Step-by-step flow (5 major steps)                    │     │
│    │   ├─ Code analysis (line 24-65, 267-272, etc.)           │     │
│    │   ├─ Performance: 24.7ms breakdown                         │     │
│    │   └─ Design rationale: hybrid index vs pure octree        │     │
│    └─────────────────────────────────────────────────────────┘     │
│    ┌─────────────────────────────────────────────────────────┐     │
│  ──│ Module 2: IMU State Estimation (IMU状态估计)             │     │
│    │ Output: ALGORITHM_03-IMU状态估计与预积分.md (1,666 lines)│     │
│    │   ├─ Continuous-time dynamics (运动学方程)                │     │
│    │   ├─ Discretization (Euler vs Trapezoidal)               │     │
│    │   ├─ Preintegration theory (偏差雅可比)                  │     │
│    │   ├─ Covariance propagation (EKF, 15×15矩阵)             │     │
│    │   └─ Motion blur correction (逐点变换)                    │     │
│    └─────────────────────────────────────────────────────────┘     │
│    ┌─────────────────────────────────────────────────────────┐     │
│  ──│ Module 3: LiDAR Measurement Model (激光雷达测量模型)       │     │
│    │ Output: ALGORITHM_04-激光雷达测量模型.md (1,598 lines)    │     │
│    │   ├─ Point-to-plane distance derivation                   │     │
│    │   ├─ Jacobian computation (解析推导)                     │     │
│    │   ├─ Hessian accumulation (600×600矩阵)                  │     │
│    │   └─ LM optimization details                              │     │
│    └─────────────────────────────────────────────────────────┘     │
│    ┌─────────────────────────────────────────────────────────┐     │
│  ──│ Module 4+: [Other algorithms as needed]                   │     │
│    │   - Loop closure detection                               │     │
│    │   - Global bundle adjustment                             │     │
│    │   - Feature extraction                                   │     │
│    │   - etc.                                                 │     │
│    └─────────────────────────────────────────────────────────┘     │
│                                                                      │
│  ⬇ Deep understanding of each component                           │
│                                                                      │
│  Phase 5: Key Function Analysis (关键函数分析)                       │
│  ─────────────────────────────────────────────────────────────────   │
│  "What are the critical functions and how do they work?"           │
│                                                                      │
│  For EACH critical function:                                        │
│    - Line-by-line analysis                                          │
│    - Call graph                                                     │
│    - Performance profile                                            │
│    - Numerical stability                                            │
│                                                                      │
│  ⬇ Zooms in on implementation details                               │
│                                                                      │
│  Phase 6: Q&A Documentation (问题解答文档)                            │
│  ─────────────────────────────────────────────────────────────────   │
│  "What design decisions were made and why?"                         │
│                                                                      │
│  Output: QUESTIONS_XX-*.md (800-1000 lines each)                    │
│    ├─ "Why use hybrid index?"                                      │
│    ├─ "How does preintegration avoid re-integration?"              │
│    ├─ "Why trapezoidal vs Euler integration?"                      │
│    ├─ "Configuration guidance for different scenarios"            │
│    └─ "Common pitfalls and solutions"                             │
│                                                                      │
│  ⬇ Explains design rationale and configuration                     │
│                                                                      │
│  Phase 7: Verification and Review (复核校准) ⚠️ MANDATORY           │
│  ─────────────────────────────────────────────────────────────────   │
│  "Is everything verified against actual code?"                      │
│                                                                      │
│  - Verify all [VERIFY:] tags                                        │
│  - Cross-check mathematical formulas                                │
│  - Ensure no hallucinations                                         │
│  - Fix all discrepancies                                            │
│                                                                      │
│  ⬇ Quality gate: Cannot publish without passing                     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Key Insights (关键洞察)

### 1. Progressive Refinement (渐进式精化)

```
Level 1: Global Architecture
    ↓
Level 2: Module Identification
    ↓
Level 3: Data Structures
    ↓
Level 4: Algorithm Details
    ↓
Level 5: Implementation Details
    ↓
Level 6: Design Rationale
```

**每一层都在上一层的"地图"基础上深入**：

- **Phase 1** 画出整个系统的"地图"（5个模块，4个线程）
- **Phase 4** 对每个"地标"进行详细分析（算法推导、代码分析）
- **Phase 6** 回答"为什么这样设计"

### 2. Dependency Graph (依赖关系)

```
Phase 1 (Global Overview)
  ├─→ Phase 2 (Data Structures)
  │     └─→ Phase 4 (Algorithms that use these structures)
  │
  ├─→ Phase 3 (Data Flow)
  │     └─→ Phase 4 (Algorithms in the flow)
  │
  └─→ Phase 4 (Algorithm Analysis)
        ├─→ Phase 5 (Key Functions within algorithms)
        └─→ Phase 6 (Design decisions about algorithms)
```

**Example from Voxel-SLAM**:

```
Phase 1发现:
  - Thread 3: thd_loop_closure() [CLAUDE.md:79]
      ↓
Phase 4深入分析:
  - ALGORITHM_XX-闭环检测算法.md
      ├─ BTC descriptor computation
      ├─ Feature matching
      ├─ Pose graph optimization
      └─ Loop verification
      ↓
Phase 5 (可选):
  - analyze_function("find_loop_candidates")
  - analyze_function("verify_loop_constraint")
      ↓
Phase 6:
  - QUESTIONS_XX-闭环检测配置.md
      ├─ "Why BTC instead of FPFH?"
      ├─ "How to set loop threshold?"
      └─ "Common loop closure failures"
```

### 3. Adaptive Depth (自适应深度)

Skill **不会**对所有内容进行同等深度的分析：

**Deep Analysis** (1500-3000 lines) for:
- ✅ Core algorithms (voxel map, IMU, measurement model)
- ✅ Performance-critical code
- ✅ Complex mathematical formulations

**Overview Only** (500-800 lines) for:
- ⚪ Utility functions
- ⚪ Simple data structures
- ⚪ Straightforward logic

**Decision Criteria**:

```python
def should_deep_analyze(module):
    if module.has_complex_math():
        return True
    if module.is_performance_critical():
        return True
    if module.involves_design_tradeoffs():
        return True
    return False
```

---

## Example: Voxel-SLAM Analysis Progression

### What Actually Happened

**Step 1: Phase 1 - Global Overview**

```
Generated: ANALYSIS_00-SystemOverview.md (558 lines)

Discovered:
├─ 5 main modules
│   ├─ Initialization
│   ├─ Odometry
│   ├─ Local Mapping
│   ├─ Loop Closure
│   └─ Global Mapping
│
├─ 4 threading components ← 您看到的这个！
│   ├─ Main thread (feature + IMU)
│   ├─ thd_localBA_thread()
│   ├─ thd_loop_closure()
│   └─ thd_GBAMapRefine()
│
└─ Key data flow
    └─ Point cloud → Voxel map → Optimization
```

**Step 2: Phase 2 - Data Structures**

```
Generated: ANALYSIS_01-DataStructures.md (702 lines)

Identified:
├─ IMUST (15 DOF state)
├─ pointVar (3×3 covariance)
├─ Plane (normal + center + 6×6 var)
├─ VOXEL_LOC (spatial hash key)
└─ STD (loop descriptor)
```

**Step 3: Decision Point - What to Analyze Deeply?**

Based on Phase 1-2, decided to deep-dive:
1. ✅ Voxel map construction (core, complex math)
2. ✅ IMU estimation (core, preintegration theory)
3. ✅ LiDAR measurement (Jacobian derivation)
4. ❌ Loop closure (important but can be overview)
5. ❌ Global mapping (advanced, can be separate)

**Step 4: Phase 4 - Algorithm Deep Dives**

```
Generated 3 deep algorithm documents:

1. ALGORITHM_02-体素地图构建与维护.md (2,219 lines)
   └─ Focus: Thread 1 (Main thread) voxel processing
      ├─ Hash-based downsampling
      ├─ PCA plane fitting
      └─ Hybrid indexing

2. ALGORITHM_03-IMU状态估计与预积分.md (1,666 lines)
   └─ Focus: Thread 1 (Main thread) IMU handling
      ├─ EKF propagation
      ├─ Preintegration theory
      └─ Motion blur correction

3. ALGORITHM_04-激光雷达测量模型.md (1,598 lines)
   └─ Focus: Thread 1 (Main thread) optimization
      ├─ Point-to-plane distance
      ├─ Jacobian computation
      └─ LM solver
```

**Note**: Not all threads got separate documents yet!

- Thread 1 (Main): ✅ Deeply analyzed (3 docs)
- Thread 2 (Local BA): ⚪ Mentioned in overview, could be separate doc
- Thread 3 (Loop): ⚪ Mentioned in overview, could be separate doc
- Thread 4 (Global): ⚪ Mentioned in overview, could be separate doc

---

## Your Question: Do Threads Get Separate Analysis?

### Answer: It Depends (取决于)

**Current Behavior**:

✅ **Thread 1 (Main)** - 深度分析
- 因为包含核心算法（voxel map, IMU, optimization）
- 生成了3个深度文档（2,219 + 1,666 + 1,598 = 5,483行）

⚪ **Thread 2, 3, 4** - 概述级别
- 在Phase 1的SystemOverview中描述
- 如果需要，可以单独生成深度文档

### When Do Threads Get Separate Docs?

**Criteria for separate thread analysis**:

```python
def should_analyze_thread_separately(thread):
    # Yes if:
    if thread.has_unique_algorithm():
        return True  # e.g., Loop closure has BTC descriptor
    if thread.is_performance_critical():
        return True  # e.g., Local BA runs frequently
    if thread.has_complex_data_structures():
        return True  # e.g., Global mapping has hierarchical pose graph
    return False
```

**For Voxel-SLAM, potential future docs**:

```
ALGORITHM_05-闭环检测算法.md (Loop Closure)
  ├─ BTC descriptor computation
  ├─ Multi-session matching
  ├─ Pose graph optimization
  └─ Thread 3 workflow analysis

ALGORITHM_06-全局优化算法.md (Global Mapping)
  ├─ Hierarchical BA
  ├─ Pose graph partitioning
  └─ Thread 4 workflow analysis

ALGORITHM_07-局部BA算法.md (Local BA)
  ├─ Sliding window optimization
  ├─ Schur complement
  └─ Thread 2 workflow analysis
```

---

## How to Control Analysis Depth (控制分析深度)

### Option 1: By Module (按模块)

```bash
# Analyze specific module only
/codebase-analysis --deep --module=LoopClosure /path/to/Voxel-SLAM

# This would generate:
# - ALGORITHM_XX-闭环检测算法.md (1500-2000 lines)
# - Focused specifically on Thread 3
```

### Option 2: By Threading (按线程)

```bash
# Analyze specific thread workflow
/codebase-analysis --thread=localBA /path/to/Voxel-SLAM

# This would generate:
# - THREAD_02-LocalBA线程工作流.md (1000-1500 lines)
# - Thread synchronization
# - Input/output queues
# - Performance profile
```

### Option 3: By Algorithm (按算法)

```bash
# Analyze specific algorithm regardless of thread
/codebase-analysis --algorithm=voxelMap /path/to/Voxel-SLAM

# Already did this, generated:
# - ALGORITHM_02-体素地图构建与维护.md (2219 lines)
```

---

## Summary (总结)

### The Process Flow

1. **Phase 1 (Global)**: 绘制"地图"
   - 识别模块
   - 识别线程 ← 您看到的Threading Model在这里
   - 识别数据流

2. **Phase 4 (Deep)**: 深入分析"地标"
   - 不是所有线程都单独分析
   - **只对重要/复杂的算法**生成1500+行文档
   - Thread 1被深度分析（3个文档）
   - Thread 2,3,4 在概述中提及，可按需深入

3. **Phase 6 (Q&A)**: 解释"为什么"
   - 设计决策
   - 配置建议

### Answer to Your Question

> **Q**: 会先进行整个的框架梳理，梳理出多线程、多算法模块？后面会对每个线程进行单独的深度分析？

**A**:
- ✅ **是的，先梳理框架**（Phase 1: SystemOverview）
- ⚠️ **但不一定每个线程都单独分析**
- ✅ **核心线程/算法**会深度分析（Thread 1 → 3个文档）
- ⚪ **其他线程**在概述中描述，按需深入

---

## Practical Workflow (实际工作流)

### When You Want Complete Analysis

```bash
# Step 1: Generate overview (includes threading model)
/codebase-analysis /path/to/Voxel-SLAM

# Step 2: Review overview, identify what needs deep analysis
# Look at ANALYSIS_00-SystemOverview.md:
# - Which modules are complex?
# - Which threads have unique algorithms?
# - What's performance-critical?

# Step 3: Request deep analysis for specific components
/codebase-analysis --deep --module=LoopClosure /path/to/Voxel-SLAM
/codebase-analysis --deep --module=GlobalMapping /path/to/Voxel-SLAM

# Step 4: Verify all documents
./verification/verify_all_refs.sh *.md
```

### When You Want Focused Analysis

```bash
# Skip overview, go straight to specific algorithm
/codebase-analysis --deep --algorithm=preintegration /path/to/Voxel-SLAM

# Generates only IMU preintegration analysis
# No need to generate full overview first
```

---

**Key Takeaway**: Skill follows **"progressive refinement"** pattern:
1. Global map first (Phase 1)
2. Identify important landmarks (based on complexity, performance, design tradeoffs)
3. Deep dive into landmarks (Phase 4)
4. Skip/summarize less critical parts

**Not everything gets equal depth** - that's intentional and efficient!
