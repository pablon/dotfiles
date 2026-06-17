# Plugins

Neovim plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

| File / Plugin                                                                        | What it does                                                                                  |
| ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------- |
| [bullets.vim](https://github.com/bullets-vim/bullets.vim) (`bullets.lua`)            | Auto-creates bullet points on new lines in markdown and plain text — respects indentation     |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua) (`copilot.lua`)             | Pure Lua GitHub Copilot — auto-trigger suggestions, no telemetry, no Electron                  |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) (`gitsigns.lua`)         | Git decorations in the sign column — inline blame, hunk staging, navigation, and diff previews |
| [goto-preview](https://github.com/rmagatti/goto-preview) (`goto-preview.lua`)       | Floating popup for LSP definitions, declarations, implementations, and type definitions         |
| [vim-helm](https://github.com/towolf/vim-helm) / [helm_ls](https://github.com/mrjones/helm_ls) (`helm.lua`) | Helm syntax highlighting + `helm_ls` LSP with yamlls auto-disabled on Helm files |
| [icon-picker.nvim](https://github.com/ziontee113/icon-picker.nvim) (`icon-picker.lua`) | Fuzzy-find and insert Nerd Font icons, emojis, symbols, and alt fonts                        |
| [incline.nvim](https://github.com/b0o/incline.nvim) (`incline.lua`)                 | Floating filename label on every window with devicon and modified indicator                    |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) (`markdown-preview.lua`) | Live markdown preview in the browser, synchronized scrolling                        |
| [markdown-toc.nvim](https://github.com/hedyhli/markdown-toc.nvim) (`markdown-toc.lua`) | Generate, update, and remove a linked table of contents for markdown files                   |
| [nvim-ansible](https://github.com/mfussenegger/nvim-ansible) (`nvim-ansible.lua`)   | Convenience utilities for Ansible playbooks — filetype detection, quick navigation             |
| [nvim-sops](https://github.com/lucidph3nx/nvim-sops) (`nvim-sops.lua`)              | Encrypt and decrypt Mozilla SOPS secrets without leaving the editor                            |
| [nvim-tmux-navigation](https://github.com/alexghergh/nvim-tmux-navigation) (`vim-tmux-navigation.lua`) | Seamless pane navigation between Neovim and tmux — same `C-h/j/k/l` in both     |
| [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) (`obsidian.lua`)    | Full Obsidian vault workflow from Neovim — notes, daily notes, templates, wiki links, tags     |
| [opencode.nvim](https://github.com/NickvanDyke/opencode.nvim) (`opencode.lua`)      | Agentic AI assistance — research, code reviews, explanations, and inline prompts in-editor     |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) (`render-markdown.lua`) | Rich in-buffer markdown rendering — headings, checkboxes, callouts, code blocks, links |
| [screenkey.nvim](https://github.com/NStefan002/screenkey.nvim) (`screenkey.lua`)    | Shows pressed keys in a floating window — essential for demos and screencasts                  |
| [snacks.nvim](https://github.com/folke/snacks.nvim) (`snacks.lua`)                  | Quality-of-life collection: dashboard, file picker, live grep, explorer, git, notifier, images |
| [text-case.nvim](https://github.com/johmsalas/text-case.nvim) (`text-case.lua`)     | Convert text between any case (camelCase, snake_case, kebab-case, Title Case, etc.)            |
| [undotree](https://github.com/mbbill/undotree) (`undotree.lua`)                     | Visual undo history tree — browse, compare, and restore any previous state                     |
| [veil.nvim](https://github.com/Gentleman-Programming/veil.nvim) (`veil.lua`)        | Hide secrets and sensitive content in the editor — stream and share with confidence            |
| [vim-easy-align](https://github.com/junegunn/vim-easy-align) (`vim-easy-align.lua`) | Align text by any character or pattern — tables, assignments, comments                         |
| [vim-visual-multi](https://github.com/mg979/vim-visual-multi) (`vim-visual-multi.lua`) | Multiple cursors and selections — Sublime-Text-style editing in Vim                          |

> [!NOTE]
> Each file in this directory is a plugin spec. The name in parentheses is the spec filename —
> some differ from the plugin name (e.g. `helm.lua` bundles `vim-helm` + `helm_ls`).<br/>
> `disabled.lua` is not a plugin — it toggles `enabled`/`disabled` for individual specs.
