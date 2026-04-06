# Project Template

Template repository for bootstrapping new projects with
standardized tooling and GitHub configuration.

## Quick Start

1. **Create a new repo** from this template (click "Use this
   template" on GitHub, or `gh repo create --template`).

2. **Run the setup script** to configure GitHub settings:
   ```bash
   ./scripts/setup-repo.sh
   ```

3. **Customize for your project:**
   - Edit `CLAUDE.md` with your project's build/test/lint
     commands.
   - Add language-specific entries to `.gitignore`.
   - Add language-specific hooks to `.pre-commit-config.yaml`.
   - Replace placeholder jobs in `.github/workflows/ci.yml`.
   - Update `LICENSE` with your name and year.
   - Replace this README with your project's documentation.

## What's Included

### CI/CD
- **GitHub Actions** (`ci.yml`): Minimal CI with placeholder
  lint/test jobs, conventional commit check, and an
  `All Checks` gate job.
- **Renovate** (`renovate.json`): Automated dependency updates
  with automerge and conventional commit messages.

### Git Hooks
- **Conventional commits**: Enforced at commit-msg stage.
- **Secret detection**: Gitleaks runs on every commit.

### Claude Code
- **`/refactor`**: 3-pass refactoring (structure, coherence,
  tests).
- **`/ship`**: Commit, sync, push, create PR with auto-merge.
- **`/sync`**: Fetch and rebase onto default branch.
- **`/publish`**: Sync, refactor, sync again, then ship as PR.

### Repository Configuration
- **`scripts/setup-repo.sh`**: Configures GitHub repo via
  `gh` CLI:
  - Rebase-only merges
  - Auto-merge enabled
  - Delete branch on merge
  - Branch ruleset with required status checks

## Prerequisites

- [gh CLI](https://cli.github.com/) (authenticated)
- [pre-commit](https://pre-commit.com/) (`pre-commit install`)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
