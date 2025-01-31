-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.
-- :help mason.nvim
--
-- https://github.com/neovim/nvim-lspconfig
-- :help vim.lsp.buf
return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- "ansiblels",
          "docker_compose_language_service",
          "dockerls",
          "gitlab_ci_ls",
          "helm_ls",
          "lua_ls",
          "ruff",
          -- "sqlls",
          -- "terraformls",
          -- "tflint",
          "yamlls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      -- lspconfig.ansiblels.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.yamlls.setup({})
    end,
  },
  -- keymaps in ../config/keymaps.lua
}
