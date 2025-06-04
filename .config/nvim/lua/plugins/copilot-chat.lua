-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
-- a Neovim plugin that brings GitHub Copilot Chat capabilities directly into your editor.
--
-- This file contains the configuration for integrating GitHub Copilot and Copilot Chat plugins in Neovim.

-- Define prompts for Copilot
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
  DocumentationMarkdown = "Please provide documentation for the following code using Markdown format. Save it as README-new.md", -- Prompt to generate Markdown documentation
  DocumentationAsciiDoc = "Please provide documentation for the following code using AsciiDoc format. Save it as README-new.adoc", -- Prompt to generate AsciiDoc documentation
  CreateAPost = "Please provide documentation for the following code to post it in social media, like Linkedin, it has to be deep, must have a catchy header, must be well explained and easy to understand. Also do it in a fun and engaging way. Finish with a short satirical or empowering epigram.", -- Prompt to create a social media post
  Summarize = "Please summarize the following text.", -- Prompt to summarize text
  Spelling = "Please correct any grammar and spelling errors in the following text.", -- Prompt to correct spelling and grammar
  Wording = "Please improve the grammar and wording of the following text.", -- Prompt to improve wording
  Concise = "Please rewrite the following text to make it more concise.", -- Prompt to make text concise
}

-- Define user name
local user_name = os.getenv("USER") or "User"

-- Copilot Chat plugin configuration
-- This table contains the configuration for various plugins used in Neovim.
return {
  "CopilotC-Nvim/CopilotChat.nvim", -- Load the Copilot Chat plugin
  opts = {
    prompts = prompts,
    -- System prompt to use (can be specified manually in prompt via /).
    system_prompt = os.getenv("SYSTEM_PROMPT")
      or "You are an expert DevOps engineer specialized in cloud services, infrastructure as code, containers, helm, helmfile and kubernetes. You have a technical yet practical approach, with clear and applicable explanations, always providing useful examples for intermediate and advanced DevOps professionals. You speak with a professional yet approachable tone, relaxed, and with a bit of clever humor. You avoid excessive formalities and use direct language, but technical when required.",
    model = "gpt-4o", -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
    agent = "copilot", -- Default agent to use, see ':CopilotChatAgents' for available agents (can be specified manually in prompt via @).
    context = { "buffer", "git:staged" }, -- Default context or array of contexts to use (can be specified manually in prompt via #).
    question_header = " " .. user_name .. " ", -- Header to use for user questions
    answer_header = " Copilot ", -- Header to use for AI answers
    error_header = "✘ Error ", -- Header to use for errors
    separator = "───", -- Separator to use in chat
    window = {
      layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
    },
  },
}
