#!/bin/bash
# Quick status check for onboarding sync

set -euo pipefail

HYPERSHIFT_DIR="$HOME/hypershift"
ONBOARDING_DIR="$HOME/hypershift-onboarding"
LOG_FILE="$ONBOARDING_DIR/sync-check.log"
ISSUES_FILE="$ONBOARDING_DIR/validation-issues.md"

echo "═══════════════════════════════════════════════════════════"
echo "  HyperShift Onboarding Sync Status"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Check if automation is set up
echo "📅 Automation Status:"
if crontab -l 2>/dev/null | grep -q "sync-check.sh"; then
    echo "   ✅ Daily cron job: ENABLED"
    crontab -l | grep "sync-check.sh"
else
    echo "   ❌ Daily cron job: NOT SET UP"
    echo "   → Run: ~/hypershift-onboarding/setup-daily-sync.sh"
fi
echo ""

# Check last sync
echo "🔄 Last Sync:"
if [ -f "$LOG_FILE" ]; then
    LAST_RUN=$(tail -20 "$LOG_FILE" | grep "Sync Check Started" | tail -1 | cut -d: -f2-)
    if [ -n "$LAST_RUN" ]; then
        echo "   Last run:$LAST_RUN"
    else
        echo "   No sync runs found in log"
    fi
else
    echo "   ⚠️  No sync log found"
fi
echo ""

# Check for issues
echo "🔍 Validation Status:"
if [ -f "$ISSUES_FILE" ]; then
    ISSUE_COUNT=$(grep -c "^- \[ \]" "$ISSUES_FILE" || true)
    if [ "$ISSUE_COUNT" -eq 0 ]; then
        echo "   ✅ No issues found"
    else
        echo "   ⚠️  $ISSUE_COUNT issue(s) found"
        echo "   → Review: $ISSUES_FILE"
    fi
else
    echo "   ⚠️  No validation results yet"
    echo "   → Run: ~/hypershift-onboarding/scripts/validate-references.sh"
fi
echo ""

# Check repo status
echo "📦 Repository Status:"
cd "$HYPERSHIFT_DIR"
LOCAL_COMMIT=$(git rev-parse --short HEAD)
BRANCH=$(git branch --show-current)
echo "   Current branch: $BRANCH"
echo "   Local commit: $LOCAL_COMMIT"

# Check for uncommitted changes
if ! git diff --quiet; then
    echo "   ⚠️  Uncommitted changes in HyperShift repo"
fi

# Check if behind origin
git fetch origin main --quiet 2>/dev/null || true
LOCAL_COMMITS=$(git rev-list --count HEAD ^origin/main 2>/dev/null || echo "0")
REMOTE_COMMITS=$(git rev-list --count origin/main ^HEAD 2>/dev/null || echo "0")

if [ "$REMOTE_COMMITS" -gt 0 ]; then
    echo "   📥 $REMOTE_COMMITS commit(s) available from origin"
    echo "   → Run: cd ~/hypershift && git pull"
elif [ "$LOCAL_COMMITS" -gt 0 ]; then
    echo "   📤 $LOCAL_COMMITS local commit(s) not pushed"
else
    echo "   ✅ Up to date with origin/main"
fi
echo ""

# Quick actions
echo "🔧 Quick Actions:"
echo "   Run manual sync:  ~/hypershift-onboarding/scripts/sync-check.sh"
echo "   Validate now:     ~/hypershift-onboarding/scripts/validate-references.sh"
echo "   View logs:        tail -f ~/hypershift-onboarding/sync-check.log"
echo "   View issues:      cat ~/hypershift-onboarding/validation-issues.md"
echo ""
echo "═══════════════════════════════════════════════════════════"
