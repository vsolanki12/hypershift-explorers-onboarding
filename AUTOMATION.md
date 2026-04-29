# Onboarding Repository Automation Guide

This document explains how to keep the onboarding repository automatically synchronized with the main HyperShift repository.

## Overview

The onboarding repository contains:
- `onboarding-guide.md` - Main documentation
- `hypershift_mcp_server.py` - MCP server for Claude Code
- References to HyperShift code (file paths, line numbers, etc.)

These need to stay in sync as the main HyperShift repository evolves.

## Automation Options

### Option 1: Daily Automated Check (RECOMMENDED)

**Run this once to set up:**
```bash
~/hypershift-onboarding/setup-daily-sync.sh
```

**What it does:**
- Runs every day at 9:00 AM
- Checks for new commits in main HyperShift repo
- Pulls latest changes
- Validates all file references
- Logs issues to `validation-issues.md`

**View logs:**
```bash
tail -f ~/hypershift-onboarding/sync-check.log
```

**Check for issues:**
```bash
cat ~/hypershift-onboarding/validation-issues.md
```

---

### Option 2: Git Hook (Real-Time)

Trigger validation after every commit in HyperShift repo.

**Setup:**
```bash
# Create post-commit hook
cat > ~/hypershift/.git/hooks/post-commit <<'EOF'
#!/bin/bash
~/hypershift-onboarding/scripts/validate-references.sh ~/hypershift
EOF

chmod +x ~/hypershift/.git/hooks/post-commit
```

**Pros:** Immediate feedback after commits
**Cons:** Only runs on YOUR local commits, not upstream changes

---

### Option 3: Manual Check (On-Demand)

Run validation manually whenever you want.

**Check for issues:**
```bash
~/hypershift-onboarding/scripts/validate-references.sh
```

**Pull latest and check:**
```bash
~/hypershift-onboarding/scripts/sync-check.sh
```

---

## What Gets Checked

### 1. File References
- All file paths mentioned in `onboarding-guide.md`
- Critical files like controller files, API types, etc.

### 2. Make Targets
- `build`, `test`, `verify`, etc.
- Development targets like `hypershift-install-aws-dev`

### 3. API Changes
- Detects changes in `api/` directory
- Flags potential documentation updates needed

### 4. Controller Changes
- Monitors key controller files
- Alerts when reconcile flows might have changed

---

## Notification Setup (Optional)

### Email Notifications

Add to `sync-check.sh` after validation:
```bash
if [ $FOUND_ISSUES -gt 0 ]; then
    echo "Issues found in onboarding sync" | mail -s "HyperShift Onboarding Sync Alert" your@email.com
fi
```

### Slack Notifications

```bash
# Add to sync-check.sh
if [ $FOUND_ISSUES -gt 0 ]; then
    curl -X POST -H 'Content-type: application/json' \
        --data '{"text":"⚠️ HyperShift onboarding guide needs updates"}' \
        YOUR_SLACK_WEBHOOK_URL
fi
```

---

## Monitoring Dashboard

### Check Sync Status
```bash
~/hypershift-onboarding/scripts/sync-status.sh
```

### View Recent Issues
```bash
cat ~/hypershift-onboarding/validation-issues.md
```

### Check Last Sync
```bash
tail -20 ~/hypershift-onboarding/sync-check.log
```

---

## When to Update the Guide Manually

Automated checks will **flag issues**, but you'll need to **manually update** in these cases:

1. **File moved/renamed** → Update path references
2. **API fields changed** → Update type definitions in guide
3. **New components added** → Add to architecture diagrams
4. **Workflow changed** → Update development workflow section
5. **Line numbers shifted** → Update specific line number references

---

## Advanced: Watch Mode (Continuous)

For continuous monitoring during active development:

```bash
# Install fswatch
brew install fswatch

# Watch for changes
fswatch -o ~/hypershift | while read -r; do
    echo "Change detected in HyperShift repo"
    ~/hypershift-onboarding/scripts/validate-references.sh
done
```

---

## Troubleshooting

### Cron job not running?

Check cron logs:
```bash
# macOS
tail -f /var/log/cron.log

# Or check if cron is enabled
launchctl list | grep cron
```

### Permission issues?

Make sure scripts are executable:
```bash
chmod +x ~/hypershift-onboarding/scripts/*.sh
```

### False positives?

Edit `validate-references.sh` to exclude specific patterns or files.

---

## Recommended Workflow

1. **Set up daily sync** (one-time):
   ```bash
   ~/hypershift-onboarding/setup-daily-sync.sh
   ```

2. **Check issues each morning**:
   ```bash
   cat ~/hypershift-onboarding/validation-issues.md
   ```

3. **Update guide when needed**:
   - Fix broken references
   - Update changed sections
   - Commit changes

4. **Verify fixes**:
   ```bash
   ~/hypershift-onboarding/scripts/validate-references.sh
   ```

---

## Files Created by Automation

| File | Purpose |
|------|---------|
| `sync-check.log` | Daily sync check results |
| `validation-issues.md` | Current validation issues |
| `scripts/validate-references.sh` | Validation logic |
| `scripts/sync-check.sh` | Scheduled sync checker |
| `setup-daily-sync.sh` | One-time setup script |

---

## Disable Automation

To remove the daily cron job:
```bash
crontab -l | grep -v 'sync-check.sh' | crontab -
```

To remove git hook:
```bash
rm ~/hypershift/.git/hooks/post-commit
```
