# HyperShift Documentation MCP Server

A Model Context Protocol (MCP) server that provides intelligent, personalized search and access to HyperShift onboarding documentation.

## Features

- 🔍 **Full-text search** across HyperShift documentation
- 📚 **Section-based navigation** for structured learning
- 🎯 **Personalized learning paths** based on experience level (beginner/intermediate/advanced)
- 🏷️ **Topic-based queries** with role-specific context (developer/operator/architect)
- 📖 **Complete section retrieval** for deep dives

## Installation

### 1. Install Python dependencies

```bash
cd ~/hypershift-onboarding
pip3 install -r requirements.txt
```

### 2. Make the server executable

```bash
chmod +x hypershift_mcp_server.py
```

### 3. Configure in Claude Code

Add this configuration to your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "mcpServers": {
    "hypershift-docs": {
      "command": "python3",
      "args": ["/Users/vsolanki/hypershift-onboarding/hypershift_mcp_server.py"],
      "description": "HyperShift onboarding documentation search and personalized learning"
    }
  }
}
```

### 4. Restart Claude Code

After updating settings, restart Claude Code to load the MCP server.

## Available Tools

### 1. `search_hypershift_docs`
Search for specific terms or phrases in the documentation.

**Parameters:**
- `query` (required): Search term (e.g., "HostedCluster", "control plane")
- `section` (optional): Limit search to specific section

**Example usage in Claude:**
> "Search hypershift docs for NodePool provisioning"

### 2. `get_hypershift_section`
Retrieve a complete section by name or number.

**Parameters:**
- `section_name` (required): Section name or number

**Example usage:**
> "Show me the section on HostedCluster Lifecycle"

### 3. `list_hypershift_sections`
List all available sections in the onboarding guide.

**Example usage:**
> "What sections are available in the hypershift docs?"

### 4. `get_hypershift_learning_path`
Get a personalized learning path based on your experience level.

**Parameters:**
- `experience_level` (required): "beginner", "intermediate", or "advanced"

**Example usage:**
> "Give me a beginner learning path for HyperShift"

### 5. `get_hypershift_topic`
Get comprehensive information about a specific topic.

**Parameters:**
- `topic` (required): Topic name (e.g., "CPO", "etcd", "ignition")
- `context` (optional): Your role ("developer", "operator", "architect", "new_team_member")

**Example usage:**
> "Explain the Control Plane Operator from a developer perspective"

## Personalization Features

### Experience-Based Learning Paths

- **Beginner**: Focus on fundamentals, architecture, and key concepts
- **Intermediate**: Control plane details, lifecycle management, development workflow
- **Advanced**: Architectural patterns, invariants, platform-specific details

### Role-Based Context

- **Developer**: Code structure, APIs, development patterns
- **Operator**: Cluster operations, lifecycle management, troubleshooting
- **Architect**: Architecture decisions, invariants, platform design
- **New Team Member**: Comprehensive onboarding path

## Usage Examples

### Example 1: Starting fresh
```
You: "I'm new to HyperShift. Where should I start?"
Claude: [Uses get_hypershift_learning_path with experience_level="beginner"]
```

### Example 2: Searching for specific information
```
You: "How does NodePool reconciliation work?"
Claude: [Uses search_hypershift_docs with query="NodePool reconciliation"]
```

### Example 3: Deep dive into a topic
```
You: "Explain the Control Plane Operator from a developer perspective"
Claude: [Uses get_hypershift_topic with topic="CPO", context="developer"]
```

### Example 4: Navigating by section
```
You: "Show me the supported cloud platforms"
Claude: [Uses get_hypershift_section with section_name="Supported Cloud Platforms"]
```

## Troubleshooting

### MCP server not appearing in Claude Code

1. Check settings.json syntax is valid JSON
2. Ensure the path to the Python script is absolute and correct
3. Restart Claude Code completely
4. Check Claude Code logs for errors

### Python dependencies not found

```bash
# Install in user directory
pip3 install --user -r requirements.txt

# Or use a virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Then update the Claude Code settings to use the virtualenv Python:
```json
{
  "mcpServers": {
    "hypershift-docs": {
      "command": "/Users/vsolanki/hypershift-onboarding/venv/bin/python",
      "args": ["/Users/vsolanki/hypershift-onboarding/hypershift_mcp_server.py"]
    }
  }
}
```

### Document not found error

Ensure `onboarding-guide.md` is in the same directory as `hypershift_mcp_server.py`:
```bash
ls -l ~/hypershift-onboarding/onboarding-guide.md
```

## AI Agent Automation

### Automated Onboarding Setup

This repository includes blueprints for creating AI agents that automate:
- **Documentation updates** when HyperShift codebase changes
- **Personalized learning plans** for new engineers

### Getting Started with Agents

**Full Blueprint**: `/Users/vsolanki/HYPERSHIFT-ONBOARDING-AGENT-BLUEPRINT.md`
**Quick Reference**: `AI-AGENT-CREATION-GUIDE.md`

The blueprint includes:
- Complete step-by-step guide to creating agents manually
- Two fully-defined agents (onboarding-updater, learning-plan-generator)
- Templates for generated content
- Testing and debugging strategies
- Advanced patterns and best practices

**Read next week when ready to create agents!**

## Extending the Server

You can extend this MCP server to:

1. **Add more documents**: Index additional HyperShift documentation
2. **Semantic search**: Integrate embeddings for better search
3. **Code examples**: Link to actual code examples from the repository
4. **Interactive tutorials**: Generate step-by-step guides
5. **FAQ system**: Build a knowledge base of common questions

## Architecture

```
hypershift_mcp_server.py
├── DocumentIndex class
│   ├── load_and_index()      # Parse markdown into sections
│   ├── search_content()      # Full-text search
│   ├── get_section()         # Section retrieval
│   ├── get_learning_path()   # Personalized paths
│   └── get_topic_content()   # Topic-based queries
│
└── MCP Server (stdio)
    ├── list_tools()          # Advertise available tools
    └── call_tool()           # Handle tool invocations
```

## License

This MCP server is part of the HyperShift project ecosystem.
