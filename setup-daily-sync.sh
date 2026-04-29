#!/bin/bash
# Setup daily automated sync for onboarding repository

set -euo pipefail

ONBOARDING_DIR="$HOME/hypershift-onboarding"
CRON_JOB="0 9 * * * $ONBOARDING_DIR/scripts/sync-check.sh"

echo "🔧 Setting up daily sync check..."

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "sync-check.sh"; then
    echo "⚠️  Cron job already exists. Remove it first? (y/n)"
    read -r response
    if [ "$response" = "y" ]; then
        # Remove existing job
        crontab -l 2>/dev/null | grep -v "sync-check.sh" | crontab -
        echo "✅ Removed existing cron job"
    else
        echo "❌ Aborting - remove existing cron job manually"
        exit 1
    fi
fi

# Add new cron job
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

echo "✅ Daily sync check configured!"
echo ""
echo "📅 Schedule: Every day at 9:00 AM"
echo "📝 Logs: $ONBOARDING_DIR/sync-check.log"
echo "🔍 Issues: $ONBOARDING_DIR/validation-issues.md"
echo ""
echo "To view current cron jobs:"
echo "  crontab -l"
echo ""
echo "To remove this cron job:"
echo "  crontab -l | grep -v 'sync-check.sh' | crontab -"
echo ""
echo "To test manually:"
echo "  $ONBOARDING_DIR/scripts/sync-check.sh"
