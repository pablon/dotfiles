-- https://github.com/zbirenbaum/copilot.lua
-- pure lua replacement for https://github.com/github/copilot.vim
--
-- Default keybindings (from copilot.lua / copilot-cmp):
-- Tab       - Accept next suggestion (when completion menu not visible)
-- Ctrl+]    - Dismiss suggestion
-- (No custom keybindings configured — auto_trigger handles display)

return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  opts = {
    suggestion = {
      auto_trigger = true,
      hide_during_completion = true,
    },
    filetypes = {
      help = true,
      markdown = true,
      yaml = true,
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
