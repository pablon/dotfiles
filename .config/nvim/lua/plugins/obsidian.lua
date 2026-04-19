-- https://github.com/obsidian-nvim/obsidian.nvim
-- A Neovim plugin for writing and navigating Obsidian vaults, written in Lua.

local function bootstrap_dir(dir)
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end
local vault_path = os.getenv("OBSIDIAN_VAULT_DIR") or "~/obsidian-vault"
local vault_name = vim.fs.basename(vault_path)
vault_path = vim.fn.expand(vault_path)
bootstrap_dir(vault_path)

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  opts = {
    legacy_commands = false,
    notes_subdir = "inbox",
    new_notes_location = "notes_subdir",

    workspaces = {
      {
        name = vault_name,
        path = vault_path,
      },
    },

    link = {
      style = "wiki",
      format = "shortest",
    },

    completion = {
      min_chars = 2,
    },

    -- Alternative: use built-in Zettelkasten IDs instead of date-slug
    -- note_id_func = require("obsidian.builtin").zettel_id,
    note_id_func = function(title)
      if title ~= nil then
        local suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        return tostring(os.date("%Y-%m-%d")) .. "-" .. suffix
      end
      -- Zettelkasten: 8 random uppercase letters (needs math.randomseed above return block)
      -- math.randomseed(os.clock() * 1e6 + os.time())
      -- local suffix = ""
      -- for _ = 1, 8 do
      --   suffix = suffix .. string.char(math.random(65, 90))
      -- end
      -- return tostring(os.date("%Y-%m-%d")) .. "-" .. suffix
      return tostring(os.date("%Y-%m-%d"))
    end,

    frontmatter = {
      func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      sort = { "id", "aliases", "tags" },
    },

    templates = {
      folder = "templates",
      date_format = "YYYY-MM-DD",
      time_format = "HH:mm",
      substitutions = {
        yesterday = function(_ctx, _suffix)
          return os.date("%Y-%m-%d", os.time() - 86400)
        end,
        tomorrow = function(_ctx, _suffix)
          return os.date("%Y-%m-%d", os.time() + 86400)
        end,
      },
    },

    daily_notes = {
      folder = "daily",
      date_format = "YYYY-MM-DD",
      default_tags = { "daily" },
      template = "daily.md",
    },

    ui = {
      enable = false,
    },

    attachments = {
      img_text_func = function(path)
        local name = vim.fs.basename(tostring(path))
        local encoded_name = require("obsidian.util").urlencode(name)
        return string.format("![%s](%s)", name, encoded_name)
      end,
    },
  },
}
