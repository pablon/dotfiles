-- https://github.com/nvim-telescope/telescope.nvim
-- a highly extendable fuzzy finder over lists
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  require("telescope").setup({
    file_ignore_patterns = { "node_modules" },
  }),
}

-- return {
--   {
--     "nvim-telescope/telescope-ui-select.nvim",
--   },
--   {
--     "nvim-telescope/telescope.nvim",
--     -- tag = "0.1.5",
--     dependencies = { "nvim-lua/plenary.nvim" },
--     config = function()
--       require("telescope").setup({
--         pickers = {
--           find_files = {
--             hidden = true,
--             theme = "ivy",
--             layout_config = { prompt_position = "top" },
--           },
--           live_grep = {
--             hidden = true,
--             -- theme = "ivy",
--             layout_config = { prompt_position = "top" },
--           },
--         },
--         file_ignore_patterns = { "^.git/", "node_modules/" },
--         extensions = {
--           ["ui-select"] = {
--             require("telescope.themes").get_dropdown({}),
--           },
--         },
--       })
--       local builtin = require("telescope.builtin")
--       vim.keymap.set("n", "<C-p>", builtin.find_files, {})
--       vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
--       vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
--
--       require("telescope").load_extension("ui-select")
--     end,
--   },
-- }
