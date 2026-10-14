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

3. **Install the git hooks** with [prek](https://github.com/j178/prek):

   ```bash
   prek install
   ```

4. **Customize for your project:**
   - Edit `CLAUDE.md` with your project's build/test/lint
     commands.
   - Edit `.publish.yaml`: add your test command to the gate.
   - Edit `cog.toml`: set `repository`, `owner`, and `authors`,
     and optionally a `scopes` allowlist.
   - Add language-specific entries to `.gitignore`.
   - Add language-specific hooks to `.pre-commit-config.yaml`.
   - Replace placeholder jobs in `.github/workflows/ci.yml`.
   - Update `LICENSE` with your name and year.
   - Replace this README with your project's documentation.

## What's Included

### Merge Strategy

Pull requests are **squash merged**; merge commits and rebase
merges are disabled. Branches are rebased onto `main` locally,
and the PR title becomes the one conventional commit on `main`.
See `CONTRIBUTING.md`.

### CI/CD

- **GitHub Actions** (`ci.yml`): placeholder lint/test jobs,
  markdown lint ([rumdl](https://github.com/rvben/rumdl)),
  ShellCheck, and an `All Checks` gate job.
- **GitHub Actions** (`pr-title.yml`): checks the PR title is a
  conventional commit, since it becomes the squash commit.
- **GitHub Actions** (`release.yml`): Automated semver release
  powered by [cocogitto](https://docs.cocogitto.io/). On push
  to `main`, analyzes conventional commits, creates a version
  tag, generates a changelog, and publishes a GitHub Release.
- **Cocogitto** (`cog.toml`): Semantic versioning config with
  commit type mapping (feat → minor, fix/perf → patch).
- **Renovate** (`renovate.json`): Automated dependency updates
  with automerge, a 7-day minimum release age, digest-pinned
  actions and conventional commit titles.

### Git Hooks

Run by [prek](https://github.com/j178/prek):

- **Conventional commits**: Enforced at commit-msg stage.
- **Secret detection**: Gitleaks runs on every commit.
- **Markdown lint**: rumdl, configured in `.rumdl.toml`.
- **ShellCheck**: on every shell script.

### Publishing

- **`.publish.yaml`**: declares the gate the
  [`publish`](https://github.com/Thurbeen/publish) agent skill
  runs before it pushes and opens a pull request. Install the
  skill globally rather than vendoring it into the project.

### Repository Configuration

- **`scripts/setup-repo.sh`**: Configures GitHub repo via
  `gh` CLI:
  - Squash-only merges, commit title from the PR title and
    message from the PR body
  - Auto-merge and "Update branch" enabled
  - Delete branch on merge
  - Branch ruleset: linear history, PR with resolved threads,
    required `All Checks` and `PR Title` checks

## Prerequisites

- [gh CLI](https://cli.github.com/) (authenticated)
- [prek](https://github.com/j178/prek) (`prek install`)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
