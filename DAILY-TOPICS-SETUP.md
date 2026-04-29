# Daily HyperShift Onboarding Topics — Setup Guide

Posts one HyperShift onboarding topic per weekday to a Slack channel via GitHub Actions.
Covers 35 sub-topics over ~7 weeks, then stops automatically.

---

## Setup Steps

### Step 1: Create a Private GitHub Repo (5 min)

```bash
cd ~/hypershift-onboarding

# Initialize git if not already done
git init

# Create private repo on GitHub
gh repo create vsolanki/hypershift-onboarding --private --source=. --push
```

If the repo already exists but isn't on GitHub:
```bash
gh repo create vsolanki/hypershift-onboarding --private
git remote add origin git@github.com:vsolanki/hypershift-onboarding.git
git add .
git commit -m "initial commit: onboarding system with daily topics"
git push -u origin main
```

### Step 2: Create a Slack Incoming Webhook (5 min)

1. Go to https://api.slack.com/apps
2. Click **Create New App** -> **From scratch**
3. Name: `HyperShift Onboarding Bot`, pick your workspace
4. Go to **Incoming Webhooks** -> Toggle **On**
5. Click **Add New Webhook to Workspace**
6. Pick your **personal test channel** first (e.g., `#vsolanki-test`)
7. Copy the webhook URL (looks like `https://hooks.slack.com/services/T.../B.../xxx`)

### Step 3: Add Webhook Secret to GitHub (1 min)

1. Go to `https://github.com/vsolanki/hypershift-onboarding/settings/secrets/actions`
2. Click **New repository secret**
3. Name: `SLACK_WEBHOOK`
4. Value: paste the webhook URL from Step 2
5. Click **Add secret**

### Step 4: Enable GitHub Actions on the Repo (30 sec)

1. Go to `https://github.com/vsolanki/hypershift-onboarding/actions`
2. If prompted, click **"I understand my workflows, go ahead and enable them"**

### Step 5: Test It Manually (1 min)

1. Go to **Actions** tab -> **Daily HyperShift Onboarding Topic**
2. Click **Run workflow** -> optionally set topic number to `1`
3. Click **Run workflow**
4. Check your Slack test channel for the message

---

## After Testing

### Move to Team Channel

1. Go back to Slack App settings -> **Incoming Webhooks**
2. Click **Add New Webhook to Workspace**
3. Pick the team channel (e.g., `#hypershift-dev` or `#hypershift-onboarding`)
4. Update the `SLACK_WEBHOOK` secret in GitHub with the new URL

### Adjust Timezone

Edit `.github/workflows/daily-topic.yml`, change the cron schedule:

```yaml
# Examples:
- cron: '3 9 * * 1-5'    # 9:03 AM UTC
- cron: '30 3 * * 1-5'   # 9:00 AM IST (UTC+5:30)
- cron: '0 14 * * 1-5'   # 9:00 AM EST (UTC-5)
```

---

## Operations

### Check Progress
```bash
cat .topic-counter   # Shows next topic number (0-indexed)
```

### Skip to a Specific Topic
Use the **Run workflow** button in GitHub Actions and enter the topic number (1-35).

### Restart from the Beginning
```bash
echo "0" > .topic-counter
git add .topic-counter
git commit -m "chore: reset topic counter to start over"
git push
```

### Preview a Topic Locally
```bash
jq '.[4]' daily-topics.json   # Preview topic 5 (0-indexed)
```

### View All Topics
```bash
jq '.[].title' daily-topics.json
```

---

## Files

| File | Purpose |
|------|---------|
| `daily-topics.json` | 35 sub-topics with summaries, code refs, and explore hints |
| `.github/workflows/daily-topic.yml` | GitHub Actions workflow (runs weekdays) |
| `.topic-counter` | Tracks current topic (auto-updated by workflow) |
| `DAILY-TOPICS-SETUP.md` | This setup guide |

---

## How It Works

```
GitHub Actions (cron: weekdays 9 AM)
         |
         v
Read .topic-counter (e.g., "4")
         |
         v
Pick daily-topics.json[4]
         |
         v
Format Slack message with:
  - Topic title & summary
  - GitHub links to code files
  - Explore hint for self-study
  - Link to full onboarding guide
         |
         v
POST to Slack webhook
         |
         v
Bump .topic-counter to "5"
(git commit + push)
         |
         v
After topic 35: workflow stops
```
