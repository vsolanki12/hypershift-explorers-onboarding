#!/bin/bash
# Scheduled sync check for onboarding repository

set -euo pipefail

HYPERSHIFT_DIR="$HOME/hypershift"
ONBOARDING_DIR="$HOME/hypershift-onboarding"
LOG_FILE="$ONBOARDING_DIR/sync-check.log"

echo "=== Sync Check Started: $(date) ===" | tee -a "$LOG_FILE"

# 1. Check if main repo has new commits
cd "$HYPERSHIFT_DIR"
git fetch origin main --quiet

LOCAL_COMMIT=$(git rev-parse HEAD)
REMOTE_COMMIT=$(git rev-parse origin/main)

if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
    echo "📥 New commits available in main repo" | tee -a "$LOG_FILE"

    # Pull latest changes
    git pull origin main

    # Run validation
    "$ONBOARDING_DIR/scripts/validate-references.sh" "$HYPERSHIFT_DIR" | tee -a "$LOG_FILE"

    # Check for API changes
    if git diff "$LOCAL_COMMIT" "$REMOTE_COMMIT" --name-only | grep "^api/"; then
        echo "⚠️  API changes detected - onboarding guide may need updates" | tee -a "$LOG_FILE"
    fi

    # Check for controller changes
    if git diff "$LOCAL_COMMIT" "$REMOTE_COMMIT" --name-only | grep -E "(hostedcluster_controller|nodepool_controller|hostedcontrolplane_controller)"; then
        echo "⚠️  Controller changes detected - check reconcile flow documentation" | tee -a "$LOG_FILE"
    fi
else
    echo "✅ No new commits - repository is up to date" | tee -a "$LOG_FILE"
fi

echo "=== Sync Check Completed: $(date) ===" | tee -a "$LOG_FILE"
echo "" >> "$LOG_FILE"
