# Plugins

Neovim plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

| Plugin                                                                               | Description                                                                                    |
| ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| [bullets.vim](https://github.com/bullets-vim/bullets.vim)                            | Auto-creates bullet points on new lines, respecting indentation in markdown/text files         |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua)                             | Pure Lua GitHub Copilot client with auto-trigger suggestions and telemetry disabled            |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                          | Git decorations in the sign column — inline blame, hunk navigation, staging, and diffs         |
| [goto-preview](https://github.com/rmagatti/goto-preview)                             | Floating window previews for LSP definitions, declarations, implementations, and references    |
| [icon-picker.nvim](https://github.com/ziontee113/icon-picker.nvim)                   | Pick and insert nerd font icons, emojis, symbols, and alt fonts via a fuzzy finder             |
| [incline.nvim](https://github.com/b0o/incline.nvim)                                  | Floating filename labels on each window with devicon and modified indicator                    |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)             | Live markdown preview in the browser with synchronized scrolling                               |
| [markdown-toc.nvim](https://github.com/hedyhli/markdown-toc.nvim)                    | Generate and update a linked table of contents for markdown files                              |
| [nvim-ansible](https://github.com/mfussenegger/nvim-ansible)                         | Convenience utilities for working with Ansible playbooks and roles                             |
| [nvim-sops](https://github.com/lucidph3nx/nvim-sops)                                 | Encrypt/decrypt files in-editor using Mozilla SOPS                                             |
| [nvim-tmux-navigation](https://github.com/alexghergh/nvim-tmux-navigation)           | Seamless pane navigation between Neovim and tmux                                               |
| [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim)                      | Write and navigate Obsidian vaults from Neovim — notes, daily notes, templates, and wiki links |
| [opencode.nvim](https://github.com/NickvanDyke/opencode.nvim)                        | OpenCode AI assistant integration — editor-aware research, reviews, explanations, and prompts  |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Rich in-buffer markdown rendering — headings, checkboxes, callouts, code blocks, and links     |
| [screenkey.nvim](https://github.com/NStefan002/screenkey.nvim)                       | Displays pressed keys in a floating window (useful for screencasts)                            |
| [snacks.nvim](https://github.com/folke/snacks.nvim)                                  | QoL collection — dashboard, file picker, grep, explorer, git, notifier, indent guides, images  |
| [text-case.nvim](https://github.com/johmsalas/text-case.nvim)                        | Convert text between cases (camel, snake, kebab, etc.) with Telescope integration              |
| [undotree](https://github.com/mbbill/undotree)                                       | Visualize and browse the undo history tree                                                     |
| [veil.nvim](https://github.com/Gentleman-Programming/veil.nvim)                      | Hide secrets in the editor — stream or share your screen with confidence                       |
| [vim-easy-align](https://github.com/junegunn/vim-easy-align)                         | Align text by any character or pattern                                                         |
| [vim-helm](https://github.com/towolf/vim-helm)                                       | Helm chart syntax highlighting and filetype detection                                          |
| [vim-visual-multi](https://github.com/mg979/vim-visual-multi)                        | Multiple cursors and selections                                                                |

> [!NOTE]
> _Almost_ each file in this directory is a plugin spec.<br/>
> `disabled.lua` is not a plugin — it toggles `enabled`/`disabled` for individual plugins.
