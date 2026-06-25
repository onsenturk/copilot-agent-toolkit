# Roadmap

Planned but not-yet-implemented changes to the toolkit. Items here are intentionally deferred — not abandoned.

---

## MCP-server distribution model (superseded)

**Status**: Superseded on 2026-06-25. Resolved by packaging the toolkit as an agent plugin plus a user level install, not a hosted MCP server. See the decision below.

### What shipped instead

Option A from the distribution review:

- **User level install** ([scripts/install-global.ps1](scripts/install-global.ps1) and [scripts/install-global.sh](scripts/install-global.sh)) copies instructions, agents, and skills into the documented GA locations (`~/.copilot/instructions`, `~/.copilot/agents`, `~/.copilot/skills`, plus `~/.claude/skills` and `~/.agents/skills`). One install applies across every repo, and Settings Sync propagates it across machines.
- **Agent plugin packaging** ([plugin.json](plugin.json), [.mcp.json](.mcp.json), [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)) gives a one click, auto updating install that works across VS Code, GitHub Copilot CLI, and Claude Code, and bundles the MCP servers.
- **Cross tool always on rules** ([AGENTS.md](AGENTS.md) for VS Code and Copilot CLI, [CLAUDE.md](CLAUDE.md) for Claude Code).
- **Per project copy** ([scripts/pull-toolkit.ps1](scripts/pull-toolkit.ps1)) stays as the GA route for committing the toolkit into a single repo.

### Why not a hosted MCP server

- An MCP server cannot auto load instructions or honor `applyTo` globs. Those still require local files.
- Agents and skills served over MCP are returned as text, not registered as native agents and skills. You lose the agent picker, the skill slash commands, and automatic skill matching.
- It needs hosting, auth, and uptime. If the server is down, the toolkit is unavailable.
- Agent Plugins now natively bundle skills, agents, hooks, and MCP servers and auto update from Git, which delivers the register once, always current goal without any of the above.

The workspace [.vscode/mcp.json](.vscode/mcp.json) stays as a local development convenience.

---

## Other parked items

_Add new deferred items below as bullets — promote them to their own section once they're picked up._
