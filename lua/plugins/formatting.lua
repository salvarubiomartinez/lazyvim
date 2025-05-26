-- ~/.config/nvim/lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = {
    -- Remove the entire format_on_save function here.
    -- LazyVim handles this automatically.
    -- format_on_save = function(bufnr)
    --   local filetype = vim.bo[bufnr].filetype
    --   if filetype == "cs" then
    --     return false
    --   end
    --   return true
    -- end,
    formatters_by_ft = {
      typescript = { "prettier" },
      javascript = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    -- Other conform options...
  },
}
