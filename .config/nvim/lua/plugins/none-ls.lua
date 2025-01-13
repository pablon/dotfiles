-- https://github.com/nvimtools/none-ls.nvim
-- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- code_actions
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.code_actions.textlint,
        -- completion
        null_ls.builtins.completion.luasnip,
        null_ls.builtins.completion.nvim_snippets,
        null_ls.builtins.completion.spell,
        -- diagnostics
        null_ls.builtins.diagnostics.ansiblelint,
        null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.commitlint,
        null_ls.builtins.diagnostics.dotenv_linter,
        null_ls.builtins.diagnostics.erb_lint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.yamllint,
        -- formatting
        null_ls.builtins.formatting.biome,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.stylua,
      },
    })
    -- keymaps in ../config/keymaps.lua
  end,
}
