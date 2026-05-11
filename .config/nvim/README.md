# Neovim Setup

This Neovim configuration is built for fast, focused editing: strong navigation, polished markdown workflows, Git visibility, AI-assisted development, and screen-sharing safety without turning the editor into a slow IDE clone.

## Why it is awesome

- **Fast project movement** — Snacks-powered picker, explorer, grep, and Git helpers keep navigation close to the keyboard.
- **Readable writing environment** — Markdown preview, rendered markdown, table-of-contents generation, bullets, and Obsidian integration make notes and docs first-class citizens.
- **Git context in the editor** — Gitsigns exposes blame, hunks, diffs, staging, and navigation where the work happens.
- **AI workflow ready** — Copilot and OpenCode are configured as editor-native assistants instead of detached side tools.
- **Terminal-native ergonomics** — tmux navigation, floating file labels, undo history, and multiple cursors keep daily editing smooth.
- **Presentation-safe** — Screenkey helps demos, while Veil hides secrets when streaming or sharing a screen.
- **Ops-friendly extras** — Ansible, Helm, and SOPS support make infrastructure files easier to edit safely.

## Plugin roster

See the maintained plugin list in [lua/plugins/README.md](lua/plugins/README.md).

That roster intentionally lists only plugins with their own top-level `.lua` spec file, not dependency sub-plugins declared inside those specs.
