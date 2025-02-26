-- https://github.com/MeanderingProgrammer/render-markdown.nvim
-- Plugin to improve viewing Markdown files in Neovim
return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    heading = {
      enabled = true,
      preset = "obsidian",
      sign = true,
      position = "overlay",
      -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " }, -- rounded
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " }, -- squared
      signs = { "󰫎 " },
      width = "block", -- block, full
      left_margin = 0,
      left_pad = 0,
      right_pad = 4,
      min_width = 80,
      border = false,
      border_virtual = false,
      border_prefix = false,
      above = "▄",
      below = "▀",
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },
    bullet = {
      enabled = true,
      highlight = "RenderMarkdownBullet",
      left_pad = 2,
      render_modes = false,
      position = "overlay",
    },
    callout = {
      bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
      note = { raw = "[!NOTE]", rendered = " Note", highlight = "RenderMarkdownInfo" },
      info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
      todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownTodo" },
      success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
      check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
      done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
      error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
      danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
      important = { raw = "[!IMPORTANT]", rendered = " Important", highlight = "RenderMarkdownHint" },
      fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
      failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
      missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰀪 Caution", highlight = "RenderMarkdownError" },
      attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
      question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
      help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
      faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
      example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
      summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
      abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
      tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
      quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
      cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
      -- match custom callouts from .obsidian/snippets/custom.css
      --
      -- .callout[data-callout="coffee"] {
      --   --callout-color: 249, 231, 159;
      --   --callout-icon: "coffee";
      -- }
      coffee = { raw = "[!COFFEE]", rendered = "󰛊 Coffee", highlight = "RenderMarkdownInlineHighlight" },
      -- .callout[data-callout="decision"] {
      --   --callout-color: 219, 51, 247;
      --   --callout-icon: "swords";
      -- }
      decision = { raw = "[!DECISION]", rendered = "󰞇 Decision", highlight = "RenderMarkdownBullet" },
      -- .callout[data-callout="pass"],
      -- .callout[data-callout="password"] {
      --   --callout-color: 228, 110, 106;
      --   --callout-icon: "key-round";
      -- }
      pass = { raw = "[!PASS]", rendered = " Pass", highlight = "RenderMarkdownWarn" },
      password = { raw = "[!PASSWORD]", rendered = " Password", highlight = "RenderMarkdownWarn" },
      -- .callout[data-callout="auth"],
      -- .callout[data-callout="login"],
      -- .callout[data-callout="secret"] {
      --   --callout-color: 255, 150, 108;
      --   --callout-icon: "book-lock";
      -- }
      auth = { raw = "[!ACCESS]", rendered = " Access", highlight = "RenderMarkdownWarn" },
      login = { raw = "[!LOGIN]", rendered = "󱚏 Login", highlight = "RenderMarkdownError" },
      secret = { raw = "[!SECRET]", rendered = "󱚏 Secret", highlight = "RenderMarkdownError" },
      -- .callout[data-callout="user"],
      -- .callout[data-callout="me"] {
      --   --callout-color: 165, 105, 189;
      --   --callout-icon: "user";
      -- }
      user = { raw = "[!USER]", rendered = " User", highlight = "RenderMarkdownH5" },
      me = { raw = "[!ME]", rendered = " User", highlight = "RenderMarkdownH5" },
    },
    checkbox = {
      enabled = true,
      left_pad = 2,
      position = "overlay",
      unchecked = { icon = "󰄱", highlight = "RenderMarkdownUnchecked", scope_highlight = nil },
      checked = { icon = "󰱒", highlight = "RenderMarkdownChecked", scope_highlight = "@markup.strikethrough" },
      custom = {
        bookmark = { raw = "[b]", rendered = "", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        canceled = {
          raw = "[-]",
          rendered = "󰜺",
          highlight = "RenderMarkdownError",
          scope_highlight = "@markup.strikethrough",
        },
        fire = { raw = "[f]", rendered = "󰈸", highlight = "RenderMarkdownError", scope_highlight = nil },
        forwarded = { raw = "[>]", rendered = "", highlight = "RenderMarkdownHint", scope_highlight = nil },
        important = { raw = "[!]", rendered = "", highlight = "DiagnosticWarn" },
        incomplete = { raw = "[/]", rendered = "◧", highlight = "RenderMarkdownChecked", scope_highlight = nil },
        info = { raw = "[i]", rendered = "󰋼", highlight = "RenderMarkdownInfo", scope_highlight = nil },
        key = { raw = "[k]", rendered = "", highlight = "DiagnosticWarn", scope_highlight = nil },
        location = { raw = "[l]", rendered = "", highlight = "RenderMarkdownError", scope_highlight = nil },
        pr_draft = { raw = "[D]", rendered = "", highlight = "DiagnosticWarn", scope_highlight = nil },
        pr_merged = { raw = "[M]", rendered = "", highlight = "RenderMarkdownSuccess", scope_highlight = nil },
        pr_open = { raw = "[P]", rendered = "", highlight = "RenderMarkdownTodo", scope_highlight = nil },
        question = { raw = "[?]", rendered = "", highlight = "DiagnosticWarn", scope_highlight = nil },
        quote1 = { raw = '["]', rendered = "", highlight = "RenderMarkdownInfo", scope_highlight = nil },
        quote2 = { raw = "[q]", rendered = "", highlight = "RenderMarkdownInfo", scope_highlight = nil },
        savings = { raw = "[s]", rendered = "$", highlight = "RenderMarkdownSuccess", scope_highlight = nil },
        scheduling = { raw = "[<]", rendered = "", highlight = "RenderMarkdownHint", scope_highlight = nil },
        star = { raw = "[*]", rendered = "⭑", highlight = "DiagnosticWarn", scope_highlight = nil },
      },
    },
    link = {
      custom = {
        go = { pattern = "%.go$", icon = " " },
        jinja = { pattern = "%.j2$", icon = " " },
        markdown = { pattern = "%.md$", icon = " " },
        perl = { pattern = "%.pl$", icon = " " },
        python = { pattern = "%.py$", icon = "󰌠 " },
        ruby = { pattern = "%.rb$", icon = " " },
        shell = { pattern = "%.sh$", icon = " " },
        yaml = { pattern = "%.yaml$", icon = " " },
        yml = { pattern = "%.yml$", icon = " " },
      },
    },
    code = {
      border = "thin",
      highlight = "RenderMarkdownCode",
      highlight_inline = "RenderMarkdownCodeInline",
      highlight_language = nil,
      language_name = true,
      language_pad = 0,
      min_width = 40,
      left_pad = 0,
      right_pad = 2,
      sign = true,
      style = "full",
      width = "block",
    },
    html = {
      enabled = true,
      comment = {
        conceal = false,
      },
    },
    dash = {
      enabled = true,
      highlight = "RenderMarkdownDash",
      icon = "",
      width = 80,
    },
  },
}
