-- https://github.com/ziontee113/icon-picker.nvim
-- Neovim plugin that helps you pick 𝑨𝕃𝚻 Font Characters, Symbols Σ, Nerd Font Icons  & Emojis ✨

return {
  "ziontee113/icon-picker.nvim",
  dependencies = {
    "stevearc/dressing.nvim",
  },
  config = function()
    require("icon-picker").setup({ disable_legacy_commands = true })

    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>ia", "<cmd>IconPickerNormal alt_font<cr>", { desc = "Icon Picker alt_font" })
    vim.keymap.set("n", "<leader>ic", "<cmd>IconPickerNormal html_colors<cr>", { desc = "Icon Picker html_colors" })
    vim.keymap.set("n", "<leader>ie", "<cmd>IconPickerNormal emoji<cr>", { desc = "Icon Picker emoji" })
    vim.keymap.set("n", "<leader>ii", "<cmd>IconPickerNormal<cr>", { desc = "Icon Picker (all)" })
    vim.keymap.set("n", "<leader>in", "<cmd>IconPickerNormal nerd_font<cr>", { desc = "Icon Picker nerd_font" })
    vim.keymap.set("n", "<leader>is", "<cmd>IconPickerNormal symbols<cr>", { desc = "Icon Picker symbols" })
  end,
}
