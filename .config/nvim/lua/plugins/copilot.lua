-- https://github.com/zbirenbaum/copilot.lua
-- pure lua replacement for https://github.com/github/copilot.vim
return {
  "zbirenbaum/copilot.lua",
  -- optional = true,
  opts = {
    suggestion = {
      auto_trigger = true,
      hide_during_completion = vim.g.ai_cmp,
    },
    filetypes = {
      filetypes = {
        help = true,
        markdown = true,
        yaml = true,
      },
    },
    server_opts_overrides = {
      settings = {
        telemetry = {
          telemetryLevel = "off",
        },
      },
    },
  },
}
