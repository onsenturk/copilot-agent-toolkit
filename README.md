# GHCP_SD_Agent

A lightweight governance repository for AI-assisted software delivery using GitHub Copilot.

## What this repository does

This repo defines a **delivery framework** that ensures Copilot-generated changes follow consistent engineering standards. It provides:

- Mandatory engineering rules (`agents/engineering-standards.md`)
- A strict Definition of Done checklist (`agents/dod.md`)
- Request templates for scoped and auditable work:
  - `agents/feature-request-template.md`
  - `agents/change-request-template.md`
- Global Copilot execution instructions (`copilot-instructions.md`)

In short: this repository is a **policy + process layer** for implementation quality, security, architecture discipline, and documentation completeness.

## MCP Servers

This workspace is configured with the following MCP (Model Context Protocol) servers in `.vscode/mcp.json`:

| Server | Package | Purpose |
|---|---|---|
| **Work IQ** | `@microsoft/workiq` | Query Microsoft 365 data — emails, meetings, documents, Teams messages, and people |
| **Playwright** | `@playwright/mcp` | Browser automation, testing, screenshots, and web interaction |
| **Sequential Thinking** | `@modelcontextprotocol/server-sequential-thinking` | Structured reasoning for complex planning and architecture decisions |

Additionally, the following MCP servers are configured at user/profile level:

| Server | Purpose |
|---|---|
| **Azure** | Azure resource management, deployment, diagnostics, and best practices |
| **Bicep** | Bicep file authoring, validation, and ARM template decompilation |
| **GitHub** | GitHub operations — issues, PRs, repos, branches, files, releases, search |
| **Microsoft Docs** | Microsoft Learn documentation search, code sample search, and page fetch |
| **PostgreSQL** | PostgreSQL database querying, schema exploration, and dashboards |
| **Pylance** | Python language features — docs, imports, refactoring, syntax errors |
| **Foundry** | Microsoft Foundry agent management — deploy, evaluate, optimize prompts |

## Repository structure

```text
.
├── .vscode/
│   └── mcp.json
├── copilot-instructions.md
└── agents/
    ├── engineering-standards.md
    ├── dod.md
    ├── feature-request-template.md
    └── change-request-template.md
```

## How to use it

1. Start with either a feature or change request template in `agents/`.
2. Ensure requirements are explicit, testable, and scoped.
3. Follow the mandatory workflow from `copilot-instructions.md`.
4. Implement changes only after impact, security, architecture, and infrastructure analysis.
5. Validate completion against `agents/dod.md` before marking work done.

## Core principles enforced

- Layered architecture compliance
- Strong security hygiene (OWASP-minded defaults)
- Documentation-first discipline
- Minimal scope creep and no unrelated refactors
- Azure-first infrastructure expectations

## Intended audience

- Teams using Copilot for implementation tasks
- Engineers who need consistent review gates
- Tech leads enforcing architecture and security standards

## Status

Initial baseline documentation and governance templates are in place.


## Usage
Create new feature with feature request template
Change request with change request template
Copilot-instructions.md should be under .github directory