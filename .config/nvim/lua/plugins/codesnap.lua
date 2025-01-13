-- https://github.com/mistricky/codesnap.nvim
-- Snapshot plugin with rich features that can make pretty code snapshots for Neovim
-- 󰋼 https://github.com/mistricky/codesnap.nvim#compile-from-source
return {
  "mistricky/codesnap.nvim",
  build = "make",
  keys = {
    { "<leader>cx", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Desktop" },
    { "<leader>cX", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
  },
  opts = {
    -- bg_theme = "bamboo",
    bg_color = "#535c68",
    bg_padding = 0,
    bg_x_padding = 10,
    bg_y_padding = 10,
    code_font_family = "JetBrainsMono Nerd Font",
    has_breadcrumbs = false,
    has_line_number = false,
    mac_window_bar = true,
    save_path = "~/Desktop",
    watermark = "",
  },
}
