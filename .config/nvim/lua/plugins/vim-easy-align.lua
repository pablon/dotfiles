-- https://github.com/junegunn/vim-easy-align
-- A simple, easy-to-use Vim alignment plugin
--
-- Default keybindings:
-- <leader>al - Start interactive EasyAlign (normal/visual mode)
--   Then enter alignment delimiter (e.g. =, :, \\, etc.)

return {
  "junegunn/vim-easy-align",
  keys = {
    { "<leader>al", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Start EasyAlign" },
  },
}
