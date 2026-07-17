-- https://github.com/alexghergh/nvim-tmux-navigation
-- A Neovim plugin that allows seamless navigation between Neovim and tmux panes.
--
-- Default keybindings:
-- <C-h>      - Navigate left (neovim split or tmux pane)
-- <C-j>      - Navigate down
-- <C-k>      - Navigate up
-- <C-l>      - Navigate right
-- <C-\>      - Navigate to last active pane
-- <C-Space>  - Navigate to next pane numerically

return {
  "alexghergh/nvim-tmux-navigation",
  event = "VeryLazy",
  config = function()
    local nav = require("nvim-tmux-navigation")
    nav.setup({
      disable_when_zoomed = true,
    })
    -- Navigate between Neovim splits and tmux panes seamlessly
    vim.keymap.set("n", "<C-h>", nav.NvimTmuxNavigateLeft, { desc = "Tmux Nav Left" })
    vim.keymap.set("n", "<C-j>", nav.NvimTmuxNavigateDown, { desc = "Tmux Nav Down" })
    vim.keymap.set("n", "<C-k>", nav.NvimTmuxNavigateUp, { desc = "Tmux Nav Up" })
    vim.keymap.set("n", "<C-l>", nav.NvimTmuxNavigateRight, { desc = "Tmux Nav Right" })
    vim.keymap.set("n", "<C-\\>", nav.NvimTmuxNavigateLastActive, { desc = "Tmux Nav Last Active" })
    vim.keymap.set("n", "<C-Space>", nav.NvimTmuxNavigateNext, { desc = "Tmux Nav Next" })
  end,
}
