-- https://github.com/lukas-reineke/virt-column.nvim
-- Plugin that shows the vertical bar or vertical column
return {
  "lukas-reineke/virt-column.nvim",
  ft = { "markdown" },
  opts = {
    -- char = "|",
    -- char = "",
    -- char = "┇",
    -- char = "∶",
    -- char = "∷",
    char = "║",
    -- char = "⋮",
    -- char = "",
    -- char = "󰮾",
    virtcolumn = "80",
  },
}
