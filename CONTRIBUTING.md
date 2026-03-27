# Contributing to Codebase Analysis Skill

Thank you for your interest in contributing! This guide will help you get started.

## How to Contribute

### Report Issues

- **Bugs**: Use the [Bug Report](https://github.com/Ericskey/codebase-analysis-skill/issues/new?template=bug_report.md) template
- **Features**: Use the [Feature Request](https://github.com/Ericskey/codebase-analysis-skill/issues/new?template=feature_request.md) template

### Submit Changes

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/my-feature`
3. **Commit** your changes: `git commit -m 'Add my feature'`
4. **Push** to your branch: `git push origin feature/my-feature`
5. **Open** a Pull Request

### Areas We Need Help

- **New Language Templates** — Rust, Go, Python-specific analysis templates
- **Test Results** — Run the skill on your project and share results
- **Gotchas** — Found a new pitfall? Add it to Gotchas.md
- **Documentation** — Improve existing docs or add translations
- **Verification Tools** — Enhance automated verification scripts

## Development Setup

```bash
# Clone
git clone https://github.com/Ericskey/codebase-analysis-skill.git
cd codebase-analysis-skill

# Verify tools work
./verification/verify_all_refs.sh examples/example-output.md

# Install as Claude Code skill (OMC)
cp -r . ~/.claude/plugins/marketplaces/omc/skills/codebase-analysis
```

## Adding a New Template

1. Create `templates/your_template.md`
2. Follow the existing template structure (Table of Contents, sections, `[VERIFY:]` tags)
3. Add it to `skill.md` file system structure
4. Test on a real codebase
5. Submit PR with example output

## Adding a New Gotcha

1. Follow the pattern in `Gotchas.md`:
   - Pattern (what goes wrong)
   - Why It Happens (root cause)
   - Detection (how to catch it)
   - Prevention Checklist
2. Number it sequentially
3. Test that the prevention steps work

## Testing Your Changes

```bash
# 1. Verify script syntax
bash -n verification/verify_all_refs.sh

# 2. Test on example document
./verification/verify_all_refs.sh examples/example-output.md

# 3. Run full analysis on a test codebase
# Use a small open-source project as test target
/codebase-analysis /path/to/test/project
```

## Code Style

- **Markdown**: Use consistent heading hierarchy (H1 → H2 → H3)
- **Bash**: Follow shellcheck recommendations, use `set -e`
- **Documentation**: Bilingual where appropriate (English + Chinese headings)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
