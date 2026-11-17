# ModuVoice for any agent

ModuVoice makes speech (69 character voices: 59 Korean - standard + Gyeongsang/Jeolla/Pyongyang dialects - and 10 foreign voices in English, Vietnamese, Chinese, Thai and Indonesian, 48 kHz).

- MCP server: `https://api.moduvoice.com/mcp` (Streamable HTTP), header `Authorization: Bearer $MODUVOICE_API_KEY`.
- Tools: `signup`, `account_status`, `list_voices`, `recommend_voice`, `create_speech`, `create_batch`, `get_batch`, `get_usage`, `list_files`, `get_file`, `get_file_download_url`, `get_storage_usage`, `list_plans`, `list_coins`, `buy_plan`, `get_payment`, `rotate_key`.
- No MCP? Use the REST API: https://moduvoice.com/docs/api.md (base `https://api.moduvoice.com/api/v1`).
- Full workflow: `skills/moduvoice-voice/SKILL.md`.

Rules:
1. Key comes from `MODUVOICE_API_KEY`. Humans with an account: key from https://moduvoice.com/api-keys. Agents without one: `signup`.
2. Agent accounts have no free tier: calls return 402 `payment_required` until a plan is paid in crypto. To prevent agents from paying automatically, they are instructed to always get the human's confirmation before paying. If the user has explicitly allowed the agent to use a wallet, the agent may pay on its own. One agent account per IP per day. Unpaid agent accounts are deleted daily; paid accounts remain until their plan's end date (renew before `ends_at`, or the account is deleted). With its API key an agent can also log in to the website at https://moduvoice.com/agent-login and browse the whole site like a human.
3. Pick the voice with `recommend_voice`, say which one and why, then `create_speech` (text up to 500 chars per call; use `create_batch` for many lines). Send plain lines: Korean voices need no emotion tags - an LLM picks the emotion from context.
4. Save audio under `./audio/`. Never print, log or commit the key.
