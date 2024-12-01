-- vim.api.nvim_create_autocmd("BufRead", {
--   group = vim.api.nvim_create_augroup("detect_gitconfig", { clear = true }),
--   desc = "Set filetype for gitconfig-* files",
--   pattern = { "**/.gitconfig*" },
--   callback = function()
--     vim.cmd("set filetype=gitconfig")
--   end,
-- })

vim.filetype.add({
  pattern = {
    ["**/.gitconfig*"] = "gitconfig",
  },
})
