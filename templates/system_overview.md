# System Overview Template

> **Purpose**: Provide high-level understanding of the system architecture, modules, and their relationships.
>
> **Verification**: Every claim must reference actual code.

---

## Table of Contents
- [1. System Introduction](#1-system-introduction)
- [2. Core Modules](#2-core-modules)
- [3. Architecture Diagram](#3-architecture-diagram)
- [4. Module Relationships](#4-module-relationships)
- [5. Data Flow Overview](#5-data-flow-overview)
- [6. Key Technologies](#6-key-technologies)
- [7. Code Structure Mapping](#7-code-structure-mapping)

---

## 1. System Introduction

### 1.1 What is [SYSTEM_NAME]?

[Brief description of what the system does, its purpose, and main functionality]

**Example from fastlivo2:**
```
FASTLIVO2 (Fast, Direct LiDAR-Inertial-Visual Odometry) is a high-efficiency
LiDAR-Inertial-Visual fusion localization and mapping system...
```

### 1.2 Core Advantages

- **Advantage 1**: Description
- **Advantage 2**: Description
- **Advantage 3**: Description

**Evidence**:
- [VERIFY: file.cpp:line] - Evidence for advantage 1
- [VERIFY: file.cpp:line] - Evidence for advantage 2

### 1.3 Application Scenarios

- Scenario 1
- Scenario 2
- Scenario 3

---

## 2. Core Modules

### 2.1 Module Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    [SYSTEM_NAME] Architecture                │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐              │
│  │ Module 1 │────│ Module 2 │────│ Module 3 │              │
│  └──────────┘    └──────────┘    └──────────┘              │
│       │               │               │                     │
│       └───────────────┴───────────────┘                     │
│                       │                                     │
│                       ▼                                     │
│              ┌──────────────┐                               │
│              │ Core Module  │                               │
│              └──────────────┘                               │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Module List

| Module | Description | Key File | Status |
|--------|-------------|----------|--------|
| Module A | Description | src/module_a.cpp | ✓ Documented |
| Module B | Description | src/module_b.cpp | ✓ Documented |
| Module C | Description | src/module_c.cpp | ✓ Documented |

### 2.3 Module Details

#### Module 1: [NAME]

**Purpose**: [What it does]

**Key Components**:
- Component 1
- Component 2

**Code Mapping**:
- [VERIFY: include/module1.h] - Interface definition
- [VERIFY: src/module1.cpp] - Implementation

**Verification Steps**:
- [ ] Read module header file
- [ ] Trace initialization code
- [ ] Identify main functions
- [ ] Document interfaces

---

## 3. Architecture Diagram

### 3.1 High-Level Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                        Layer Structure                        │
├──────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌─────────────────────────────────────────────────────┐     │
│  │              Application Layer                        │     │
│  │  ┌────────┐  ┌────────┐  ┌────────┐                │     │
│  │  │ App 1  │  │ App 2  │  │ App 3  │                │     │
│  │  └────────┘  └────────┘  └────────┘                │     │
│  └─────────────────────────────────────────────────────┘     │
│                           │                                  │
│  ┌─────────────────────────────────────────────────────┐     │
│  │              Business Logic Layer                    │     │
│  │  ┌────────┐  ┌────────┐  ┌────────┐                │     │
│  │  │Logic 1 │  │Logic 2 │  │Logic 3 │                │     │
│  │  └────────┘  └────────┘  └────────┘                │     │
│  └─────────────────────────────────────────────────────┘     │
│                           │                                  │
│  ┌─────────────────────────────────────────────────────┐     │
│  │               Data Access Layer                       │     │
│  │  ┌────────┐  ┌────────┐  ┌────────┐                │     │
│  │  │Data 1  │  │Data 2  │  │Data 3  │                │     │
│  │  └────────┘  └────────┘  └────────┘                │     │
│  └─────────────────────────────────────────────────────┘     │
│                                                                │
└──────────────────────────────────────────────────────────────┘
```

**Evidence**:
- [VERIFY: include/architecture.h] - Layer definitions
- [VERIFY: src/main.cpp:line] - Module initialization order

---

## 4. Module Relationships

### 4.1 Dependency Graph

```
Module A ────┐
             ├──> Module C ──> Module E
Module B ────┘

Module D ────────────────> Module F
```

**Dependencies**:
- Module C depends on: A, B
- Module E depends on: C
- Module F depends on: D

**Evidence**:
- [VERIFY: include/module_c.h:#include] - Include statements
- [VERIFY: src/module_c.cpp:uses] - Function calls

### 4.2 Communication Patterns

**Pattern 1: Direct Call**
```
Caller.func() ──> Callee.func()
```
- [VERIFY: src/caller.cpp:line] - Call site

**Pattern 2: Event-Based**
```
Publisher ──[event]──> Subscriber
```
- [VERIFY: src/publisher.cpp:line] - Event emission
- [VERIFY: src/subscriber.cpp:line] - Event handler

---

## 5. Data Flow Overview

### 5.1 Complete Data Flow

```
Input Data
    │
    ▼
┌─────────────┐
│  Process 1  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Process 2  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Process 3  │
└──────┬──────┘
       │
       ▼
    Output
```

**Evidence**:
- [VERIFY: src/process1.cpp:main_loop] - Data entry point
- [VERIFY: src/process2.cpp:handle] - Transformation
- [VERIFY: src/process3.cpp:output] - Final output

### 5.2 Data Transformations

| Stage | Input | Output | Transformation | Evidence |
|-------|-------|--------|----------------|----------|
| 1 | Type A | Type B | Transform X | [VERIFY: file:line] |
| 2 | Type B | Type C | Transform Y | [VERIFY: file:line] |
| 3 | Type C | Type D | Transform Z | [VERIFY: file:line] |

---

## 6. Key Technologies

### 6.1 Technologies Used

| Technology | Purpose | Usage Location | Evidence |
|------------|---------|----------------|----------|
| Tech 1 | Purpose | include/tech1.h | [VERIFY] |
| Tech 2 | Purpose | src/tech2.cpp | [VERIFY] |

### 6.2 Third-Party Dependencies

```
Project
    ├── Dependency A (version X.X)
    ├── Dependency B (version Y.Y)
    └── Dependency C (version Z.Z)
```

**Evidence**:
- [VERIFY: CMakeLists.txt:line] - Dependency declarations
- [VERIFY: package.json] - NPM dependencies
- [VERIFY: requirements.txt] - Python dependencies

---

## 7. Code Structure Mapping

### 7.1 Directory Structure

```
project/
├── include/              # Header files
│   ├── module1.h
│   ├── module2.h
│   └── common.h
├── src/                  # Source files
│   ├── main.cpp
│   ├── module1.cpp
│   └── module2.cpp
├── tests/                # Test files
└── config/               # Configuration
```

**Evidence**:
- [VERIFY: CMakeLists.txt:line] - Source directory definitions
- [VERIFY: Makefile:line] - Build structure

### 7.2 File-to-Module Mapping

| File | Module | Purpose | Key Functions |
|------|--------|---------|---------------|
| src/module1.cpp | Module 1 | Purpose | func1(), func2() |
| src/module2.cpp | Module 2 | Purpose | funcA(), funcB() |

---

## 8. Verification Report

### 8.1 Claims Verification

| Claim | Evidence | Status |
|-------|----------|--------|
| System uses X architecture | [VERIFY: file:line] | ✓ Verified |
| Module A calls Module B | [VERIFY: file:line] | ✓ Verified |
| Data flows through pipeline | [VERIFY: file:line] | ✓ Verified |

### 8.2 Open Questions

- [ ] Question 1
- [ ] Question 2

### 8.3 Next Steps

- → Proceed to Data Structures Analysis
- → Document specific data structures in detail
- → Create detailed structure diagrams

---

## 9. References

- Related documentation
- Design documents
- API references

---

**Template Version**: 1.0
**Based on**: fastlivo2-tech-docs/02-FASTLIVO2系统概述.md
**Last Updated**: 2026-03-27
