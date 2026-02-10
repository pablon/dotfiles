-- https://github.com/NickvanDyke/opencode.nvim
-- Integrate the opencode AI assistant with Neovim — streamline editor-aware
-- research, reviews, and requests.

-- config.lua: https://github.com/NickvanDyke/opencode.nvim/blob/main/lua/opencode/config.lua

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  keys = {
    {
      "<leader>aa",
      function()
        require("opencode").toggle()
      end,
      mode = { "n" },
      desc = "Toggle OpenCode",
    },
    {
      "<leader>as",
      function()
        require("opencode").select({ submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode select",
    },
    {
      "<leader>ai",
      function()
        require("opencode").ask("", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask",
    },
    {
      "<leader>aI",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask with context",
    },
    {
      "<leader>ab",
      function()
        require("opencode").ask("@file ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask about buffer",
    },
    {
      "<leader>ap",
      function()
        require("opencode").prompt("@this", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode prompt",
    },
    -- Built-in prompts
    {
      "<leader>ape",
      function()
        require("opencode").prompt("explain", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode explain",
    },
    {
      "<leader>apf",
      function()
        require("opencode").prompt("fix", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode fix",
    },
    {
      "<leader>apd",
      function()
        require("opencode").prompt("diagnose", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode diagnose",
    },
    {
      "<leader>apr",
      function()
        require("opencode").prompt("review", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode review",
    },
    {
      "<leader>apt",
      function()
        require("opencode").prompt("test", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode test",
    },
    {
      "<leader>apo",
      function()
        require("opencode").prompt("optimize", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode optimize",
    },
  },
  config = function()
    -- Use tmux provider inside tmux, otherwise fallback to snacks
    local provider = vim.env.TMUX and "tmux" or "snacks"
    vim.g.opencode_opts = {
      provider = {
        enabled = provider,
        tmux = {
          win = {
            enter = true,
          },
          focus = true,
          allow_passthrough = false,
        },
        snacks = {
          auto_close = true, -- Close the terminal when `opencode` exits
          win = {
            enter = true,
            bo = {
              -- Make it easier to target for customization, and prevent possibly unintended `"snacks_terminal"` targeting.
              -- e.g. the recommended edgy.nvim integration puts all `"snacks_terminal"` windows at the bottom.
              filetype = "opencode_terminal",
            },
          },
          focus = true,
        },
      },
    }
    vim.o.autoread = true
  end,
}
