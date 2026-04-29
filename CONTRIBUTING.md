# Contributing to HyperShift Onboarding

Thank you for helping improve our onboarding experience!

## 📋 How to Contribute

### 1. Report Issues
- Found outdated information? Open an issue
- Broken file references? Report them
- Suggestions for improvement? We'd love to hear

### 2. Update Documentation
- Fix typos and errors
- Add missing information
- Improve explanations
- Add examples

### 3. Improve Scripts
- Fix bugs in automation scripts
- Add new validation checks
- Improve error handling

### 4. Share Learning Plans
- Contribute your personalized learning plan as a template
- Share what worked well for you
- Add tips for your specific role

## 🔄 Contribution Workflow

### Option 1: Quick Fix (Preferred)
```bash
# 1. Clone the repo
git clone <repo-url>
cd hypershift-onboarding

# 2. Create a branch
git checkout -b fix/broken-link

# 3. Make your changes
# Edit the file

# 4. Commit and push
git add .
git commit -m "docs: fix broken link to NodePool controller"
git push origin fix/broken-link

# 5. Create PR on GitHub
```

### Option 2: Report an Issue
If you don't have time to fix it yourself:
1. Go to GitHub Issues
2. Click "New Issue"
3. Describe the problem
4. Tag appropriately

## 📝 Commit Message Format

Follow Conventional Commits:

```
<type>: <description>

Types:
- docs: Documentation changes
- fix: Bug fixes
- feat: New features
- chore: Maintenance tasks
- refactor: Code improvements

Examples:
docs: fix broken link in section 7
docs: add example for NodePool scaling
fix: correct file path in validation script
feat: add learning plan template for SREs
```

## 🧪 Before Submitting

- [ ] Test any script changes
- [ ] Verify file paths are correct
- [ ] Check markdown renders properly
- [ ] Run validation if changing references:
  ```bash
  ./scripts/validate-references.sh
  ```

## 👥 Code Review

- All PRs need 1 approval
- Maintainers will review within 2 business days
- Address feedback promptly
- Be open to suggestions

## 📚 Documentation Standards

### File References
Always use full paths:
```markdown
✅ api/hypershift/v1beta1/nodepool_types.go
❌ nodepool_types.go
```

### Code Examples
Include context:
```markdown
✅
\`\`\`go
// From: controllers/nodepool/controller.go
func (r *Reconciler) Reconcile(...) {
    // ...
}
\`\`\`

❌
\`\`\`go
func Reconcile() {
\`\`\`
```

### Links
Use relative links for internal docs:
```markdown
✅ [Section 7](../onboarding-guide.md#7-data-plane)
❌ [Section 7](https://github.com/.../onboarding-guide.md#7)
```

## 🆘 Getting Help

- Slack: #hypershift-dev
- Issues: GitHub Issues tab
- Email: team-lead@company.com

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as this project.

---

**Thank you for making HyperShift onboarding better!** 🚀
