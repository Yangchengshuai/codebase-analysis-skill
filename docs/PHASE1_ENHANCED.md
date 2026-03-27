# Phase 1 Enhanced: Global Exploration with Mandatory Analysis Planning

> **Purpose**: Phase 1 must produce complete "deep analysis targets" list
> **Date**: 2026-03-27
> **Key**: Every identified module/thread gets Phase 4 analysis

---

## Enhanced Phase 1 Methodology

### Output Requirements (Phase 1必须输出)

Phase 1 **必须**生成以下清单：

```markdown
## Phase 1 Output: Complete Module Inventory

### Core Algorithm Modules (核心算法模块)
- [ ] Module A: [Name, Function, Code Location, Complexity]
- [ ] Module B: [Name, Function, Code Location, Complexity]
- [ ] Module C: [Name, Function, Code Location, Complexity]

### Threading Architecture (线程架构)
- [ ] Thread 1: [Name, Main Function, Key Algorithms]
- [ ] Thread 2: [Name, Main Function, Key Algorithms]
- [ ] Thread 3: [Name, Main Function, Key Algorithms]
- [ ] Thread 4: [Name, Main Function, Key Algorithms]

### Data Flow Stages (数据流阶段)
- [ ] Stage 1: [Function, Input/Output, Modules Involved]
- [ ] Stage 2: [Function, Input/Output, Modules Involved]
- [ ] Stage 3: [Function, Input/Output, Modules Involved]

---

## Deep Analysis Targets (深度分析目标)

### Mandatory Rule (强制规则)

> **Every item in Phase 1 inventory MUST have corresponding Phase 4 deep analysis**
>
> **Phase 1中的每一项都必须有对应的Phase 4深度分析**

```python
# Rule implementation
for item in Phase1.inventory:
    assert item in Phase4.deep_analysis_documents, \
        f"Missing analysis for: {item.name}"

# Only exceptions:
if item.code_lines < 50:  # Very simple utility
    skip("Too simple for deep analysis")
    if item.is_comment_only:
        skip("No implementation")
```

---

## Phase 1.5: Analysis Planning (NEW)

### Purpose

Generate explicit plan for Phase 4 deep analysis.

### Process

```
Phase 1: Global Exploration
    ↓ Output: Module inventory
    ↓
Phase 1.5: Analysis Planning (NEW)
    ├─ Step 1: Prioritize modules
    │   - By complexity (code lines, math density)
    │   - By performance criticality
    │   - By design tradeoff presence
    │
    ├─ Step 2: Group related algorithms
    │   - Thread 1 → 3 algorithm documents
    │   - Thread 2 → 1 algorithm document
    │   - Thread 3 → 1-2 algorithm documents
    │   - Thread 4 → 1 algorithm document
    │
    ├─ Step 3: Generate document plan
    │   For each target:
    │     - Document title
    │     - Expected length (1500-3000 lines)
    │     - Key code locations
    │     - Mathematical focus areas
    │     - Performance profiling points
    │
    └─ Output: PHASE4_PLAN.md
    ↓
Phase 4: Execute plan
    └─ Generate all planned documents
```

---

## Example: Voxel-SLAM Phase 1.5 Output

### Document: PHASE4_PLAN.md

```markdown
# Phase 4 Deep Analysis Plan (Voxel-SLAM)

**Generated**: 2026-03-27
**Status**: Ready for execution

---

## Analysis Targets (分析目标)

### Thread 1: Main Thread (主线程)

**Priority**: HIGH (Core functionality)

#### ALGORITHM_02: 体素地图构建与维护
- **Status**: ✅ Completed (2,219 lines)
- **Code Locations**:
  - [VERIFY: VoxelSLAM/src/voxel_map.hpp:24-65] - Downsampling
  - [VERIFY: VoxelSLAM/src/voxel_map.hpp:267-272] - PCA
  - [VERIFY: VoxelSLAM/src/voxel_map.hpp:935-950] - Octree
- **Mathematical Focus**:
  - Voxel coordinate transformation
  - Incremental variance propagation
  - PCA eigendecomposition
- **Performance Profile**:
  - Total: 24.7ms/frame
  - Bottleneck: Eigendecomposition (29.6%)

#### ALGORITHM_03: IMU状态估计与预积分
- **Status**: ✅ Completed (1,666 lines)
- **Code Locations**:
  - [VERIFY: VoxelSLAM/src/preintegration.hpp:11-135] - Preintegration
  - [VERIFY: VoxelSLAM/src/ekf_imu.hpp:8-150] - EKF propagation
- **Mathematical Focus**:
  - Continuous-time dynamics
  - IMU preintegration theory
  - Jacobian derivations
- **Performance Profile**:
  - 200 Hz propagation
  - Covariance: 15×15 matrix

#### ALGORITHM_04: 激光雷达测量模型
- **Status**: ✅ Completed (1,598 lines)
- **Code Locations**:
  - [VERIFY: VoxelSLAM/src/loop_refine.hpp:86-110] - Point-to-plane
  - [VERIFY: VoxelSLAM/src/voxel_map.hpp:108-241] - LidarFactor
- **Mathematical Focus**:
  - Point-to-plane distance derivation
  - Analytic Jacobian
  - Hessian accumulation
- **Performance Profile**:
  - 600×600 Hessian
  - LM iteration: ~2ms

---

### Thread 2: Local BA Thread (局部BA线程)

**Priority**: HIGH (Performance critical)

#### ALGORITHM_05: 局部束调整算法 (PENDING)
- **Estimated Length**: 1,500-1,800 lines
- **Code Locations**:
  - [VERIFY: VoxelSLAM/src/voxelslam.cpp:876-920] - Thread function
  - [VERIFY: VoxelSLAM/src/voxel_map.hpp:108-290] - LidarFactor class
  - [VERIFY: VoxelSLAM/src/voxel_map.hpp:293-XXX] - Lidar_BA_Optimizer
- **Mathematical Focus**:
  - Sliding window optimization
  - Schur complement marginalization
  - Multi-threaded Hessian accumulation
- **Performance Analysis**:
  - ~50ms per iteration
  - 100-frame window
- **Key Design Decisions**:
  - Why sliding window?
  - Why Schur complement?
  - Thread synchronization strategy

---

### Thread 3: Loop Closure Thread (闭环检测线程)

**Priority**: MEDIUM (Important but less frequent)

#### ALGORITHM_06: 闭环检测算法 (PENDING)
- **Estimated Length**: 1,800-2,000 lines
- **Code Locations**:
  - [VERIFY: VoxelSLAM/src/voxelslam.cpp:923-XXX] - Thread function
  - [VERIFY: VoxelSLAM/src/BTC.h] - BTC descriptor
  - [VERIFY: VoxelSLAM/src/BTC.cpp] - BTC implementation
  - [VERIFY: VoxelSLAM/src/loop_refine.hpp] - Loop refinement
- **Mathematical Focus**:
  - BTC descriptor formulation
  - Multi-session matching
  - Pose graph optimization
- **Performance Analysis**:
  - Triggered by keyframe insertion
  - Computationally expensive
- **Key Design Decisions**:
  - Why BTC (Binary Triangle Context)?
  - Multi-session strategy
  - Loop verification criteria

---

### Thread 4: Global Mapping Thread (全局建图线程)

**Priority**: MEDIUM (Final optimization)

#### ALGORITHM_07: 全局优化算法 (PENDING)
- **Estimated Length**: 1,600-1,800 lines
- **Code Locations**:
  - [VERIFY: VoxelSLAM/src/voxelslam.cpp:970-XXX] - Thread function
  - [VERIFY: VoxelSLAM/src/loop_refine.hpp:XXX-XXX] - Pose graph
- **Mathematical Focus**:
  - Hierarchical pose graph
  - Partitioned bundle adjustment
  - GTSAM integration
- **Performance Analysis**:
  - Triggered after loop closure
  - Can take several seconds
- **Key Design Decisions**:
  - Hierarchical vs flat optimization?
  - Partitioning strategy
  - GTSAM solver selection

---

## Summary Statistics

### Planned Documents

| Thread | Documents | Est. Lines | Status |
|--------|-----------|------------|--------|
| Thread 1 | 3 | 5,483 | ✅ Complete |
| Thread 2 | 1 | ~1,500 | ⏳ Pending |
| Thread 3 | 1 | ~1,800 | ⏳ Pending |
| Thread 4 | 1 | ~1,600 | ⏳ Pending |
| **Total** | **6** | **~13,000** | **50% done** |

### Coverage Target

- [ ] Thread 1: 100% complete
- [ ] Thread 2: 0% → 100% complete
- [ ] Thread 3: 0% → 100% complete
- [ ] Thread 4: 0% → 100% complete

**Success Criteria**: All threads ≥ 90% analyzed

---

## Execution Order

### Phase 4 Execution Sequence

1. ✅ Thread 1 algorithms (completed)
2. ⏳ Thread 2 algorithm
3. ⏳ Thread 3 algorithm
4. ⏳ Thread 4 algorithm
5. ⏳ QUESTIONS_XX: Design decisions

### Verification

After each document:
- [ ] Length ≥ 1500 lines?
- [ ] ≥ 3 mathematical derivations?
- [ ] ≥ 20 [VERIFY:] tags?
- [ ] All claims code-backed?

After completion:
- [ ] All Phase 1 targets covered?
- [ ] Total lines ≥ 10,000?
- [ ] Verification script passes?

---

**Next Step**: Execute Phase 4 for Thread 2,3,4
