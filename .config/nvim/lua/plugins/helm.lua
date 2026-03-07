-- Description: Helm support with helm-ls language server
-- Author: https://github.com/pablon

return {
  -- vim-helm for syntax highlighting
  { "towolf/vim-helm", ft = "helm" },

  -- helm-ls configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        helm_ls = {},
      },
      setup = {
        -- Disable yamlls for helm files to avoid template syntax errors
        yamlls = function()
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "yamlls" then
                if vim.bo[args.buf].filetype == "helm" then
                  vim.schedule(function()
                    vim.cmd("LspStop ++force yamlls")
                  end)
                end
              end
            end,
          })
        end,
      },
    },
  },
}
