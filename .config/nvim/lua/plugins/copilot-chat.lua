-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
-- a Neovim plugin that brings GitHub Copilot Chat capabilities directly into your editor.
--
-- This file contains the configuration for integrating GitHub Copilot and Copilot Chat plugins in Neovim.

-- Constants for better maintainability
local HEADERS = {
  user = " You",
  copilot = "  Copilot ",
  error = "✘ Error ",
}

-- This table contains various prompts that can be used to interact with Copilot.
local prompts = {
  Explain = {
    prompt = "Please explain how the following code works.", -- Prompt to explain code
    system_prompt = "COPILOT_EXPLAIN",
  },
  Review = {
    prompt = "Please review the following code and provide suggestions for improvements.", -- Prompt to review code
    system_prompt = "COPILOT_REVIEW",
  },
  Tests = "Please explain how the selected code works, then generate unit tests for it.", -- Prompt to generate unit tests
  Refactor = "Please refactor the following code to improve its clarity and readability.", -- Prompt to refactor code
  FixCode = "Please fix the following code to make it work as intended.", -- Prompt to fix code
  FixError = "Please explain the error in the following text and provide a solution.", -- Prompt to fix errors
  BetterNamings = "Please provide better names for the following variables and functions.", -- Prompt to suggest better names
  Documentation = "Please provide documentation for the following code.", -- Prompt to generate documentation
  DocumentationMarkdown = "Please provide documentation for the following code using Markdown format. Save it as README.md", -- Prompt to generate Markdown documentation
  DocumentationAsciiDoc = "Please provide documentation for the following code using AsciiDoc format. Save it as README.adoc", -- Prompt to generate AsciiDoc documentation
  CreateAPost = "Please provide documentation for the following code to post it in social media, like Linkedin, it has to be deep, must have a catchy header, must be well explained and easy to understand. Also do it in a fun and engaging way. Finish with a short satirical or empowering epigram.", -- Prompt to create a social media post
  Summarize = "Please summarize the following text.", -- Prompt to summarize text
  Spelling = "Please correct any grammar and spelling errors in the following text.", -- Prompt to correct spelling and grammar
  Wording = "Please improve the grammar and wording of the following text.", -- Prompt to improve wording
  Concise = "Please rewrite the following text to make it more concise.", -- Prompt to make text concise
}

-- Copilot Chat plugin configuration
return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    prompts = prompts,
    model = "claude-sonnet-4",
    agent = "copilot",
    context = { "buffer", "git:staged" },
    question_header = HEADERS.user,
    answer_header = HEADERS.copilot,
    error_header = HEADERS.error,
    separator = "───",
    window = {
      layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
    },
  },
}
