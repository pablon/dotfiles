-- https://github.com/zbirenbaum/copilot.lua
-- pure lua replacement for https://github.com/github/copilot.vim
return {
  "zbirenbaum/copilot.lua",
  optional = true,
  opts = {
    filetypes = {
      filetypes = {
        yaml = true,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    },
  },
}
