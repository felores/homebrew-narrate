class Narrate < Formula
  desc "Provider-agnostic TTS gateway and CLI for AI coding harnesses"
  homepage "https://github.com/felores/narrate"
  url "https://github.com/felores/narrate/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "a47e7535e5f41f9d5219af15669cc64a589499ab8acd69e5e16ed60486586170"
  license "MIT"
  head "https://github.com/felores/narrate.git", branch: "main"

  depends_on "bun"

  def install
    bun = Formula["bun"].opt_bin/"bun"

    # Install JS deps before copying source into libexec.
    system bun, "install", "--frozen-lockfile"

    # Copy entire project (with node_modules) into the formula's private libexec.
    libexec.install Dir["*"]

    # Wrapper: narrate (CLI)
    (bin/"narrate").write <<~SH
      #!/usr/bin/env bash
      exec "#{bun}" run "#{libexec}/src/cli.ts" "$@"
    SH

    # Wrapper: narrate-server (HTTP + MCP server)
    (bin/"narrate-server").write <<~SH
      #!/usr/bin/env bash
      exec "#{bun}" run "#{libexec}/src/server.ts" "$@"
    SH
  end

  service do
    run [opt_bin/"narrate-server"]
    keep_alive true
    log_path var/"log/narrate.log"
    error_log_path var/"log/narrate-error.log"
  end

  def caveats
    <<~CAVEATS
      narrate needs API keys for the cloud providers you want to use.
      Add any subset of these to your ~/.env or shell init:

          export ELEVENLABS_API_KEY=...
          export OPENAI_API_KEY=...
          export GEMINI_API_KEY=...
          export XAI_API_KEY=...

      Voicebox provider auto-detects http://127.0.0.1:17493 (no key needed).
      System provider (macOS `say`) needs no config.

      Optional config:
          mkdir -p ~/.config/narrate
          cp #{opt_libexec}/voices.json.example ~/.config/narrate/voices.json
          cp #{opt_libexec}/examples/config.example.json ~/.config/narrate/config.json

      Run as a background service:
          brew services start narrate

      Or one-shot:
          narrate-server

      Verify:
          narrate verify

      MCP integration (Claude Code):
          claude mcp add narrate \\
            --transport http \\
            --url http://localhost:8888/mcp \\
            --header "X-Narrate-Client-Id: claude-code"
    CAVEATS
  end

  test do
    assert_match "narrate - speak text", shell_output("#{bin}/narrate --help")
  end
end
