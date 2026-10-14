# Contributing

## Branches and merging

- Branch from `main`, and rebase onto `main` locally to pick up new work;
  never merge `main` into your branch.
- Every change lands through a pull request, **squash merged**. Merge commits
  and rebase merges are disabled.
- The pull request title becomes the one commit on `main`, so it must be a
  [Conventional Commit](https://www.conventionalcommits.org/)
  (`feat: ...`, `fix(scope): ...`). The `PR Title` check enforces this against
  `cog.toml`. Do not end the title with `(#N)`: GitHub appends it.
- The release workflow reads those commits to pick the next version
  (`feat` → minor, `fix`/`perf` → patch).

## The gate

Install the hooks once with [prek](https://github.com/j178/prek):

```bash
prek install
```

Before pushing, run the same gate the `publish` skill runs from
`.publish.yaml`:

```bash
prek run --all-files
```

CI runs on every pull request; the branch ruleset requires `All Checks` and
`PR Title` to pass and every review thread to be resolved.
