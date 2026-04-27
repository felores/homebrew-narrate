# homebrew-narrate

Homebrew tap for [narrate](https://github.com/felores/narrate) — a provider-agnostic TTS gateway and CLI for AI coding harnesses (Claude Code, OpenCode, Pi, Cursor, Windsurf, Cline, ChatGPT Codex, or any shell script).

## Install

```bash
brew tap felores/narrate
brew install narrate
```

This installs:

- `narrate` — the CLI you call from shells, hooks, scripts.
- `narrate-server` — the HTTP + MCP server (port 8888 by default).
- A `brew services` recipe so the server can auto-start at login.
- Bun is pulled in as a runtime dependency.

## Run

```bash
brew services start narrate         # background service, auto-starts at login
# or one-shot in foreground:
narrate-server
```

```bash
narrate verify                      # health snapshot
narrate "Hello world"               # speak via the default voice
narrate --voice researcher "Done"   # use a preset from voices.json
```

## Configure

```bash
# any subset of these — narrate uses what you've set
echo 'ELEVENLABS_API_KEY=...' >> ~/.env
echo 'OPENAI_API_KEY=sk-...'  >> ~/.env
echo 'GEMINI_API_KEY=...'     >> ~/.env
echo 'XAI_API_KEY=...'        >> ~/.env

# Optional: voice presets and defaults
mkdir -p ~/.config/narrate
cp $(brew --prefix narrate)/libexec/voices.json.example ~/.config/narrate/voices.json
cp $(brew --prefix narrate)/libexec/examples/config.example.json ~/.config/narrate/config.json
```

## MCP integration (Claude Code, Cursor, Windsurf, Cline, etc.)

```bash
claude mcp add narrate \
  --transport http \
  --url http://localhost:8888/mcp \
  --header "X-Narrate-Client-Id: claude-code"
```

Or in `.mcp.json` for any HTTP MCP client:

```json
{
  "mcpServers": {
    "narrate": {
      "url": "http://localhost:8888/mcp",
      "headers": { "X-Narrate-Client-Id": "cursor" }
    }
  }
}
```

The agent now sees `narrate.speak`, `narrate.list_voices`, and `narrate.list_providers` as tools.

## Update

```bash
brew update
brew upgrade narrate
```

## Uninstall

```bash
brew services stop narrate
brew uninstall narrate
brew untap felores/narrate
```

## Full documentation

- Main project: https://github.com/felores/narrate
- Providers, voicebox setup, MCP details, voices.json schema, troubleshooting, architecture: see the [main repo's README](https://github.com/felores/narrate#readme).

## License

MIT (this tap and the underlying narrate project).
