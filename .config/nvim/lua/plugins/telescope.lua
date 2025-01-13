-- https://github.com/nvim-telescope/telescope.nvim
-- a highly extendable fuzzy finder over lists
--
-- https://github.com/nvim-lua/plenary.nvim
-- All the lua functions I don't want to write twice.
--
-- https://github.com/nvim-telescope/telescope-symbols.nvim
-- provide users the ability of picking symbols and insert them at point
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "andrew-george/telescope-themes",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      -- keymaps in ../config/keymaps.lua
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("themes")
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            hidden = true,
            theme = "ivy",
            layout_config = { prompt_position = "top" },
          },
          live_grep = {
            hidden = true,
            theme = "ivy",
            layout_config = { prompt_position = "top" },
          },
        },
        file_ignore_patterns = { "^.git/", "node_modules/" },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
