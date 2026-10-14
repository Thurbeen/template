#!/usr/bin/env bash
set -euo pipefail

# setup-repo.sh — Configure GitHub repository settings
# Requires: gh CLI authenticated with repo admin permissions
#
# Usage: ./scripts/setup-repo.sh
#
# Configures:
# - Squash-only merges: the PR title becomes the one commit on the
#   default branch, the PR body its message
# - Auto-merge enabled, "Update branch" button enabled
# - Delete branch on merge
# - Branch ruleset protecting the default branch

REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef -q '.defaultBranchRef.name')

echo "Configuring repository: ${REPO}"
echo "Default branch: ${DEFAULT_BRANCH}"

# ── Merge settings ──────────────────────────────────────
echo "Setting merge strategy to squash-only..."
gh api -X PATCH "repos/${REPO}" \
  -F allow_merge_commit=false \
  -F allow_squash_merge=true \
  -F allow_rebase_merge=false \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY \
  -F allow_auto_merge=true \
  -F allow_update_branch=true \
  -F delete_branch_on_merge=true

# ── Branch ruleset ──────────────────────────────────────
echo "Creating branch ruleset: protect-default-branch..."

# Check if ruleset already exists (idempotent)
EXISTING_RULESET_ID=$(gh api "repos/${REPO}/rulesets" \
  -q '.[] | select(.name == "protect-default-branch") | .id' 2>/dev/null || true)

METHOD="POST"
ENDPOINT="repos/${REPO}/rulesets"
if [[ -n "${EXISTING_RULESET_ID}" ]]; then
  METHOD="PUT"
  ENDPOINT="repos/${REPO}/rulesets/${EXISTING_RULESET_ID}"
  echo "  Ruleset already exists (ID: ${EXISTING_RULESET_ID}), updating..."
fi

# integration_id 15368 = GitHub Actions
gh api -X "${METHOD}" "${ENDPOINT}" \
  --input - <<'RULESET_EOF'
{
  "name": "protect-default-branch",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["~DEFAULT_BRANCH"],
      "exclude": []
    }
  },
  "bypass_actors": [
    {
      "actor_id": 2,
      "actor_type": "RepositoryRole",
      "bypass_mode": "always"
    }
  ],
  "rules": [
    {
      "type": "deletion"
    },
    {
      "type": "non_fast_forward"
    },
    {
      "type": "required_linear_history"
    },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": true,
        "allowed_merge_methods": ["squash"]
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": false,
        "required_status_checks": [
          {
            "context": "All Checks",
            "integration_id": 15368
          },
          {
            "context": "PR Title",
            "integration_id": 15368
          }
        ]
      }
    }
  ]
}
RULESET_EOF

echo ""
echo "Done. Repository configured:"
echo "  - Merge: squash only (commit = PR title, message = PR body)"
echo "  - Auto-merge: enabled"
echo "  - Update branch: enabled"
echo "  - Delete branch on merge: enabled"
echo "  - Ruleset: protect-default-branch (active)"
echo "    - No deletion of ${DEFAULT_BRANCH}"
echo "    - No non-fast-forward on ${DEFAULT_BRANCH}, linear history"
echo "    - PR required (0 approvers, thread resolution, squash only)"
echo "    - Required status checks: All Checks, PR Title"
echo "    - Bypass: repository admin role"
