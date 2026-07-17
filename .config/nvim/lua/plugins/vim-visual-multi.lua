-- https://github.com/mg979/vim-visual-multi
-- Brings multiple cursors/selections

return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  -- Default keybindings (built-in by the plugin, no setup needed):
  -- <C-n>       - Start multiple cursors / add next occurrence
  -- <C-down>    - Create cursors vertically downward
  -- <C-up>      - Create cursors vertically upward
  -- n / N       - Select next/previous occurrence
  -- [ / ]       - Jump to previous/next cursor
  -- q           - Skip current occurrence and select next
  -- Q           - Remove current cursor/selection
  -- Tab         - Toggle between cursor mode and extend mode
  -- i / a       - Enter insert mode before/after cursor
  -- I / A       - Enter insert mode at start/end of line
  -- s           - Substitute text in all cursors
  -- \\\\          - Toggle highlight of current word under cursor
}
