-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- browse the file system and other tree like structures
return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".DS_Store",
          -- ".localized",
          -- "thumbs.db",
        },
        never_show = {
          ".git",
          ".ansible",
        },
      },
    },
  },
}
