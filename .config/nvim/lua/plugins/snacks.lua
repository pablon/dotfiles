-- https://github.com/folke/snacks.nvim
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
    explorer = {},
    picker = {
      enabled = true,
      ui_select = false,
      sources = {
        files = {
          hidden = true,
          ignored = true,
          exclude = {
            ".ansible*",
            ".git",
            "node_modules",
          },
        },
        grep = {
          hidden = true,
          ignored = true,
          regex = false,
          args = { "--ignore-case" },
          exclude = {
            ".ansible*",
            ".git",
            "node_modules",
          },
        },
        explorer = {
          cycle = true,
          auto_close = false,
          jump = { close = true },
          layout = { preview = "main" },
          hidden = true,
          ignored = true,
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    image = {
      img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments", ".media", "_media" },
      resolve = function(file, src)
        local ok, api = pcall(require, "obsidian.api")
        if not ok then
          return nil
        end
        if api.path_is_note(file) then
          return api.resolve_attachment_path(src)
        end
      end,
    },
    gh = {
      enabled = true,
    },
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
