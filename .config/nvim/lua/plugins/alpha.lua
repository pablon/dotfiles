-- https://github.com/goolord/alpha-nvim
-- A fast and fully programmable greeter for neovim.
return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.icons",
    "nvim-lua/plenary.nvim",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    local logo = {
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
    }

    local buttons = {
      dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "  Find file", ":silent Telescope find_files hidden=true no_ignore=true <CR>"),
      dashboard.button("g", "  Find text", ":silent Telescope live_grep hidden=true no_ignore=true <CR>"),
      dashboard.button("r", "󰄉  Recent files", ":silent Telescope oldfiles <CR>"),
      dashboard.button("u", "  Update Plugins", "<cmd>Lazy update<CR>"),
      dashboard.button("e", "  Extras", "<cmd>LazyExtras<CR>"),
      dashboard.button("m", "󰺾  Mason", "<cmd>Mason<CR>"),
      dashboard.button("c", "  Configuration", ":silent Neotree $HOME/.config/nvim<CR>"),
      dashboard.button("O", "  Notes", ":silent Neotree $HOME/obsidian-vault<CR>"),
      dashboard.button("p", "  Projects", ":silent Neotree $HOME/projects<CR>"),
      dashboard.button("d", "󱗼  Dotfiles", ":silent Neotree $HOME/dotfiles<CR>"),
      dashboard.button("q", "󰿅  Quit", "<cmd>qa<CR>"),
    }

    local handle = io.popen("fortune -s")
    local fortune = handle:read("*a")
    handle:close()

    dashboard.section.header.val = logo
    dashboard.section.buttons.val = buttons
    dashboard.section.footer.val = fortune

    dashboard.config.opts.noautocmd = true

    alpha.setup(dashboard.opts)
    alpha.setup(dashboard.config)
  end,
}
