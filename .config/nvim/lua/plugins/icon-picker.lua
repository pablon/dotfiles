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

    vim.keymap.set({ "n", "v" }, "<C-i>", "<cmd>IconPickerNormal<cr>", opts)
    vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
  end,
}
