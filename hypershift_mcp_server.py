#!/usr/bin/env python3
"""
HyperShift Documentation MCP Server
Provides personalized search and context-aware access to HyperShift onboarding documentation.
"""

import os
import re
import json
from pathlib import Path
from typing import Any, Optional
from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import (
    Tool,
    TextContent,
    ImageContent,
    EmbeddedResource,
    INVALID_PARAMS,
    INTERNAL_ERROR,
)
from pydantic import BaseModel, Field


# Configuration
DOCS_DIR = Path(__file__).parent
ONBOARDING_DOC = DOCS_DIR / "onboarding-guide.md"


class DocumentIndex:
    """Index and search HyperShift onboarding documentation."""

    def __init__(self, doc_path: Path):
        self.doc_path = doc_path
        self.content = ""
        self.sections = {}
        self.load_and_index()

    def load_and_index(self):
        """Load and index the documentation."""
        if not self.doc_path.exists():
            raise FileNotFoundError(f"Documentation not found: {self.doc_path}")

        with open(self.doc_path, 'r', encoding='utf-8') as f:
            self.content = f.read()

        # Parse sections (## headers)
        self._parse_sections()

    def _parse_sections(self):
        """Parse markdown sections from the documentation."""
        # Split by ## headers
        pattern = r'^##\s+(.+)$'
        lines = self.content.split('\n')

        current_section = "Introduction"
        current_content = []

        for line in lines:
            match = re.match(pattern, line)
            if match:
                # Save previous section
                if current_content:
                    self.sections[current_section] = '\n'.join(current_content).strip()

                # Start new section
                current_section = match.group(1).strip()
                current_content = [line]
            else:
                current_content.append(line)

        # Save last section
        if current_content:
            self.sections[current_section] = '\n'.join(current_content).strip()

    def search_content(self, query: str, section: Optional[str] = None) -> str:
        """
        Search documentation content.

        Args:
            query: Search term or phrase
            section: Optional section to limit search

        Returns:
            Matching content with context
        """
        search_text = self.content
        if section and section in self.sections:
            search_text = self.sections[section]

        # Case-insensitive search
        pattern = re.compile(re.escape(query), re.IGNORECASE)
        matches = []

        lines = search_text.split('\n')
        for i, line in enumerate(lines):
            if pattern.search(line):
                # Get context: 2 lines before and after
                start = max(0, i - 2)
                end = min(len(lines), i + 3)
                context = '\n'.join(lines[start:end])
                matches.append(f"**Match {len(matches) + 1}:**\n{context}\n")

        if matches:
            return '\n---\n'.join(matches)
        else:
            return f"No matches found for '{query}'"

    def get_section(self, section_name: str) -> str:
        """Get a specific section by name."""
        # Try exact match first
        if section_name in self.sections:
            return self.sections[section_name]

        # Try fuzzy match
        for key in self.sections:
            if section_name.lower() in key.lower():
                return self.sections[key]

        return f"Section '{section_name}' not found. Available sections:\n" + \
               '\n'.join(f"  - {s}" for s in self.sections.keys())

    def list_sections(self) -> list[str]:
        """List all available sections."""
        return list(self.sections.keys())

    def get_learning_path(self, experience_level: str = "beginner") -> str:
        """
        Get personalized learning path based on experience level.

        Args:
            experience_level: 'beginner', 'intermediate', 'advanced'
        """
        paths = {
            "beginner": [
                "1. What is HyperShift?",
                "2. Key Concepts",
                "3. Overall Architecture",
                "4. Main Components",
                "14. Recommended Learning Path"
            ],
            "intermediate": [
                "5. HostedCluster Lifecycle",
                "6. Control Plane in Detail",
                "7. Data Plane and Node Management",
                "9. APIs and Code Structure",
                "10. Development Workflow"
            ],
            "advanced": [
                "11. Common Development Patterns",
                "12. Architectural Invariants",
                "13. Key File Reference",
                "8. Supported Cloud Platforms"
            ]
        }

        level_path = paths.get(experience_level.lower(), paths["beginner"])
        result = [f"# Learning Path for {experience_level.title()} Level\n"]

        for section in level_path:
            if section in self.sections:
                result.append(f"\n## {section}\n")
                result.append(self.sections[section][:500] + "...\n")

        return '\n'.join(result)

    def get_topic_content(self, topic: str, context: Optional[str] = None) -> str:
        """
        Get content about a specific topic with optional context.

        Args:
            topic: The topic to search for (e.g., 'HostedCluster', 'NodePool', 'CPO')
            context: Optional context for personalized results (e.g., 'developer', 'operator', 'architect')
        """
        results = []
        topic_lower = topic.lower()

        for section_name, content in self.sections.items():
            if topic_lower in content.lower():
                # Extract relevant paragraphs
                paragraphs = content.split('\n\n')
                for para in paragraphs:
                    if topic_lower in para.lower():
                        results.append(f"### From: {section_name}\n\n{para}\n")

        if not results:
            return f"No content found for topic: {topic}"

        header = f"# Content about '{topic}'\n\n"
        if context:
            header += f"*Filtered for context: {context}*\n\n"

        return header + '\n---\n'.join(results)


# Initialize server and document index
app = Server("hypershift-docs-server")
doc_index = DocumentIndex(ONBOARDING_DOC)


@app.list_tools()
async def list_tools() -> list[Tool]:
    """List available tools for HyperShift documentation."""
    return [
        Tool(
            name="search_hypershift_docs",
            description="Search HyperShift onboarding documentation for specific terms or phrases. "
                       "Supports optional section filtering.",
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "Search term or phrase (e.g., 'HostedCluster', 'control plane', 'NodePool')"
                    },
                    "section": {
                        "type": "string",
                        "description": "Optional: Limit search to a specific section (e.g., '5. HostedCluster Lifecycle')"
                    }
                },
                "required": ["query"]
            }
        ),
        Tool(
            name="get_hypershift_section",
            description="Retrieve a complete section from the HyperShift onboarding guide by name or number.",
            inputSchema={
                "type": "object",
                "properties": {
                    "section_name": {
                        "type": "string",
                        "description": "Section name or number (e.g., 'Key Concepts', '5. HostedCluster Lifecycle')"
                    }
                },
                "required": ["section_name"]
            }
        ),
        Tool(
            name="list_hypershift_sections",
            description="List all available sections in the HyperShift onboarding documentation.",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        ),
        Tool(
            name="get_hypershift_learning_path",
            description="Get a personalized learning path through HyperShift documentation based on experience level.",
            inputSchema={
                "type": "object",
                "properties": {
                    "experience_level": {
                        "type": "string",
                        "enum": ["beginner", "intermediate", "advanced"],
                        "description": "Your experience level with HyperShift/Kubernetes"
                    }
                },
                "required": ["experience_level"]
            }
        ),
        Tool(
            name="get_hypershift_topic",
            description="Get comprehensive information about a specific HyperShift topic with optional context filtering.",
            inputSchema={
                "type": "object",
                "properties": {
                    "topic": {
                        "type": "string",
                        "description": "Topic to learn about (e.g., 'HostedCluster', 'CPO', 'NodePool', 'etcd', 'ignition')"
                    },
                    "context": {
                        "type": "string",
                        "enum": ["developer", "operator", "architect", "new_team_member"],
                        "description": "Optional: Your role/context for personalized results"
                    }
                },
                "required": ["topic"]
            }
        )
    ]


@app.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent]:
    """Handle tool calls for HyperShift documentation."""

    try:
        if name == "search_hypershift_docs":
            query = arguments.get("query")
            section = arguments.get("section")

            if not query:
                raise ValueError("Query parameter is required")

            result = doc_index.search_content(query, section)
            return [TextContent(type="text", text=result)]

        elif name == "get_hypershift_section":
            section_name = arguments.get("section_name")

            if not section_name:
                raise ValueError("section_name parameter is required")

            result = doc_index.get_section(section_name)
            return [TextContent(type="text", text=result)]

        elif name == "list_hypershift_sections":
            sections = doc_index.list_sections()
            result = "# HyperShift Onboarding Guide - Available Sections\n\n" + \
                    '\n'.join(f"{i+1}. {s}" for i, s in enumerate(sections))
            return [TextContent(type="text", text=result)]

        elif name == "get_hypershift_learning_path":
            experience_level = arguments.get("experience_level", "beginner")
            result = doc_index.get_learning_path(experience_level)
            return [TextContent(type="text", text=result)]

        elif name == "get_hypershift_topic":
            topic = arguments.get("topic")
            context = arguments.get("context")

            if not topic:
                raise ValueError("topic parameter is required")

            result = doc_index.get_topic_content(topic, context)
            return [TextContent(type="text", text=result)]

        else:
            raise ValueError(f"Unknown tool: {name}")

    except Exception as e:
        return [TextContent(type="text", text=f"Error: {str(e)}")]


async def main():
    """Run the MCP server."""
    async with stdio_server() as (read_stream, write_stream):
        await app.run(
            read_stream,
            write_stream,
            app.create_initialization_options()
        )


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
