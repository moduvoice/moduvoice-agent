# Codex CLI

1. Add `config.toml` (this folder) to `~/.codex/config.toml`, and export `MODUVOICE_API_KEY`.
2. Install the skill. The canonical file is `skills/moduvoice-voice/SKILL.md`; do not edit copies. Run `codex/scripts/sync-skill.sh [target-skills-dir]` (default `~/.agents/skills`; use `<repo>/.agents/skills` for one project). Re-run it after updating this repo.
3. Optional: put `AGENTS.md` from the repo root in your project.

Tested 2026-11-14 with Codex CLI 0.163: MCP server from `config.toml` keys plus the skill in `<project>/.agents/skills/moduvoice-voice/` — Codex picked a voice, called `create_speech` and saved the MP3. In `codex exec` (non-interactive) write tools such as `create_speech` need approval: add `--approve-for-me`, or run interactively and approve. Codex plugin packaging and `$skill-installer` syntax are not used here.
