# ModuVoice for AI agents

Korean AI text-to-speech for your coding agent: 69 character voices (59 Korean: standard plus Gyeongsang, Jeolla and Pyongyang dialects; 10 foreign: English, Vietnamese, Chinese, Thai, Indonesian), 48 kHz. This repo has an MCP server config, one canonical skill, and per-tool setup for Claude Code, Codex, Cursor, Gemini CLI, VS Code Copilot, Windsurf and any MCP client. Korean version: [README.ko.md](README.ko.md).

- Remote MCP server: `https://api.moduvoice.com/mcp` (Streamable HTTP, stateless)
- Auth header: `Authorization: Bearer $MODUVOICE_API_KEY`
- Tools: `signup`, `account_status`, `list_voices`, `recommend_voice`, `create_speech`, `create_batch`, `get_batch`, `get_usage`, `list_files`, `get_file`, `get_file_download_url`, `get_storage_usage`, `list_plans`, `list_coins`, `buy_plan`, `get_payment`, `rotate_key`
- Skill: [`skills/moduvoice-voice/SKILL.md`](skills/moduvoice-voice/SKILL.md) (pick a fitting voice, make the audio, save it)

## Getting a key

Humans and AI agents get the same plans, prices, features and limits.

1. **You already have a ModuVoice account**: create an API key at https://moduvoice.com/api-keys and `export MODUVOICE_API_KEY=...`. The API needs a paid plan (Plus, Pro or Max); on the free plan API calls return 403 `plan_required`. Paid plans have no daily limit, only the monthly minutes.
2. **You are an AI agent without a human account**: the `signup` tool (no email) gives an agent account and a key at once. Agent accounts have **no free tier**: every call except account status, plans, coins, payment and key rotation returns 402 `payment_required` until a plan is paid **with crypto** (`buy_plan`, send the coin, poll `get_payment`). To prevent agents from paying automatically, they are instructed to always get the human's confirmation before paying. If the user has explicitly allowed the agent to use a wallet, the agent may pay on its own. One key per agent account; rotating deletes the old key; a lost key cannot be recovered. One agent account per IP per day. Unpaid agent accounts are deleted daily; paid accounts remain until their plan's end date (renew before `ends_at`, or the account is deleted). With its API key an agent can also log in to the website at https://moduvoice.com/agent-login and browse the whole site like a human.

Plans (plus / pro / max, 30 days, no auto-renewal): https://moduvoice.com/pricing. Never commit your key.

## 30-second setup

Set the key first: `export MODUVOICE_API_KEY=<your key>` (never paste it into files you commit).

### Claude Code
```
/plugin marketplace add moduvoice/moduvoice-agent
/plugin install moduvoice@moduvoice
```
Or MCP only: `claude mcp add --transport http moduvoice https://api.moduvoice.com/mcp --header "Authorization: Bearer $MODUVOICE_API_KEY"` (this stores the key in your Claude config). The plugin reads the key from the environment at run time. Note: the plugin's `${MODUVOICE_API_KEY}` header with an http server is documented but not yet tested by us.

### Codex CLI
Add [`codex/config.toml`](codex/config.toml) to `~/.codex/config.toml`, then install the skill: `codex/scripts/sync-skill.sh` copies it to `~/.agents/skills/moduvoice-voice/`. See [codex/README.md](codex/README.md). Tested end-to-end with Codex CLI 0.163 (in `codex exec`, add `--approve-for-me` so write tools can run).

### Cursor
Copy [`cursor/mcp.json`](cursor/mcp.json) to `~/.cursor/mcp.json` (or `.cursor/mcp.json`) and [`cursor/rules/moduvoice.mdc`](cursor/rules/moduvoice.mdc) to `.cursor/rules/`. The key must be in your shell/system environment. Not yet tested; one-click install via a Cursor plugin is not provided because its schema is unconfirmed.

### Gemini CLI
`gemini extensions install https://github.com/moduvoice/moduvoice-agent`, then set the key when asked (or `gemini extensions config moduvoice`). Not yet tested: whether `${MODUVOICE_API_KEY}` expands inside `headers` is unconfirmed, and Gemini CLI was announced as replaced by Antigravity CLI for some users. See [gemini/README.md](gemini/README.md).

### VS Code (GitHub Copilot)
Copy [`vscode/.vscode/mcp.json`](vscode/.vscode/mcp.json) to your workspace; VS Code asks for the key once. For the skill, copy `skills/moduvoice-voice/` to `.github/skills/`. See [vscode/README.md](vscode/README.md). The `servers` format is tested by docs only (not by us); the newer portable `mcpServers` format is unconfirmed.

### Windsurf
Add [`windsurf/mcp_config.json`](windsurf/mcp_config.json) content via Cascade's "Open MCP config file". Not yet tested; rules/skill support unconfirmed.

### Any other MCP client
Streamable HTTP URL `https://api.moduvoice.com/mcp` with header `Authorization: Bearer <key>`. No MCP? Use the REST API (below). Generic agent instructions: [AGENTS.md](AGENTS.md).

## Example prompts

- "Make this line in a warm documentary narration voice: ..." (Korean text)
- "Make this line in a Busan-dialect ad voice."
- "이 대사를 따뜻한 다큐 내레이션 목소리로 만들어 줘"
- "뉴스 앵커 느낌으로 이 공지문을 읽어 줘"

The agent picks a voice with `recommend_voice`, tells you which and why, makes the audio, and saves it to `./audio/<slug>-<voice>.mp3`.

## REST and docs

- API guide: https://moduvoice.com/docs/api.md (base `https://api.moduvoice.com/api/v1`)
- Voices: https://moduvoice.com/docs/voices.md
- Agent index: https://moduvoice.com/llms.txt
- OpenAPI: https://api.moduvoice.com/api/v1/openapi.json

## Layout

```
.claude-plugin/   marketplace.json, plugin.json (Claude Code)
.mcp.json         plugin MCP config
skills/           canonical skill (single source of truth)
codex/ cursor/ gemini/ vscode/ windsurf/   per-tool snippets
gemini-extension.json, GEMINI.md           Gemini CLI extension (repo root is required)
AGENTS.md         generic instructions
```

## License

MIT, see [LICENSE](LICENSE). Use of the ModuVoice service is governed by its own terms at https://moduvoice.com.
