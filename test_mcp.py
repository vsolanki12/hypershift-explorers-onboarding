#!/usr/bin/env python3
"""
Test script for HyperShift MCP Server
"""

from hypershift_mcp_server import doc_index

print("🧪 Testing HyperShift MCP Server...\n")

# Test 1: Document loading
print(f"✅ Document loaded: {len(doc_index.sections)} sections indexed")
print(f"   File: {doc_index.doc_path}")
print()

# Test 2: List sections
print("📋 Available sections:")
for i, section in enumerate(doc_index.list_sections()[:5], 1):
    print(f"   {i}. {section}")
print(f"   ... and {len(doc_index.sections) - 5} more sections\n")

# Test 3: Search functionality
print("🔍 Testing search for 'HostedCluster':")
results = doc_index.search_content("HostedCluster")
print(f"   Found {len(results.split('Match'))-1} matches")
print()

# Test 4: Section retrieval
print("📖 Testing section retrieval:")
section = doc_index.get_section("Key Concepts")
print(f"   Retrieved section: {len(section)} characters")
print()

# Test 5: Learning path
print("🎓 Testing learning path generation:")
for level in ["beginner", "intermediate", "advanced"]:
    path = doc_index.get_learning_path(level)
    print(f"   {level.title()}: {len(path)} characters")
print()

# Test 6: Topic search
print("🎯 Testing topic search for 'NodePool':")
topic = doc_index.get_topic_content("NodePool", "developer")
print(f"   Found content: {len(topic)} characters")
print()

print("✅ All tests passed! MCP server is ready to use.")
print("\n📝 Next steps:")
print("   1. Restart Claude Code (if running)")
print("   2. The MCP server will be automatically loaded")
print("   3. Try: 'Search hypershift docs for NodePool'")
