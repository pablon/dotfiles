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
    --   gcpCredentialsPath = "GOOGLE_APPLICATION_CREDENTIALS",
    --   ageKeyFile = os.getenv("SOPS_AGE_KEY_FILE") or "./key.txt"
    -- },
  },
  keys = {
    { "gSe", vim.cmd.SopsEncrypt, desc = "SOPS encrypt file" },
    { "gSd", vim.cmd.SopsDecrypt, desc = "SOPS decrypt file" },
  },
}
