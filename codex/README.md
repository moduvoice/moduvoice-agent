# Codex CLI

1. Add `config.toml` (this folder) to `~/.codex/config.toml`, and export `MODUVOICE_API_KEY`.
2. Install the skill. The canonical file is `skills/moduvoice-voice/SKILL.md`; do not edit copies. Run `codex/scripts/sync-skill.sh [target-skills-dir]` (default `~/.agents/skills`; use `<repo>/.agents/skills` for one project). Re-run it after updating this repo.
3. Optional: put `AGENTS.md` from the repo root in your project.

Not yet tested: the `.agents/skills` location comes from current docs; the `$skill-installer` syntax for other repositories and Codex plugin packaging are unconfirmed.
