-- https://github.com/rmagatti/goto-preview
-- Provides preview functionality for definitions, declarations,
-- implementations, type definitions, and references.
--
-- Default keybindings:
-- gpd - Preview definition
-- gpt - Preview type definition
-- gpi - Preview implementation
-- gpD - Preview declaration
-- gP  - Close all preview windows
-- gpr - Preview references

return {
  "rmagatti/goto-preview",
  event = "LspAttach",
  opts = {
    default_mappings = false, -- We define our own below
  },
  keys = {
    { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview Definition" },
    { "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", desc = "Preview Type Definition" },
    { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Preview Implementation" },
    { "gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", desc = "Preview Declaration" },
    { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close All Previews" },
    { "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "Preview References" },
  },
}
