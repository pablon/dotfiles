-- https://github.com/lucidph3nx/nvim-sops
-- lua plugin for neovim that wraps the SOPS commandline tool
return {
  "lucidph3nx/nvim-sops",
  event = { "BufEnter" },
  opts = {
    enabled = true,
    debug = false,
    binPath = "sops", -- assumes its on $PATH
    -- defaults = { -- overriding any env vars as needed
    --   awsProfile = "AWS_PROFILE",
    --   ageKeyFile = "SOPS_AGE_KEY_FILE",
    --   gcpCredentialsPath = "GOOGLE_APPLICATION_CREDENTIALS",
    -- },
  },
  keys = {
    { "<leader>se", vim.cmd.SopsEncrypt, desc = "[S]OPS [e]ncrypt file" },
    { "<leader>sE", vim.cmd.SopsDecrypt, desc = "[S]OPS d[E]crypt file" },
  },
}
