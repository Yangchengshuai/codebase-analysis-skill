# Codebase Analysis Skill

> A Claude Code skill that generates deep, verified technical documentation from source code — zero hallucination, full traceability.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-purple)](https://claude.ai/code)
[![Version](https://img.shields.io/badge/version-2.1.0-green)](CHANGELOG.md)

**English** | [中文](#中文说明)

---

## What It Does

Point this skill at any codebase and it systematically produces publication-quality technical documentation:

```
/codebase-analysis /path/to/your/project
```

**Output** — structured `.md` files covering:

| Document | Content | Typical Size |
|----------|---------|-------------|
| **System Overview** | Architecture, modules, threading, dependencies | 500-800 lines |
| **Data Structures** | Complete struct/class breakdowns with diagrams | 600-1000 lines |
| **Algorithm Deep Dives** | Math derivations, step-by-step flows, code analysis | 1,500-3,000 lines each |
| **Key Functions** | Line-by-line logic, call graphs, performance notes | 500-1,000 lines each |
| **Q&A Documentation** | Design rationale, configuration guidance, pitfalls | 500-1,000 lines each |

### Key Features

- **Anti-Hallucination** — Every claim requires `[VERIFY: file:line]` code evidence. No exceptions.
- **Auto-Initialization** — No CLAUDE.md? Automatically runs `/init` first for best context.
- **Complete Coverage** — Phase 1.5 planning guarantees all modules/threads get analyzed.
- **Bilingual** — English + Chinese headings throughout.
- **Visual** — ASCII architecture diagrams, data flow charts, structure visualizations.
- **Verifiable** — Automated `verify_all_refs.sh` script validates every code reference.

---

## Quick Start

### Prerequisites

- [Claude Code](https://claude.ai/code) CLI installed
- oh-my-claudecode (OMC) plugin, or manual skill installation

### Install

**Option A: With OMC (Recommended)**

```bash
# Clone into your skills directory
git clone https://github.com/Yangchengshuai/codebase-analysis-skill.git \
  ~/.claude/plugins/marketplaces/omc/skills/codebase-analysis
```

**Option B: Manual Installation**

```bash
# Clone anywhere
git clone https://github.com/Yangchengshuai/codebase-analysis-skill.git
# Then reference skill.md in your Claude Code configuration
```

### Usage

```bash
# Analyze any project
/codebase-analysis /path/to/project

# Analyze a specific module
/codebase-analysis src/core/StateEstimator

# Analyze with focus
/codebase-analysis --focus=algorithms src/
```

---

## How It Works

The skill follows an 8-phase progressive refinement methodology:

```
Phase 0: Project Context Detection    ← Auto-detect type, auto-/init if needed
Phase 1: Global Exploration           ← Architecture, modules, threads
Phase 1.5: Analysis Planning          ← Explicit plan for 100% coverage
Phase 2: Data Structure Analysis      ← Struct/class deep dive
Phase 3: Data Flow Analysis           ← Data movement tracing
Phase 4: Algorithm Deep Dive          ← Math + code, 1500-3000 lines each
Phase 5: Key Function Analysis        ← Line-by-line logic
Phase 6: Q&A Documentation            ← Design rationale, configuration
Phase 7: Verification & Review        ← Automated + manual validation
```

### Verification Workflow

Every analysis passes through a mandatory 5-step verification:

```
Code Reading → Draft Generation → Code Verification → Fix Discrepancies → Final Output
```

**Quality Gate**: Zero unverified claims. Every `[VERIFY: file:line]` tag is validated.

---

## Example Output

Generated for [Voxel-SLAM](https://github.com/hku-mars/Voxel-SLAM) (a LiDAR-Inertial SLAM system):

```
Voxel-SLAM/
├── ANALYSIS_00-SystemOverview.md          (559 lines)
├── ANALYSIS_01-DataStructures.md          (702 lines)
├── ALGORITHM_02-体素地图构建与维护.md      (2,219 lines)
├── ALGORITHM_03-IMU状态估计与预积分.md    (1,666 lines)
└── ALGORITHM_04-激光雷达测量模型.md        (1,598 lines)

Total: 6,744 lines of verified technical documentation
```

Sample output excerpt:

```markdown
### Voxel Map Downsampling

**Implementation**:
[VERIFY: VoxelSLAM/src/voxel_map.hpp:46-48]
```cpp
pp.first.pnt = (pp.first.pnt * pp.second + pv.pnt) / (pp.second + 1);
```

This implements the running average formula:
μ_new = (μ_old · n + x_new) / (n + 1)

Where pp.first.pnt = μ_new, pp.second = n, pv.pnt = x_new
```

---

## Project Structure

```
codebase-analysis-skill/
├── skill.md                    # Main skill definition (8-phase methodology)
├── WORKFLOW.md                 # Mandatory verification workflow
├── Gotchas.md                  # 15 common analysis pitfalls & prevention
├── CHANGELOG.md                # Version history
├── LICENSE                     # MIT License
│
├── templates/                  # Document templates
│   ├── system_overview.md      # Architecture overview template
│   ├── data_structures.md      # Data structure analysis template
│   ├── algorithm_flow.md       # Deep algorithm analysis template
│   └── key_questions.md        # Q&A documentation template
│
├── verification/               # Verification tools
│   ├── verify_all_refs.sh      # Automated [VERIFY:] tag checker
│   ├── verify_analysis.sh      # Full analysis verification
│   └── code_reference_checklist.md
│
├── helpers/                    # Helper scripts
│   ├── ascii_diagrams.sh       # ASCII diagram utilities
│   └── code_ref_formatter.sh   # Code reference formatting
│
├── docs/                       # Detailed documentation
│   ├── ANALYSIS_FLOW.md        # Progressive refinement explained
│   ├── INIT_GUIDE.md           # Fresh clone handling
│   ├── PHASE1_ENHANCED.md      # Phase 1 enhanced methodology
│   └── PHASE4_GUIDE.md         # Algorithm deep dive guide
│
└── examples/                   # Usage examples
    └── voxel-slam-sample.md    # Sample output from Voxel-SLAM
```

---

## Verification Tools

### Automated Tag Verification

```bash
# Verify all [VERIFY:] tags in a document
./verification/verify_all_refs.sh ANALYSIS_00-SystemOverview.md

# Output:
# ✓ [VERIFY: src/voxel_map.hpp:46] - Valid
# ✓ [VERIFY: src/voxelslam.cpp:52] - Valid
# ❌ [VERIFY: BTC.h/BTC.cpp] - Malformed (combined path)
#
# Summary:
# - Total tags: 113
# - Valid: 112
# - Malformed: 1
```

---

## Tested On

| Project | Language | Size | Output | Coverage |
|---------|----------|------|--------|----------|
| [Voxel-SLAM](https://github.com/hku-mars/Voxel-SLAM) | C++ (ROS) | ~10K LOC | 6,744 lines | 4 threads |
| *Your project here?* | | | | |

---

## Contributing

Contributions are welcome! Here's how you can help:

1. **Test on new codebases** — Try it on your project and report results
2. **Improve templates** — Better document structures for specific domains
3. **Fix Gotchas** — Share new pitfalls you discover
4. **Add language support** — Templates for Rust, Go, Python, etc.

### Development Setup

```bash
git clone https://github.com/Yangchengshuai/codebase-analysis-skill.git
cd codebase-analysis-skill

# Test verification tools
./verification/verify_all_refs.sh test_document.md

# Install as Claude Code skill (OMC)
cp -r . ~/.claude/plugins/marketplaces/omc/skills/codebase-analysis
```

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'Add my feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a Pull Request

---

## FAQ

**Q: Does this work with any programming language?**
A: Yes. The methodology is language-agnostic. Templates work for C++, Python, Rust, Go, Java, and more.

**Q: How is this different from asking Claude to "analyze my code"?**
A: Three things: (1) Structured 8-phase methodology ensures nothing is missed, (2) Mandatory `[VERIFY:]` tags prevent hallucination, (3) Automated verification tools validate every code reference.

**Q: What if my project doesn't have CLAUDE.md?**
A: The skill auto-detects project type from code structure. If you have Claude Code's `/init`, it will automatically generate CLAUDE.md for enhanced context.

**Q: How long does analysis take?**
A: First run (with auto-/init): ~7 minutes. Subsequent runs: ~5 minutes. Depends on codebase size.

**Q: Can I use this without oh-my-claudecode?**
A: Yes. The core methodology is in `skill.md` which can be used as a prompt with any Claude Code session. OMC just provides the `/codebase-analysis` trigger.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Inspired by the [fastlivo2-tech-docs](https://github.com/Yangchengshuai/fastlivo2-tech-docs) documentation style
- Tested on [Voxel-SLAM](https://github.com/hku-mars/Voxel-SLAM) codebase
- Built for [Claude Code](https://claude.ai/code) and [oh-my-claudecode](https://github.com/yeachan-heo/oh-my-claudecode)

---

<a id="中文说明"></a>

## 中文说明

> 一个 Claude Code 技能，从源代码生成深度、可验证的技术文档 —— 零幻觉，全追溯。

### 核心特点

- **防幻觉机制** — 每个论断都需要 `[VERIFY: 文件:行号]` 代码证据
- **自动初始化** — 无 CLAUDE.md？自动运行 `/init` 获取最佳上下文
- **完整覆盖** — Phase 1.5 规划确保所有模块/线程都被分析
- **双语输出** — 英文 + 中文标题贯穿全文
- **可视化** — ASCII 架构图、数据流图、结构可视化
- **可验证** — 自动化 `verify_all_refs.sh` 脚本验证每个代码引用

### 快速开始

```bash
# 安装
git clone https://github.com/Yangchengshuai/codebase-analysis-skill.git \
  ~/.claude/plugins/marketplaces/omc/skills/codebase-analysis

# 使用
/codebase-analysis /path/to/your/project
```

### 8 阶段方法论

```
Phase 0: 项目上下文检测     ← 自动检测类型，缺少 CLAUDE.md 时自动 /init
Phase 1: 全局探索           ← 架构、模块、线程
Phase 1.5: 分析规划         ← 100% 覆盖率的明确计划
Phase 2: 数据结构分析       ← 结构体/类深入分析
Phase 3: 数据流分析         ← 数据流动追踪
Phase 4: 算法深度分析       ← 数学推导 + 代码，每篇 1500-3000 行
Phase 5: 关键函数分析       ← 逐行逻辑分析
Phase 6: 问题解答文档       ← 设计原理、配置指南
Phase 7: 验证与复核         ← 自动化 + 人工验证
```

### 示例输出

Voxel-SLAM（激光雷达-惯性 SLAM 系统）分析结果：

```
总计: 6,744 行经过验证的技术文档
覆盖率: 4 个线程 100% 覆盖
质量: A+ (98/100)
```

### 贡献

欢迎贡献！请 fork 并提交 Pull Request。

### 许可证

MIT License — 详见 [LICENSE](LICENSE) 文件。
