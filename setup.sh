#!/bin/bash
# Setup script for HyperShift Documentation MCP Server

set -e

echo "🚀 Setting up HyperShift Documentation MCP Server..."

# Check Python version
echo "📋 Checking Python installation..."
python3 --version

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "🔨 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

# Make server executable
echo "🔧 Making server executable..."
chmod +x hypershift_mcp_server.py

# Test the server can load
echo "🧪 Testing server initialization..."
python -c "from hypershift_mcp_server import doc_index; print(f'✓ Server loaded successfully with {len(doc_index.sections)} sections indexed')"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Add the following to your Claude Code settings (~/.claude/settings.json):"
echo ""
echo '{
  "mcpServers": {
    "hypershift-docs": {
      "command": "'$(pwd)'/venv/bin/python",
      "args": ["'$(pwd)'/hypershift_mcp_server.py"],
      "description": "HyperShift onboarding documentation"
    }
  }
}'
echo ""
echo "2. Restart Claude Code"
echo "3. Try asking: 'Search hypershift docs for NodePool'"
echo ""
