#!/bin/bash
# Validate that references in onboarding-guide.md still exist

set -euo pipefail

HYPERSHIFT_DIR="${1:-$HOME/hypershift}"
GUIDE_FILE="$HOME/hypershift-onboarding/onboarding-guide.md"
ISSUES_FILE="$HOME/hypershift-onboarding/validation-issues.md"
TEMP_MISSING="$HOME/hypershift-onboarding/.missing-files.tmp"

echo "🔍 Validating onboarding guide references..."
echo "# Validation Issues - $(date)" > "$ISSUES_FILE"
echo "" >> "$ISSUES_FILE"

# Clear temp file
> "$TEMP_MISSING"

# Extract file paths from the guide
# Look for patterns like: `path/to/file.go` where path has at least one /
# This filters out short names like `aws.go` without full path
echo "Checking file references in guide..."
grep -oE '`[a-zA-Z0-9_/-]+/[a-zA-Z0-9_/-]+\.(go|md|yaml|sh|txt)`' "$GUIDE_FILE" | sed 's/`//g' | sort -u | while read -r filepath; do
    if [ ! -f "$HYPERSHIFT_DIR/$filepath" ]; then
        echo "❌ Missing file: $filepath"
        echo "$filepath" >> "$TEMP_MISSING"
        echo "- [ ] Missing file: \`$filepath\`" >> "$ISSUES_FILE"
    else
        echo "✅ Found: $filepath"
    fi
done

# Count missing files
MISSING_COUNT=$(wc -l < "$TEMP_MISSING" | tr -d ' ')
FOUND_ISSUES=$MISSING_COUNT

# Check for moved/renamed common files
CRITICAL_FILES=(
    "api/hypershift/v1beta1/hostedcluster_types.go"
    "api/hypershift/v1beta1/nodepool_types.go"
    "api/hypershift/v1beta1/hosted_controlplane.go"
    "hypershift-operator/controllers/hostedcluster/hostedcluster_controller.go"
    "hypershift-operator/controllers/nodepool/nodepool_controller.go"
    "control-plane-operator/controllers/hostedcontrolplane/hostedcontrolplane_controller.go"
    "Makefile"
)

echo "" >> "$ISSUES_FILE"
echo "## Critical Files Check" >> "$ISSUES_FILE"

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$HYPERSHIFT_DIR/$file" ]; then
        echo "⚠️  CRITICAL: $file is missing or moved!"
        echo "- [ ] **CRITICAL**: \`$file\` is missing or moved" >> "$ISSUES_FILE"
        FOUND_ISSUES=$((FOUND_ISSUES + 1))
    else
        echo "✅ $file exists"
    fi
done

# Check if make targets still exist
echo "" >> "$ISSUES_FILE"
echo "## Make Targets Check" >> "$ISSUES_FILE"

MAKE_TARGETS=(
    "build"
    "hypershift"
    "hypershift-operator"
    "hypershift-install-aws-dev"
    "run-operator-locally-aws-dev"
    "test"
    "verify"
    "update"
)

cd "$HYPERSHIFT_DIR"
for target in "${MAKE_TARGETS[@]}"; do
    if ! make -n "$target" &>/dev/null; then
        echo "⚠️  Make target '$target' may not exist or has errors"
        echo "- [ ] Check make target: \`$target\`" >> "$ISSUES_FILE"
        FOUND_ISSUES=$((FOUND_ISSUES + 1))
    else
        echo "✅ Make target '$target' exists"
    fi
done

if [ $FOUND_ISSUES -eq 0 ]; then
    echo "" >> "$ISSUES_FILE"
    echo "✅ All validations passed!" >> "$ISSUES_FILE"
    echo "✅ All validations passed!"
else
    echo "" >> "$ISSUES_FILE"
    echo "Found $FOUND_ISSUES potential issues. Please review." >> "$ISSUES_FILE"
    echo "⚠️  Found $FOUND_ISSUES potential issues - check $ISSUES_FILE"
fi
