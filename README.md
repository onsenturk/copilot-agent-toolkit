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
├── .github/
│   ├── copilot-instructions.md          # Orchestration — references agents, defines workflow
│   └── agents/
│       ├── engineering-standards.md      # Architecture, security, infra, AI/ML standards
│       ├── dod.md                        # Definition of Done checklist
│       ├── feature-request-template.md   # New feature implementation template
│       └── change-request-template.md    # Bug fix / refactor / modification template
├── .vscode/
│   ├── extensions.json                  # Recommended VS Code extensions
│   └── mcp.json                         # Workspace MCP server configuration
└── scripts/
    ├── init-setup.ps1                   # Windows setup script
    └── init-setup.sh                    # macOS/Linux setup script
```

## Agents

| Agent | Invoke with | Purpose |
|---|---|---|
| **Engineering Standards** | `@engineering-standards` | Review architecture, security, infrastructure, and coding compliance |
| **Definition of Done** | `@dod` | Validate task completion before marking done |
| **Feature Request** | `@feature-request-template` | Structured template for implementing new features |
| **Change Request** | `@change-request-template` | Structured template for bug fixes, refactors, and modifications |

## Getting Started (New Machine / Fresh Clone)

### Prerequisites

- **VS Code** with the CLI on PATH (`code` command)
- **GitHub Copilot** license

### Automated Setup

**Windows (PowerShell):**
```powershell
.\scripts\init-setup.ps1            # full setup
.\scripts\init-setup.ps1 -DryRun    # preview changes without applying
```

**macOS / Linux (Bash):**
```bash
chmod +x scripts/init-setup.sh
./scripts/init-setup.sh              # full setup
./scripts/init-setup.sh --dry-run    # preview changes without applying
```

The script will:
1. Install recommended VS Code extensions (Copilot, Azure, Bicep, Pylance, PostgreSQL, Foundry)
2. Register user-level MCP servers (GitHub MCP, Microsoft Docs MCP) if not already configured
3. Validate the workspace config files exist

Use `--skip-extensions` or `--skip-mcp` to skip individual steps.

### Manual Setup (if you prefer)

1. Install the extensions listed in `.vscode/extensions.json` (VS Code will prompt on first open)
2. Add these to your user-level `mcp.json` (File > Preferences > MCP Servers, or via MCP Gallery):
   - **GitHub MCP** — `https://api.githubcopilot.com/mcp/`
   - **Microsoft Docs MCP** — `https://learn.microsoft.com/api/mcp`

## How to use it

1. Use `@feature-request-template` or `@change-request-template` to scope work.
2. Copilot will follow the mandatory workflow from `copilot-instructions.md`.
3. Implementation only begins after impact, security, architecture, and infrastructure analysis.
4. Use `@dod` to validate completion before marking work done.
5. Use `@engineering-standards` to review compliance at any point.

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