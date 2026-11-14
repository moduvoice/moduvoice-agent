# Gemini CLI

`gemini-extension.json` and `GEMINI.md` live at the repo root because `gemini extensions install <GitHub URL>` needs them there. The extension also ships `skills/moduvoice-voice/SKILL.md`.

    gemini extensions install https://github.com/moduvoice/moduvoice-agent

Not yet tested: whether `${MODUVOICE_API_KEY}` expands inside `headers` for extension MCP servers is unconfirmed. If it does not, add the server by hand: `gemini mcp add --transport http --header "Authorization: Bearer <key>" moduvoice https://api.moduvoice.com/mcp` (this stores the key in the Gemini config). Gemini CLI docs also say it was replaced by Antigravity CLI for unpaid/Google One users on 2026-06-18; check current support first.
