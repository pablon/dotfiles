-- https://github.com/carderne/pi-nvim
--
-- Bridge between pi coding agent and Neovim. Run pi in one terminal pane and Neovim in another —
-- send files, selections, and prompts from Neovim directly into your running pi session.
--
-- Keybindings:
--
--   <leader>aa  :Pi                  Open the Send to pi dialog (normal + visual mode)
--   <leader>ap  :PiSend<CR>          Type a prompt and send to pi (normal mode)
--   <leader>af  :PiSendFile<CR>      Send current file path + prompt (normal mode)
--   <leader>as  :PiSendSelection<CR> Send visual selection + prompt (visual mode)
--   <leader>ab  :PiSendBuffer<CR>    Send entire buffer + prompt (normal mode)
--   <leader>ai  :PiPing<CR>          Check if pi is reachable (normal mode)
--
-- Available commands:
--
--   :Pi              Open the Send to pi dialog
--   :PiSend          Type a prompt and send to pi
--   :PiSendFile      Send current file path + prompt
--   :PiSendSelection Send visual selection + prompt
--   :PiSendBuffer    Send entire buffer + prompt
--   :PiPing          Check if pi is reachable
--   :PiSessions      List/switch between running pi sessions

return {
  "carderne/pi-nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    set_default_keymaps = false,
  },
  keys = {
    { "<leader>aa", "<cmd>Pi<CR>", mode = { "n", "x" }, desc = "Pi: Send" },
    { "<leader>ap", "<cmd>PiSend<CR>", mode = "n", desc = "Pi: send prompt" },
    { "<leader>af", "<cmd>PiSendFile<CR>", mode = "n", desc = "Pi: Send current file" },
    { "<leader>as", "<cmd>PiSendSelection<CR>", mode = { "n", "x" }, desc = "Pi: Send selection" },
    { "<leader>ab", "<cmd>PiSendBuffer<CR>", mode = "n", desc = "Pi: Send buffer" },
    { "<leader>ai", "<cmd>PiPing<CR>", mode = "n", desc = "Pi: Ping" },
  },
}
