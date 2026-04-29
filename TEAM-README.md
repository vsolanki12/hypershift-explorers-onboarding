# HyperShift Onboarding Repository - For Team Members

**Welcome to the HyperShift team!** 🎉

This repository contains everything you need to get started with HyperShift development.

---

## 🚀 Quick Start (5 minutes)

### 1. Clone This Repository
```bash
git clone <repo-url>
cd hypershift-onboarding
```

### 2. Read the Onboarding Guide
```bash
# Option 1: Read in terminal
cat onboarding-guide.md | less

# Option 2: Open in your editor
code onboarding-guide.md

# Option 3: View on GitHub (if published there)
```

### 3. Set Up MCP Server (Optional - For Claude Code Users)
```bash
# Install dependencies
python3 -m pip install -r requirements.txt

# Test the server
python3 test_mcp.py

# Configure in Claude Code
# See MCP-SETUP.md for details
```

### 4. Set Up Daily Sync (Optional)
```bash
# This keeps docs auto-updated daily
./setup-daily-sync.sh
```

---

## 📚 What's in This Repository

### Core Documentation
- **`onboarding-guide.md`** - Main onboarding guide (START HERE!)
  - Architecture overview
  - Component deep-dives
  - Learning paths
  - Code references

- **`INDEX.md`** - Complete file index

### Tools & Automation
- **`hypershift_mcp_server.py`** - MCP server for Claude Code
  - Search documentation
  - Get personalized learning paths
  - Ask questions about HyperShift

- **`scripts/`** - Automation scripts
  - `sync-check.sh` - Daily doc validation
  - `validate-references.sh` - File reference checker
  - `sync-status.sh` - Status dashboard

### Setup Guides
- **`AUTOMATION.md`** - How automation works
- **`AI-AGENT-CREATION-GUIDE.md`** - Creating AI agents
- **`CONTRIBUTING.md`** - How to contribute

---

## 🎯 Getting Started Paths

### Path 1: New to HyperShift & Kubernetes
**Time:** 8-12 weeks

1. **Week 1-2: Foundations**
   - Read onboarding guide sections 1-3
   - Set up local environment
   - Create first HostedCluster

2. **Week 3-4: Architecture**
   - Study controllers
   - Read API definitions
   - Understand reconciliation

3. **Week 5-6: Deep Dive**
   - Pick focus area (control plane/data plane)
   - Read related code
   - Make first contribution

4. **Week 7-8+: Specialize**
   - Choose specialty
   - Lead features
   - Mentor others

**Resources:**
- Onboarding guide: Full reading
- Kubernetes docs: kubernetes.io
- OpenShift docs: docs.openshift.com

---

### Path 2: Know Kubernetes, New to HyperShift
**Time:** 4-6 weeks

1. **Week 1: HyperShift Concepts**
   - Read sections 1-4
   - Understand HostedCluster vs HostedControlPlane
   - Learn NodePool lifecycle

2. **Week 2-3: Controllers**
   - Read HC, HCP, NP controllers
   - Understand CPOv2 framework
   - Study one platform (AWS/Azure)

3. **Week 4-6: Contribute**
   - Pick area of interest
   - Fix bugs or add features
   - Review PRs

**Resources:**
- Onboarding guide: Sections 1-8
- Code: Controllers and APIs
- Tests: test/e2e/ for examples

---

### Path 3: Experienced with Hosted Control Planes
**Time:** 2-3 weeks

1. **Week 1: HyperShift Specifics**
   - Read sections 3, 6, 9
   - Understand CPOv2 framework
   - Review platform implementations

2. **Week 2-3: Advanced Topics**
   - Architectural invariants
   - Multi-tenancy
   - Platform-specific features
   - Start contributing immediately

**Resources:**
- Onboarding guide: Sections 3, 6, 9, 11, 12
- Code: Platform implementations, CPO v2 components

---

## 🔧 Tools Setup

### Claude Code + MCP Server

**What it does:** Ask questions about HyperShift in natural language

**Setup:**
1. Install Claude Code: https://claude.ai/code
2. Configure MCP server:
   ```bash
   # Edit ~/.claude/settings.json
   {
     "mcpServers": {
       "hypershift-docs": {
         "command": "python3",
         "args": ["/path/to/hypershift-onboarding/hypershift_mcp_server.py"]
       }
     }
   }
   ```
3. Restart Claude Code
4. Test: "Search hypershift docs for NodePool"

### Daily Sync Automation

**What it does:** Auto-validates docs daily, alerts on issues

**Setup:**
```bash
# One-time setup
./setup-daily-sync.sh

# Check status
./scripts/sync-status.sh

# View logs
tail -f sync-check.log
```

---

## 💬 Communication Channels

### Slack
- **#hypershift-dev** - Development discussions
- **#hypershift-help** - Questions and support
- **#hypershift-alerts** - CI/CD notifications

### GitHub
- **Discussions** - Design proposals, RFCs
- **Issues** - Bug reports, feature requests
- **Pull Requests** - Code reviews

### Meetings
- **Daily Standup** - Monday-Friday, 9:30 AM EST
- **Office Hours** - Tuesday/Thursday, 2 PM EST
- **Demo Day** - Last Friday of month

---

## 📖 Learning Resources

### Internal
- This onboarding guide
- Team wiki: [link]
- Previous design docs: [link]

### External
- **Kubernetes**: https://kubernetes.io/docs
- **OpenShift**: https://docs.openshift.com
- **Cluster API**: https://cluster-api.sigs.k8s.io
- **Controller Runtime**: https://book.kubebuilder.io

### Videos
- HyperShift Overview: [link]
- Deep Dive sessions: [playlist]

---

## 🤝 Getting Help

### Your Onboarding Buddy
You'll be assigned a buddy who will:
- Answer questions
- Review your first PRs
- Help navigate the codebase
- Weekly 1:1 check-ins

### When You're Stuck
1. **Search** - Check docs, issues, PRs first
2. **Ask** - Slack #hypershift-help
3. **Office Hours** - Drop in Tuesday/Thursday
4. **Escalate** - DM your buddy or team lead

### Red Flags to Escalate Immediately
- Potential security issue
- Data loss risk
- Production impact
- Confused about architectural decision

---

## ✅ First Week Checklist

**Setup (Day 1):**
- [ ] Clone main HyperShift repo
- [ ] Clone this onboarding repo
- [ ] Set up development environment
- [ ] Join Slack channels
- [ ] Meet your onboarding buddy

**Learning (Day 2-3):**
- [ ] Read onboarding guide sections 1-3
- [ ] Understand HostedCluster, HCP, NodePool
- [ ] Create local test cluster
- [ ] Explore control plane namespace

**Contribution (Day 4-5):**
- [ ] Find a "good first issue"
- [ ] Fix a typo or small bug
- [ ] Create your first PR
- [ ] Get it reviewed and merged

**Bonus:**
- [ ] Attend team meeting
- [ ] Introduce yourself in Slack
- [ ] Review someone else's PR
- [ ] Ask a question in office hours

---

## 🎓 Certification (Optional)

After 8 weeks, you can demonstrate mastery by:
- [ ] Shipping a feature in your focus area
- [ ] Reviewing 5+ PRs
- [ ] Presenting in team demo
- [ ] Mentoring a newer team member

---

## 🐛 Found an Issue?

**In Documentation:**
- Open PR to fix it
- Or create issue if you're not sure

**In Code:**
- Check if issue already exists
- Reproduce it locally
- Create issue with reproduction steps
- Tag with area label

**In This Onboarding:**
- PR welcome! See CONTRIBUTING.md
- Or message in #hypershift-dev

---

## 📈 Your Progress

Track your progress:

```markdown
## Week 1
- [x] Read sections 1-3
- [x] Set up environment
- [ ] Create test cluster

## Week 2
- [ ] Read controller code
- [ ] First PR merged
- [ ] Attend team meeting
```

Keep this in a personal doc or GitHub gist!

---

## 🎉 Welcome Aboard!

You're joining a great team. We're excited to have you!

**Remember:**
- Ask questions (no question is dumb!)
- Make mistakes (that's how we learn)
- Ship code (start small, grow big)
- Have fun! (we build cool stuff)

See you in Slack! 👋

---

**Maintained by:** HyperShift Team
**Last Updated:** April 2026
**Questions?** Slack: #hypershift-dev
