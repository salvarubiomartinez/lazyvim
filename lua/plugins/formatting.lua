-- ~/.config/nvim/lua/plugins/formatting.lua
return {
  -- This is the plugin specification for conform.nvim
  "stevearc/conform.nvim",
  -- Make sure it's enabled (should be by default in LazyVim, but good to be explicit)
  enabled = true,
  -- Pass options to the setup function of conform.nvim
  opts = {
    -- You can still have format_on_save for files where you want full file formatting
    format_on_save = function(bufnr)
      -- If the buffer is a C# file, we'll handle it separately, so return false here
      -- Otherwise, let conform handle the full file format
      local filetype = vim.bo[bufnr].filetype
      if filetype == "cs" then
        return false -- We'll handle C# with lsp-format-modifications
      end
      -- For other filetypes, allow conform to format on save
      return true
    end,
    -- Configure formatters per filetype
    formatters_by_ft = {
      -- Set prettier as the formatter for typescript and javascript
      typescript = { "prettier" },
      javascript = { "prettier" },
      typescriptreact = { "prettier" }, -- Also include TSX
      javascriptreact = { "prettier" }, -- Also include JSX
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      -- Add other filetypes you want prettier to format here
    },
    -- You can also configure formatting on save here if you wish
    -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
  },
}
