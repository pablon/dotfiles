-- https://github.com/goolord/alpha-nvim
-- A fast and fully programmable greeter for neovim.
return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
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

    local handle = io.popen("fortune -s")
    local fortune = handle:read("*a")
    handle:close()

    dashboard.section.header.val = logo
    dashboard.section.footer.val = fortune
    dashboard.config.opts.noautocmd = true

    alpha.setup(dashboard.opts)
    alpha.setup(dashboard.config)
  end,
}
