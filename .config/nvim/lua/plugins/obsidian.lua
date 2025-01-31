-- https://github.com/epwalsh/obsidian.nvim
-- A Neovim plugin for writing and navigating Obsidian vaults, written in Lua.
return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,
  ft = "markdown",
  requires = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    notes_subdir = "new",
    new_notes_location = "notes_subdir",

    workspaces = {
      {
        name = "obsidian-vault",
        path = "~/obsidian-vault",
      },
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format:
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        -- else
        --   -- If title is nil, just add 4 random uppercase letters to the suffix.
        --   for _ = 1, 4 do
        --     suffix = suffix .. string.char(math.random(65, 90))
        --   end
        return tostring(os.date("%Y-%m-%d")) .. "-" .. suffix
      else
        return tostring(os.date("%Y-%m-%d"))
      end
    end,

    note_frontmatter_func = function(note)
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,

    mappings = {},

    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      tags = "",
      substitutions = {
        yesterday = function()
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
        tomorrow = function()
          return os.date("%Y-%m-%d", os.time() + 86400)
        end,
      },
    },

    daily_notes = {
      folder = "101-Daily",
      date_format = "%Y-%m-%d",
      default_tags = { "daily" },
      template = "daily.md",
    },

    ui = {
      enable = false, -- using render-markdown.nvim instead
    },
  },
}
