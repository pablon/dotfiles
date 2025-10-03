-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.
-- :help mason.nvim
--
-- https://github.com/neovim/nvim-lspconfig
-- :help vim.lsp.buf
return {
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "dockerls",
          "helm_ls",
          "lua_ls",
          "yamlls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.yamlls.setup({})
    end,
    -- opts = {
    --   servers = {
    --     ansiblels = {},
    --   },
    -- },
  },
  -- keymaps in ../config/keymaps.lua
}
