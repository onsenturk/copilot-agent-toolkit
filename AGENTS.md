# AGENTS.md

Cross tool agent instructions for the copilot-agent-toolkit. These rules apply to every AI coding agent that opens this repository (VS Code, GitHub Copilot CLI, Claude Code, and others). They capture the always on essentials. The full detail lives in the files referenced below.

## Governing standards

All implementations must comply with:

- [.github/agents/engineering-standards.agent.md](.github/agents/engineering-standards.agent.md) for architecture, security, infrastructure, and coding rules.
- [.github/agents/dod.agent.md](.github/agents/dod.agent.md) for the Definition of Done checklist that gates every task.

These rules are not negotiable. If a request conflicts with them, explain the conflict, propose a compliant alternative, and do not proceed with a non compliant change.

## Always on rules

1. **Ground every factual claim.** Cite the source: Microsoft Learn for Azure and Microsoft topics, official vendor docs for everything else, and the codebase itself for repo claims. Mark certainty as verified, likely, or uncertain. Prefer research over confidence.
2. **Security first.** Follow OWASP Top 10 defaults: parameterized queries, output encoding, no hardcoded secrets, least privilege. See [.github/instructions/security-and-owasp.instructions.md](.github/instructions/security-and-owasp.instructions.md).
3. **Azure safety.** Read [azure.md](azure.md) before any Azure work. Never create, update, or delete Azure resources without explicit approval. Read only queries, documentation lookups, and local IaC authoring are allowed.
4. **Implementation discipline.** Make only the changes requested or clearly necessary. No scope creep, no unrelated refactors, no speculative error handling. Prefer the simplest viable approach.
5. **Discovery before action.** Check the available skills, agents, and instruction files for a match before answering non trivial requests, and consult prior notes in memory when available.

## File scoped rules

This repository keeps language and topic rules in [.github/instructions/](.github/instructions/). Before editing a file, read the matching `*.instructions.md` (selected by its `applyTo` glob) and follow it. Examples cover Bicep, PowerShell, shell, markdown, draw.io, and agent safety.

## Where the full instructions live

- [.github/copilot-instructions.md](.github/copilot-instructions.md): the complete orchestration and workflow rules.
- [.github/agents/](.github/agents/): specialized agent personas.
- [.github/skills/](.github/skills/): on demand skill packs.

VS Code reads `.github/copilot-instructions.md` and this `AGENTS.md` automatically. GitHub Copilot CLI reads `AGENTS.md`. Claude Code reads `CLAUDE.md`, which points here.
