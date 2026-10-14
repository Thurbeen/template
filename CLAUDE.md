# CLAUDE.md

This file provides guidance to Claude Code when working with
this repository.

## Project

<!-- Describe what this project is and what it does. -->

## Build & Development Commands

```bash
# Example:
# make build
# npm run dev
# cargo run
```

## Testing

```bash
# Example:
# make test
# npm test
# cargo nextest run --all
```

## Linting & Formatting

```bash
# Example:
# make lint
# npm run lint
# cargo clippy --all-targets -- -D warnings
```

## Conventional Commits

All commits must follow
[Conventional Commits](https://www.conventionalcommits.org/).
Enforced by prek hooks.

Pull requests are squash merged: the PR title becomes the
commit on `main`, so write it as a conventional commit. Rebase
onto `main` locally; never merge it into the branch. See
`CONTRIBUTING.md`.

- **Types**: feat, fix, perf, refactor, docs, style, test,
  chore, ci, build, revert
