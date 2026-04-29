#!/bin/bash
# Quick commands to share hypershift-onboarding repository
# Run these in order to publish your repository

echo "🚀 HyperShift Onboarding - Quick Share Commands"
echo "================================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📋 Prerequisites Check${NC}"
echo "1. Do you have GitHub access? (yes/no)"
read -r github_access
if [ "$github_access" != "yes" ]; then
    echo "❌ Please get GitHub access first"
    exit 1
fi

echo "2. Do you want to create a private or public repo? (private/public)"
read -r visibility

echo ""
echo -e "${GREEN}✅ Starting setup...${NC}"
echo ""

# Step 1: Clean sensitive files
echo "Step 1: Removing sensitive files..."
rm -f .config/slack.conf 2>/dev/null || true
rm -f sync-check.log 2>/dev/null || true
rm -f validation-issues.md 2>/dev/null || true
echo "✅ Sensitive files removed"

# Step 2: Initialize git (if not already)
if [ ! -d ".git" ]; then
    echo ""
    echo "Step 2: Initializing git repository..."
    git init
    echo "✅ Git initialized"
else
    echo ""
    echo "Step 2: Git already initialized ✅"
fi

# Step 3: Add all files
echo ""
echo "Step 3: Adding files..."
git add .
echo "✅ Files staged"

# Step 4: Create initial commit
echo ""
echo "Step 4: Creating initial commit..."
git commit -m "Initial commit: HyperShift onboarding repository

- Comprehensive onboarding guide with diagrams
- MCP server for AI-powered documentation search
- Automation scripts for daily sync
- Learning path templates
- Team documentation and contribution guidelines" || echo "⚠️  Already committed or nothing to commit"

# Step 5: Create GitHub repo using gh CLI
echo ""
echo "Step 5: Creating GitHub repository..."
echo "Do you have GitHub CLI installed? (yes/no)"
read -r has_gh

if [ "$has_gh" = "yes" ]; then
    echo ""
    echo "What organization/username to create under?"
    echo "(Leave empty for your personal account)"
    read -r org

    if [ -z "$org" ]; then
        gh repo create hypershift-onboarding \
            --${visibility} \
            --description "Comprehensive onboarding guide and automation for HyperShift team members" \
            --source=. \
            --push
    else
        gh repo create ${org}/hypershift-onboarding \
            --${visibility} \
            --description "Comprehensive onboarding guide and automation for HyperShift team members" \
            --source=. \
            --push
    fi

    echo "✅ Repository created and pushed!"

else
    echo ""
    echo "Manual GitHub repo creation needed:"
    echo "1. Go to: https://github.com/new"
    echo "2. Repository name: hypershift-onboarding"
    echo "3. Visibility: ${visibility}"
    echo "4. DO NOT initialize with README"
    echo "5. Click 'Create repository'"
    echo "6. Copy the remote URL"
    echo ""
    echo "Press Enter when done..."
    read -r

    echo "Enter the repository URL:"
    read -r repo_url

    git remote add origin "$repo_url"
    git branch -M main
    git push -u origin main

    echo "✅ Repository pushed!"
fi

# Step 6: Summary
echo ""
echo "================================================"
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo "================================================"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Configure repository settings on GitHub:"
echo "   - Add team members"
echo "   - Enable branch protection"
echo "   - Add labels"
echo ""
echo "2. Share with team in Slack:"
echo "   - Announce the repository"
echo "   - Link to TEAM-README.md"
echo ""
echo "3. (Optional) Set up Slack webhook:"
echo "   - See TEAM-SHARING-SETUP.md for details"
echo ""
echo "📚 Reference docs:"
echo "   - TEAM-SHARING-SETUP.md (full guide)"
echo "   - TEAM-README.md (for team members)"
echo "   - CONTRIBUTING.md (contribution guidelines)"
echo ""
echo "🔗 Repository URL:"
if [ "$has_gh" = "yes" ]; then
    gh repo view --web
else
    echo "   $repo_url"
fi
echo ""
echo "Happy onboarding! 🚀"
