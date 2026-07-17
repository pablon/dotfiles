-- https://github.com/mbbill/undotree
-- Undotree visualizes the undo history and makes it easy to
-- browse and switch between different undo branches.
--
-- Default keybindings:
-- <leader>U - Toggle undotree

return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>U", "<cmd>UndotreeToggle<CR>", desc = "Undotree Toggle" },
  },
}
