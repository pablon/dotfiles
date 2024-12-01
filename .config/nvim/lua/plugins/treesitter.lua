-- https://github.com/nvim-treesitter/nvim-treesitter
-- provides a simple and easy way to use the interface for tree-sitter in
-- Neovim and and some basic functionality such as highlighting based on it
return {
  "nvim-treesitter/nvim-treesitter",
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
  },
}
