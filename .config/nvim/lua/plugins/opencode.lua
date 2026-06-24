-- https://github.com/nickjvandyke/opencode.nvim
-- Integrate the opencode AI assistant with Neovim — streamline editor-aware
-- research, reviews, and requests.

-- config.lua: https://github.com/nickjvandyke/opencode.nvim/blob/main/lua/opencode/config.lua

local opencode_cmd = "opencode --port"

local function opencode_terminal_opts()
  return {
    win = {
      position = "right",
      enter = false,
    },
  }
end

local function show_opencode_terminal()
  local win = require("snacks.terminal").get(opencode_cmd, { create = false })
  if win then
    win:show()
  end
end

return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    {
      "folke/snacks.nvim",
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(picker)
              local items = vim.tbl_map(function(item)
                return item.file
                    and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                  or item.text
              end, picker:selected({ fallback = true }))
              require("opencode").prompt(table.concat(items, ", ") .. " ")
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
        terminal = {},
      },
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = vim.tbl_deep_extend("force", vim.g.opencode_opts or {}, {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, opencode_terminal_opts())
        end,
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = { "OpencodeEvent:tui.command.execute" },
      callback = function(args)
        local event = args.data and args.data.event
        if event and event.properties and event.properties.command == "prompt.submit" then
          show_opencode_terminal()
        end
      end,
    })
  end,
  keys = {
    {
      "<leader>aa",
      function()
        require("snacks.terminal").toggle(opencode_cmd, opencode_terminal_opts())
      end,
      mode = { "n" },
      desc = "Toggle OpenCode",
    },
    {
      "<leader>as",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "OpenCode select",
    },
    {
      "<leader>ai",
      function()
        require("opencode").ask("")
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask",
    },
    {
      "<leader>aI",
      function()
        require("opencode").ask("@this: ")
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask with context",
    },
    {
      "<leader>ab",
      function()
        require("opencode").ask("@buffer ")
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask about buffer",
    },
    {
      "<leader>ap",
      function()
        require("opencode").prompt("@this")
      end,
      mode = { "n", "x" },
      desc = "OpenCode prompt",
    },
    -- Built-in prompts
    {
      "<leader>ape",
      function()
        require("opencode").prompt("explain")
      end,
      mode = { "n", "x" },
      desc = "OpenCode explain",
    },
    {
      "<leader>apf",
      function()
        require("opencode").prompt("fix")
      end,
      mode = { "n", "x" },
      desc = "OpenCode fix",
    },
    {
      "<leader>apd",
      function()
        require("opencode").prompt("diagnose")
      end,
      mode = { "n", "x" },
      desc = "OpenCode diagnose",
    },
    {
      "<leader>apr",
      function()
        require("opencode").prompt("review")
      end,
      mode = { "n", "x" },
      desc = "OpenCode review",
    },
    {
      "<leader>apt",
      function()
        require("opencode").prompt("test")
      end,
      mode = { "n", "x" },
      desc = "OpenCode test",
    },
    {
      "<leader>apo",
      function()
        require("opencode").prompt("optimize")
      end,
      mode = { "n", "x" },
      desc = "OpenCode optimize",
    },
  },
}
