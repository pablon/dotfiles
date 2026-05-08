vim.diagnostic.enable(false, { bufnr = 0 })
vim.opt_local.wrap = false
vim.opt_local.textwidth = 120
vim.opt_local.formatoptions:append("t")

local function is_prose_line(lnum, lines)
  local line = lines[lnum] or ""
  if line:match("^```") then
    return false
  end
  if line:match("^---$") then
    return false
  end
  if line:match("^|.*|$") then
    return false
  end
  if line:match("^%s*$") then
    return false
  end
  return true
end

local skip_wrap_files = {
  ["AGENTS.md"] = true,
  ["CLAUDE.md"] = true,
  ["SKILL.md"] = true,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    local fname = vim.fn.expand("%:t")
    if skip_wrap_files[fname] then
      return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local total = #lines
    local in_codeblock = false
    local in_frontmatter = false
    local lnum = 1

    if total > 0 and lines[1] == "---" then
      in_frontmatter = true
      lnum = 2
    end

    while lnum <= total do
      local line = lines[lnum] or ""

      if in_frontmatter then
        if line == "---" then
          in_frontmatter = false
        end
        lnum = lnum + 1
      elseif line:match("^```") then
        in_codeblock = not in_codeblock
        lnum = lnum + 1
      elseif in_codeblock then
        lnum = lnum + 1
      elseif not is_prose_line(lnum, lines) then
        lnum = lnum + 1
      else
        vim.cmd(string.format("silent normal! %dGgww", lnum))
        local new_total = vim.api.nvim_buf_line_count(0)
        lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        total = new_total
        lnum = lnum + 1
      end
    end

    pcall(vim.api.nvim_win_set_cursor, 0, cursor)
  end,
})
