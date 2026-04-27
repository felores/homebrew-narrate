# homebrew-narrate

Homebrew tap for [narrate](https://github.com/felores/narrate) — a provider-agnostic TTS gateway and CLI for AI coding harnesses.

## Install

```bash
brew tap felores/narrate
brew install narrate
```

## Use

```bash
# Start the server (foreground)
narrate-server

# Or as a background service
brew services start narrate

# Verify everything is wired up
narrate verify

# Speak
narrate "Hello world"
narrate --voice researcher "Findings ready"
```

See the main repo for full docs: https://github.com/felores/narrate
