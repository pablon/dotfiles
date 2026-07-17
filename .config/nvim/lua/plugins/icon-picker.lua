-- https://github.com/ziontee113/icon-picker.nvim
-- Neovim plugin that helps you pick 𝑨𝕃𝚻 Font Characters, Symbols Σ, Nerd Font Icons  & Emojis ✨
--
-- Default keybindings:
-- <leader>ia - Alt font picker
-- <leader>ic - HTML color picker
-- <leader>ie - Emoji picker
-- <leader>ii - Icon picker (all categories)
-- <leader>in - Nerd font picker
-- <leader>is - Symbol picker

return {
  "ziontee113/icon-picker.nvim",
  dependencies = { "stevearc/dressing.nvim" },
  cmd = { "IconPickerNormal", "IconPickerInsert", "IconPickerYank" },
  keys = {
    { "<leader>ia", "<cmd>IconPickerNormal alt_font<cr>", desc = "Icon Picker alt_font" },
    { "<leader>ic", "<cmd>IconPickerNormal html_colors<cr>", desc = "Icon Picker html_colors" },
    { "<leader>ie", "<cmd>IconPickerNormal emoji<cr>", desc = "Icon Picker emoji" },
    { "<leader>ii", "<cmd>IconPickerNormal<cr>", desc = "Icon Picker (all)" },
    { "<leader>in", "<cmd>IconPickerNormal nerd_font<cr>", desc = "Icon Picker nerd_font" },
    { "<leader>is", "<cmd>IconPickerNormal symbols<cr>", desc = "Icon Picker symbols" },
  },
  opts = { disable_legacy_commands = true },
}
