---
name: moduvoice-voice
description: Make Korean speech with ModuVoice (59 character voices, standard Korean plus Gyeongsang, Jeolla and Pyongyang dialects). Use when the user asks to turn a line or script into a voice that fits some use or mood, TTS, narration, an ad or anchor voice, a dialect voice, or says things like "음성으로 만들어", "내레이션", "성우 목소리", "TTS", "make this line in a voice that fits X". Works for humans with their own API key and for AI agents with an agent account.
license: MIT
compatibility: Needs the ModuVoice MCP server (https://api.moduvoice.com/mcp) or curl/HTTP access, and env MODUVOICE_API_KEY.
---

# ModuVoice voice maker

ModuVoice is Korean text-to-speech. Humans and AI agents get the same plans, prices, features and limits. Pricing: https://moduvoice.com/pricing. API guide: https://moduvoice.com/docs/api.md.

MCP tools (server `moduvoice`): `signup`, `account_status`, `list_voices`, `recommend_voice`, `create_speech`, `create_batch`, `get_batch`, `get_usage`, `list_plans`, `list_coins`, `buy_plan`, `get_payment`, `rotate_key`.

## Workflow

### 1. Check the key
Is `MODUVOICE_API_KEY` set (and the MCP server connected)? Never print, log or commit the key.

- **Human with a ModuVoice account**: ask them to create a key at https://moduvoice.com/api-keys and export it as `MODUVOICE_API_KEY`. The free plan works within its limits (API: 5 minutes of audio per day); paid plans have no daily limit.
- **No account (you are an AI agent)**: call `signup` (no email needed). It returns an account and one key, shown once. Tell the user to store it as `MODUVOICE_API_KEY` (e.g. in their credentials file or shell profile). One key per agent account; `rotate_key` deletes the old key; a lost key cannot be recovered.
  Agent accounts have **no free tier**: every call except `account_status`, `list_plans`, `list_coins`, `get_payment`, `rotate_key` returns 402 `payment_required` until a plan is paid in crypto (see "Payment").

### 2. Understand the situation
Find out, from the request or by asking one short question: what the audio is for (ad, news, audiobook, documentary, game character, announcement), the mood (warm, serious, bright), dialect (standard, Busan/Gyeongsang, Jeolla, Pyongyang) and gender if the user said so. Do not over-ask; if unclear, go with the best guess and offer alternatives.

### 3. Pick a voice
Call `recommend_voice` with the situation (and `text` / `dialect` if known). Use `list_voices` to browse or verify an id. Never invent voice ids. Tell the user which voice you picked and why in one or two lines, and name one or two alternatives. If nothing fits, default to `sera` (standard Korean narration).

### 4. Create the audio
- One line: `create_speech` with `voice` and `text` (1 to 500 characters of Korean text; the REST API calls this field `input`). It waits up to about 30 s and returns the audio URL.
- Long script: split on sentence boundaries into lines of at most about 450 characters. For many lines use `create_batch` (up to 100 items, each with your own `id` to keep order), then `get_batch` until `status` is `done` or `partial` (poll no more often than every 30 s).
- If a call answers "queued" (HTTP 202), the GPU is busy or restarting; poll with `get_batch` / the `status_url` instead of keeping the connection open.
- Only items with `status: "done"` have a `url`.

### 5. Save and report
Download each URL (plain GET, no key needed) to the project, default `./audio/<slug>-<voice>.mp3` (create the folder; slug from the text or purpose). Report the path, voice and duration (`audio_seconds`). For several lines, join them in order only if the user asks (re-encode with ffmpeg for mp3). Audio is also kept in the account's storage for 28 days.

### 6. Errors
Branch on the JSON `code`, not the Korean `detail` text.

| Status / code | Do |
|---|---|
| 401 `missing_api_key` / `invalid_api_key` | Ask the user for a valid key. Do not guess. |
| 402 `payment_required` | Agent account without a paid plan: go to "Payment". |
| 403 `api_daily_limit` | Free plan 5 min/day reached. Explain; retry after `retry_after` seconds (KST midnight) or suggest a plan. |
| 403 `request_exceeds_daily_limit` | One request is bigger than the free daily limit. Split it; never retry as is. |
| 403 `monthly_quota_exceeded` | Send less, wait for the monthly reset, or buy a plan. |
| 400 `unknown_voice` | Call `list_voices`, choose a valid id. |
| 409 `open_batch_cap` | Too many batches waiting; wait for one to finish. |
| 429 / 502 / 503 (retryable) | Wait `retry_after` (or 30 s) and retry. |
| 400 / 401 / 403 / 422 otherwise | Do not retry the same request; fix it or tell the user. |

## Payment (crypto)
1. `list_plans` (plus / pro / max, 30 days each, no auto-renewal, prices in KRW; see https://moduvoice.com/pricing). Suggest the cheapest that fits the amount of audio needed.
2. `list_coins` for accepted coins.
3. **Get the human's confirmation of the plan and coin before paying.** This rule exists to prevent automatic payments. Only if the user has explicitly allowed you to use a wallet may you pay on your own.
4. `buy_plan` returns the address, exact amount, network, optional memo (`extra_id`) and `expires_at`. Show these to the human. Send at least the amount, on the exact network, before expiry; underpaid or late payments do not turn the plan on.
5. Poll `get_payment` every 30 to 60 s until `status` is `paid` and `active` is true. If one is still `waiting`, poll it; do not create a second payment.

## REST fallback (MCP not connected)
Base `https://api.moduvoice.com/api/v1`, header `Authorization: Bearer $MODUVOICE_API_KEY`.

```bash
# recommend a voice
curl -s -X POST https://api.moduvoice.com/api/v1/voices/recommend \
  -H "Authorization: Bearer $MODUVOICE_API_KEY" -H "Content-Type: application/json" \
  -d '{"situation":"warm documentary narration","dialect":"표준어"}'

# one line (waits up to 30 s; 200 with items[0].url, or 202 queued)
curl -s -X POST https://api.moduvoice.com/api/v1/audio/speech \
  -H "Authorization: Bearer $MODUVOICE_API_KEY" -H "Content-Type: application/json" \
  -H "Idempotency-Key: $(uuidgen)" \
  -d '{"voice":"sera","input":"안녕하세요, 모두보이스입니다."}'

# download
mkdir -p audio && curl -s -o audio/hello-sera.mp3 "<items[0].url>"
```

Other endpoints: `GET /voices`, `POST /batches`, `GET /batches/{id}`, `GET /usage`, `GET /billing/plans`, `GET /billing/crypto/currencies`, `POST /billing/crypto/payments {plan, pay_currency}`, `GET /billing/crypto/payments/{id}`, `POST /agents/signup`, `GET /agents/me`, `POST /agents/key/rotate`. Details: https://moduvoice.com/docs/api.md.

## Rules
- Never put the API key in code, logs, prompts or commits.
- Never pay without the human's confirmation, unless the user has explicitly allowed you to use a wallet.
- Agent signup: one agent account per IP per day. Unpaid agent accounts are deleted daily; paid accounts remain until the plan's end date — renew (pay again) before `ends_at`, or the account and its files are deleted. An agent can log in to the website with its API key at https://moduvoice.com/agent-login.
- Free-plan audio is personal use only; commercial use needs a paid plan.
