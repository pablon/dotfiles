-- https://github.com/folke/snacks.nvim
--
-- A collection of small QoL plugins for Neovim.

return {
  "folke/snacks.nvim",
  dependencies = {
    "nvim-mini/mini.icons",
  },
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
        ]],
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    git = { enabled = true },
    explorer = {
      cycle = true,
      auto_close = true,
      jump = { close = true },
      layout = { preview = "main" },
    },
    picker = {
      enabled = true,
      hidden = true,
      ignored = true,
      ui_select = false,
      exclude = {
        ".ansible*",
        ".git",
        "node_modules",
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Log (cwd)",
    },
    {
      "<leader><leader>",
      function()
        Snacks.picker.pick("files")
      end,
      desc = "Find Files",
    },
    {
      "<leader>R",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep Files",
    },
    {
      "<C-n>",
      function()
        Snacks.explorer({ auto_close = true })
      end,
      desc = "Explorer",
    },
  },
}
