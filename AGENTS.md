# ModuVoice for any agent

ModuVoice makes Korean speech (59 character voices, standard + Gyeongsang/Jeolla/Pyongyang dialects, 48 kHz).

- MCP server: `https://api.moduvoice.com/mcp` (Streamable HTTP), header `Authorization: Bearer $MODUVOICE_API_KEY`.
- Tools: `signup`, `account_status`, `list_voices`, `recommend_voice`, `create_speech`, `create_batch`, `get_batch`, `get_usage`, `list_plans`, `list_coins`, `buy_plan`, `get_payment`, `rotate_key`.
- No MCP? Use the REST API: https://moduvoice.com/docs/api.md (base `https://api.moduvoice.com/api/v1`).
- Full workflow: `skills/moduvoice-voice/SKILL.md`.

Rules:
1. Key comes from `MODUVOICE_API_KEY`. Humans with an account: key from https://moduvoice.com/api-keys. Agents without one: `signup`.
2. Agent accounts have no free tier: calls return 402 `payment_required` until a plan is paid in crypto. Always ask the human to confirm before sending any crypto.
3. Pick the voice with `recommend_voice`, say which one and why, then `create_speech` (text up to 500 chars per call; use `create_batch` for many lines).
4. Save audio under `./audio/`. Never print, log or commit the key.
