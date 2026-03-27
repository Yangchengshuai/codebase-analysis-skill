# Codebase Analysis Skill

> A Claude Code skill that generates deep, verified technical documentation from source code — zero hallucination, full traceability.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-Skill-purple)](https://claude.ai/code)
[![Version](https://img.shields.io/badge/version-2.1.0-green)](CHANGELOG.md)

**English** | [中文](#中文说明)

---

## Why This Exists

Asking Claude to "analyze my code" produces shallow, unreliable output. This skill solves that with:

- **Anti-hallucination** — Every claim requires `[VERIFY: file:line]` code evidence. No exceptions.
- **Structured methodology** — 9-phase progressive refinement (Phase 0–7) ensures nothing is missed.
- **Complete coverage** — Phase 1.5 planning guarantees all modules/threads get analyzed.
- **Automated verification** — Built-in scripts validate every code reference after generation.

---

## Quick Start

### Prerequisites

- [Claude Code](https://claude.ai/code) CLI
- [oh-my-claudecode](https://github.com/yeachan-heo/oh-my-claudecode) (OMC), or manual installation

### Install

```bash
# Option A: With OMC (Recommended)
git clone https://github.com/Yangchengshuai/codebase-analysis-skill.git \
  ~/.claude/plugins/marketplaces/omc/skills/codebase-analysis

# Option B: Clone anywhere, then reference skill.md in your Claude Code config
git clone https://github.com/Yangchengshuai/codebase-analysis-skill.git
```

### Usage

```bash
# Analyze a project
/codebase-analysis /path/to/project

# Analyze a specific module
/codebase-analysis src/core/StateEstimator
```

---

## How It Works

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

Every analysis passes through a mandatory 5-step verification pipeline:

```
Code Reading → Draft Generation → Code Verification → Fix Discrepancies → Final Output
```

**Quality Gate**: Zero unverified claims. Every `[VERIFY: file:line]` tag is validated.

---

## Output Format

The skill generates structured `.md` files in the target project directory:

| Document | Content | Typical Size |
|----------|---------|-------------|
| `ANALYSIS_00-SystemOverview.md` | Architecture, modules, threading, dependencies | 500-800 lines |
| `ANALYSIS_01-DataStructures.md` | Complete struct/class breakdowns with diagrams | 600-1,000 lines |
| `ALGORITHM_XX-Name.md` | Math derivations, step-by-step flows, code analysis | 1,500-3,000 lines each |
| `KEY_QUESTIONS-XX.md` | Design rationale, configuration guidance, pitfalls | 500-1,000 lines each |

All output is bilingual (English + Chinese headings) with ASCII architecture diagrams.

---

## Example

Generated for [Voxel-SLAM](https://github.com/hku-mars/Voxel-SLAM) (~10K LOC C++ SLAM system):

```
Total: 6,744 lines of verified technical documentation
Coverage: 4/4 threads (100%)
Quality: A+ (98/100)
Verification tags: 113 (98.9% valid)
```

<details>
<summary>Sample output excerpt</summary>

```markdown
### Voxel Map Downsampling

Implementation: [VERIFY: VoxelSLAM/src/voxel_map.hpp:46-48]
pp.first.pnt = (pp.first.pnt * pp.second + pv.pnt) / (pp.second + 1);

This implements the running average formula:
μ_new = (μ_old · n + x_new) / (n + 1)
```

</details>

<details>
<summary>Full file list generated</summary>

```
Voxel-SLAM/
├── ANALYSIS_00-SystemOverview.md          (559 lines)
├── ANALYSIS_01-DataStructures.md          (702 lines)
├── ALGORITHM_02-VoxelMap.md               (2,219 lines)
├── ALGORITHM_03-IMUPreintegration.md      (1,666 lines)
└── ALGORITHM_04-LiDARMeasurement.md       (1,598 lines)
```

</details>

---

## Project Structure

```
codebase-analysis-skill/
├── skill.md                            # Main skill definition (9-phase methodology)
├── WORKFLOW.md                         # Mandatory verification workflow
├── Gotchas.md                          # 15 common analysis pitfalls & prevention
├── CHANGELOG.md                        # Version history
├── CONTRIBUTING.md                     # Contribution guide
├── LICENSE                             # MIT License
│
├── templates/                          # Document generation templates
│   ├── algorithm_flow.md               # Deep algorithm analysis (1500-3000 lines)
│   ├── data_structures.md              # Data structure breakdown
│   ├── key_questions.md                # Q&A documentation
│   └── system_overview.md              # Architecture overview
│
├── verification/                       # Verification tools
│   ├── verify_all_refs.sh              # Automated [VERIFY:] tag checker
│   ├── verify_analysis.sh              # Full analysis verification
│   └── code_reference_checklist.md     # Manual verification checklist
│
├── helpers/                            # Helper scripts
│   ├── ascii_diagrams.sh               # ASCII diagram utilities
│   └── code_ref_formatter.sh           # Code reference formatting
│
├── docs/                               # Detailed methodology docs
│   ├── ANALYSIS_FLOW.md                # Progressive refinement explained
│   ├── INIT_GUIDE.md                   # Fresh clone handling
│   ├── PHASE1_ENHANCED.md              # Phase 1 enhanced methodology
│   └── PHASE4_GUIDE.md                 # Algorithm deep dive guide
│
└── examples/                           # Usage examples
    └── example-output.md               # Sample output from Voxel-SLAM
```

---

## Verification Tools

```bash
# Verify all [VERIFY:] tags in a generated document
./verification/verify_all_refs.sh ANALYSIS_00-SystemOverview.md

# Output:
# ✓ [VERIFY: src/voxel_map.hpp:46] - Valid
# ✓ [VERIFY: src/voxelslam.cpp:52] - Valid
# ❌ [VERIFY: BTC.h/BTC.cpp] - Malformed (combined path)
#
# Summary: 112/113 valid (98.9%)
```

---

## Tested On

| Project | Language | Size | Output | Coverage |
|---------|----------|------|--------|----------|
| [Voxel-SLAM](https://github.com/hku-mars/Voxel-SLAM) | C++ (ROS) | ~10K LOC | 6,744 lines | 4/4 threads |

*Tested on your project? Open a PR to add it here!*

---

## FAQ

**Q: Does this work with any programming language?**
A: Yes. The methodology is language-agnostic. Works for C++, Python, Rust, Go, Java, and more.

**Q: How is this different from asking Claude to "analyze my code"?**
A: Three things: (1) Structured 9-phase methodology ensures nothing is missed, (2) Mandatory `[VERIFY:]` tags prevent hallucination, (3) Automated verification tools validate every code reference.

**Q: What if my project doesn't have CLAUDE.md?**
A: The skill auto-detects project type from code structure. If `/init` is available, it will automatically generate CLAUDE.md for enhanced context.

**Q: Can I use this without oh-my-claudecode?**
A: Yes. The core methodology is in `skill.md` — use it as a prompt with any Claude Code session. OMC just provides the `/codebase-analysis` trigger.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details. Quick summary:

1. Fork → Branch → Commit → PR
2. Areas we need help: new language templates, more gotchas, testing on diverse codebases
3. Run `./verification/verify_all_refs.sh` to test your changes

---

## License

[MIT](LICENSE)

---

## Acknowledgments

- Skill methodology informed by Anthropic Claude Code team engineer **Thariq**'s sharing: [Lessons from Building Claude Code: How We Use Skills](https://x.com/trq212/status/1903089182445183015), including Gotchas anti-pattern, progressive disclosure, and trigger-based descriptions
- Inspired by the [fastlivo2-tech-docs](https://github.com/Yangchengshuai/fastlivo2-tech-docs) documentation style
- Tested on [Voxel-SLAM](https://github.com/hku-mars/Voxel-SLAM) codebase
- Built for [Claude Code](https://claude.ai/code) and [oh-my-claudecode](https://github.com/yeachan-heo/oh-my-claudecode)

---

<a id="中文说明"></a>

## 中文说明

> 一个 Claude Code 技能，从源代码生成深度、可验证的技术文档 — 零幻觉，全追溯。

### 核心特点

- **防幻觉机制** — 每个论断都需要 `[VERIFY: 文件:行号]` 代码证据
- **自动初始化** — 无 CLAUDE.md 时自动运行 `/init` 获取最佳上下文
- **完整覆盖** — Phase 1.5 规划确保所有模块/线程都被分析
- **双语输出** — 英文 + 中文标题贯穿全文
- **可验证** — 自动化脚本验证每个代码引用

### 快速开始

```bash
# 安装
git clone https://github.com/Yangchengshuai/codebase-analysis-skill.git \
  ~/.claude/plugins/marketplaces/omc/skills/codebase-analysis

# 使用
/codebase-analysis /path/to/your/project
```

### 9 阶段方法论

```
Phase 0:   项目上下文检测     ← 自动检测类型，缺少 CLAUDE.md 时自动 /init
Phase 1:   全局探索           ← 架构、模块、线程
Phase 1.5: 分析规划           ← 100% 覆盖率的明确计划
Phase 2:   数据结构分析       ← 结构体/类深入分析
Phase 3:   数据流分析         ← 数据流动追踪
Phase 4:   算法深度分析       ← 数学推导 + 代码，每篇 1500-3000 行
Phase 5:   关键函数分析       ← 逐行逻辑分析
Phase 6:   问题解答文档       ← 设计原理、配置指南
Phase 7:   验证与复核         ← 自动化 + 人工验证
```

### 许可证

MIT License — 详见 [LICENSE](LICENSE) 文件。
