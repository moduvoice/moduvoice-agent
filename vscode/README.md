# VS Code (GitHub Copilot)

Copy `.vscode/mcp.json` into your workspace. VS Code prompts for the key once and stores it (password input). To read from the environment instead, use `"Bearer ${env:MODUVOICE_API_KEY}"`.

Skill: copy `skills/moduvoice-voice/` to `.github/skills/moduvoice-voice/` (or use `.claude/skills/`).

Not yet tested. The `servers` format is documented but marked deprecated, to be removed in February 2027. The newer portable `.mcp.json` (`mcpServers`, `${NAME}`) schema is unconfirmed; the Claude-style `.mcp.json` at the repo root may or may not be picked up.
