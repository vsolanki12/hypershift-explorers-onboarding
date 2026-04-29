# AI Agent Creation - Quick Reference

**Full Blueprint**: `/Users/vsolanki/HYPERSHIFT-ONBOARDING-AGENT-BLUEPRINT.md`

---

## Quick Start

### 1. Create Directory Structure
```bash
cd ~/hypershift-onboarding
mkdir -p .claude/agents
mkdir -p templates
mkdir -p learning-plans
```

### 2. Create Your First Agent

**File**: `.claude/agents/onboarding-updater.md`

```markdown
---
name: onboarding-updater
description: Updates HyperShift onboarding materials when codebase changes
model: claude-sonnet-4-5
---

# Onboarding Material Updater Agent

## Your Role
{What the agent does}

## When to Use
{When to invoke}

## Tasks You Perform
{Step-by-step tasks}

## Tools You Use
{List of tools}

## Quality Standards
{Success criteria}

## Output
{What to report}
```

### 3. Test the Agent
```bash
# In Claude Code:
/agent onboarding-updater
```

---

## Agent Template

Copy this template for new agents:

```markdown
---
name: {agent-name}
description: {one-line description}
model: claude-sonnet-4-5
---

# {Agent Title}

## Your Role
You are a specialized agent that...

## When to Use
Run this agent when:
- {Scenario 1}
- {Scenario 2}

## Tasks You Perform

### Task 1: {Name}
1. {Step 1}
2. {Step 2}
3. {Step 3}

## Tools You Use
- Read: {When to use}
- Write: {When to use}
- Edit: {When to use}
- Bash: {When to use}

## Quality Standards
✅ {Criterion 1}
✅ {Criterion 2}

## Output
Provide:
- {Item 1}
- {Item 2}
```

---

## Key Files to Create

1. **Onboarding Updater Agent**
   - Path: `.claude/agents/onboarding-updater.md`
   - Purpose: Updates docs when code changes
   - See full definition in blueprint

2. **Learning Plan Generator Agent**
   - Path: `.claude/agents/learning-plan-generator.md`
   - Purpose: Creates personalized learning plans
   - See full definition in blueprint

3. **Learning Plan Template**
   - Path: `templates/learning-plan-template.md`
   - Used by: learning-plan-generator agent

4. **Quick Start Template**
   - Path: `templates/quick-start-template.md`
   - Used by: learning-plan-generator agent

---

## Testing Checklist

- [ ] File exists in `.claude/agents/`
- [ ] Frontmatter syntax correct
- [ ] Name matches invocation
- [ ] Instructions are clear
- [ ] Test basic invocation
- [ ] Test real scenario
- [ ] Validate output
- [ ] Handle errors gracefully

---

## Common Issues & Solutions

**Agent not found:**
```bash
# Check location
ls .claude/agents/

# Check name in frontmatter matches invocation
```

**Invalid agent definition:**
```markdown
# Frontmatter must be exact:
---
name: agent-name
description: One line only
model: claude-sonnet-4-5
---
```

**Agent doesn't follow instructions:**
- Make steps more explicit
- Use numbered lists
- Add examples
- Include quality checks

---

## Invocation Examples

```bash
# Basic
/agent onboarding-updater

# With context
"Run onboarding-updater to fix broken references"

# With parameters
"Generate learning plan for Sarah, developer, intermediate, control plane focus"
```

---

## Next Steps

1. Read full blueprint: `/Users/vsolanki/HYPERSHIFT-ONBOARDING-AGENT-BLUEPRINT.md`
2. Create directory structure
3. Create first agent
4. Test and iterate
5. Create second agent
6. Share with team

---

**Created**: March 31, 2026
**Full Blueprint**: `/Users/vsolanki/HYPERSHIFT-ONBOARDING-AGENT-BLUEPRINT.md`
