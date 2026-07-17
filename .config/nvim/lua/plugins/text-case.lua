-- https://github.com/johmsalas/text-case.nvim
-- all in one plugin for converting text case
--
-- Default keybindings:
-- ga            - Invocation prefix for text-case operations
-- ga.           - Open telescope text-case picker
-- <leader>rlt   - Convert current word to Title Case

return {
  "johmsalas/text-case.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("textcase").setup({})
    require("telescope").load_extension("textcase")
  end,
  keys = {
    "ga", -- Default invocation prefix
    { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    { "<leader>rlt", function() require("textcase").current_word("to_title_case") end, desc = "Current word to Title Case" },
  },
  cmd = {
    -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
    "Subs",
    "TextCaseOpenTelescope",
    "TextCaseOpenTelescopeQuickChange",
    "TextCaseOpenTelescopeLSPChange",
    "TextCaseStartReplacingCommand",
  },
}
