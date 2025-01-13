-- https://tree-sitter.github.io/tree-sitter
-- Tree-sitter is a parser generator tool and an incremental parsing library.
-- It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.
--
-- https://github.com/nvim-treesitter/nvim-treesitter
-- provides a simple and easy way to use the interface for tree-sitter in
-- Neovim and and some basic functionality such as highlighting based on it
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "go",
        "gotmpl",
        "hcl",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "terraform",
        "toml",
        "vim",
        "yaml",
      },
      highlight = {
        enable = true,
      },
    },
  },
}
