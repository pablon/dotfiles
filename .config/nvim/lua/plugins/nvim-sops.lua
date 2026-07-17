-- https://github.com/lucidph3nx/nvim-sops
-- lua plugin for neovim that wraps the SOPS commandline tool
--
-- Default keybindings:
-- gSe - SOPS encrypt current file
-- gSd - SOPS decrypt current file

return {
  "lucidph3nx/nvim-sops",
  opts = {
    enabled = true,
    debug = false,
    binPath = "sops",
  },
  keys = {
    { "gSe", vim.cmd.SopsEncrypt, desc = "SOPS encrypt file" },
    { "gSd", vim.cmd.SopsDecrypt, desc = "SOPS decrypt file" },
  },
}
