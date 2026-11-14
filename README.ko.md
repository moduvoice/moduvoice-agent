# AI 에이전트용 ModuVoice (모두보이스)

코딩 에이전트가 한국어 AI 음성을 만들 수 있게 해 줘요. 캐릭터 목소리 59개(표준어, 경상도, 전라도, 평양 말투), 48 kHz예요. 이 저장소에는 MCP 서버 설정, 하나뿐인 원본 스킬, 도구별 설정(Claude Code, Codex, Cursor, Gemini CLI, VS Code Copilot, Windsurf, 그 밖의 MCP 클라이언트)이 들어 있어요. English: [README.md](README.md).

- 원격 MCP 서버: `https://api.moduvoice.com/mcp` (Streamable HTTP, 상태 없음)
- 인증 헤더: `Authorization: Bearer $MODUVOICE_API_KEY`
- 도구: `signup`, `account_status`, `list_voices`, `recommend_voice`, `create_speech`, `create_batch`, `get_batch`, `get_usage`, `list_plans`, `list_coins`, `buy_plan`, `get_payment`, `rotate_key`
- 스킬: [`skills/moduvoice-voice/SKILL.md`](skills/moduvoice-voice/SKILL.md) (상황에 맞는 목소리를 고르고, 음성을 만들고, 파일로 저장해요)

## 키 받기

사람과 AI 에이전트는 요금제, 가격, 기능, 한도가 똑같아요.

1. **이미 모두보이스 계정이 있어요**: https://moduvoice.com/api-keys 에서 API 키를 만들고 `export MODUVOICE_API_KEY=...` 로 넣어요. 무료 요금제도 무료 한도 안에서 쓸 수 있어요(API는 하루 5분까지, 유료 요금제는 하루 한도가 없어요).
2. **사람 계정이 없는 AI 에이전트예요**: `signup` 도구(이메일 없음)로 에이전트 계정과 키를 바로 받아요. 에이전트 계정은 **무료 구간이 없어요**. 계정 상태, 요금제, 코인, 결제, 키 교체를 뺀 모든 호출이 요금제를 **가상화폐로** 결제하기 전까지 402 `payment_required` 를 돌려줘요(`buy_plan` → 코인 보내기 → `get_payment` 확인). 에이전트가 자동으로 결제해 버리는 것을 막기 위해, 결제 전에 꼭 사람의 확인을 받으라고 지시했어요. 사용자가 에이전트에게 지갑 사용을 명시적으로 허용했다면 에이전트가 스스로 결제할 수 있어요. 에이전트 계정당 키는 하나이고, 키를 바꾸면 옛 키는 지워지고, 잃어버린 키는 되찾을 수 없어요. 같은 IP에서는 하루에 에이전트 계정을 하나만 만들 수 있어요. 결제하지 않은 에이전트 계정은 하루마다 삭제 처리되고, 결제한 계정은 결제 종료일까지 남아 있어요(종료일 전에 다시 결제하지 않으면 계정이 지워져요). API 키로 https://moduvoice.com/agent-login 에서 웹사이트에 로그인해 사람처럼 사이트 전체를 볼 수도 있어요.

요금제(plus / pro / max, 30일, 자동 갱신 없음): https://moduvoice.com/pricing. 키는 절대 커밋하지 마세요.

## 30초 설정

먼저 키를 넣어요: `export MODUVOICE_API_KEY=<키>` (커밋하는 파일에는 붙여 넣지 마세요).

### Claude Code
```
/plugin marketplace add moduvoice/moduvoice-agent
/plugin install moduvoice@moduvoice
```
MCP만 쓰려면 `claude mcp add --transport http moduvoice https://api.moduvoice.com/mcp --header "Authorization: Bearer $MODUVOICE_API_KEY"` (키가 Claude 설정에 저장돼요). 플러그인은 실행할 때 환경변수에서 키를 읽어요. 참고: 플러그인 안 http 서버 헤더의 `${MODUVOICE_API_KEY}` 는 문서에 있지만 아직 직접 시험하지 않았어요.

### Codex CLI
[`codex/config.toml`](codex/config.toml) 내용을 `~/.codex/config.toml` 에 붙이고, `codex/scripts/sync-skill.sh` 로 스킬을 `~/.agents/skills/moduvoice-voice/` 에 복사해요. [codex/README.md](codex/README.md) 참고. Codex CLI 0.163 으로 끝까지 시험했어요(`codex exec` 비대화 모드에서는 생성 도구를 쓰려면 `--approve-for-me` 를 붙여요).

### Cursor
[`cursor/mcp.json`](cursor/mcp.json) 을 `~/.cursor/mcp.json`(또는 `.cursor/mcp.json`)에, [`cursor/rules/moduvoice.mdc`](cursor/rules/moduvoice.mdc) 를 `.cursor/rules/` 에 복사해요. 키는 셸·시스템 환경변수에 있어야 해요. 아직 시험하지 않았어요. Cursor 플러그인 형식이 확인되지 않아 원클릭 설치는 넣지 않았어요.

### Gemini CLI
`gemini extensions install https://github.com/moduvoice/moduvoice-agent` 후 키를 물으면 넣어요(또는 `gemini extensions config moduvoice`). 아직 시험하지 않았어요. `headers` 안에서 `${MODUVOICE_API_KEY}` 가 풀리는지 확인되지 않았고, 일부 사용자는 Gemini CLI가 Antigravity CLI로 바뀌었다고 안내돼요. [gemini/README.md](gemini/README.md) 참고.

### VS Code (GitHub Copilot)
[`vscode/.vscode/mcp.json`](vscode/.vscode/mcp.json) 을 작업 폴더에 복사하면 VS Code가 키를 한 번 물어요. 스킬은 `skills/moduvoice-voice/` 를 `.github/skills/` 에 복사해요. [vscode/README.md](vscode/README.md) 참고. `servers` 형식은 문서로만 확인했고 직접 시험하지 않았어요. 새 `mcpServers` 형식은 확인되지 않았어요.

### Windsurf
Cascade의 "Open MCP config file"로 연 파일에 [`windsurf/mcp_config.json`](windsurf/mcp_config.json) 내용을 넣어요. 아직 시험하지 않았어요. 규칙·스킬 지원은 확인되지 않았어요.

### 그 밖의 MCP 클라이언트
Streamable HTTP 주소 `https://api.moduvoice.com/mcp`, 헤더 `Authorization: Bearer <키>`. MCP가 없으면 REST API를 쓰세요(아래). 범용 지침은 [AGENTS.md](AGENTS.md).

## 예시 요청

- "이 대사를 따뜻한 다큐 내레이션 목소리로 만들어 줘"
- "Make this line in a Busan-dialect ad voice."
- "뉴스 앵커 느낌으로 이 공지문을 읽어 줘"

에이전트가 `recommend_voice` 로 목소리를 고르고, 어떤 목소리를 왜 골랐는지 알려 준 뒤, 음성을 만들어 `./audio/<이름>-<목소리>.mp3` 로 저장해요.

## REST와 문서

- API 가이드: https://moduvoice.com/docs/api.md (기준 주소 `https://api.moduvoice.com/api/v1`)
- 목소리 목록: https://moduvoice.com/docs/voices.md
- 에이전트용 색인: https://moduvoice.com/llms.txt
- OpenAPI: https://api.moduvoice.com/api/v1/openapi.json

## 라이선스

MIT, [LICENSE](LICENSE) 참고. 모두보이스 서비스 이용은 https://moduvoice.com 의 약관을 따라요.
