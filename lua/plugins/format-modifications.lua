-- ~/.config/nvim/lua/plugins/format-modifications.lua
return {
  {
    "joechrisellis/lsp-format-modifications.nvim",
    -- Load this plugin when a C# file is opened
    ft = "cs",
    config = function()
      require("lsp-format-modifications").setup({
        -- Attach a custom on_attach function to handle formatting on save for C#
        on_attach = function(client, bufnr)
          -- Ensure the LSP client supports range formatting
          if client.server_capabilities.documentRangeFormattingProvider then
            -- Check if the current buffer is a C# file
            local filetype = vim.bo[bufnr].filetype
            if filetype == "cs" then
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("LspCsFormatModifications", { clear = true }),
                buffer = bufnr,
                callback = function()
                  -- Ensure the LSP client is still attached and valid
                  if client.attached_buffers[bufnr] then
                    require("lsp-format-modifications").format_modifications(client, bufnr)
                  end
                end,
                desc = "Format C# modified lines on save",
              })
            end
          end
        end,
        -- You can add other global options here if needed, but the on_attach handles filetype specificity
      })

      -- Optional: Create a user command to manually format C# modifications
      vim.api.nvim_create_user_command("FormatCsModifications", function()
        -- Ensure we are in a C# buffer
        if vim.bo[0].filetype ~= "cs" then
          vim.notify("This command is for C# files only.", vim.log.levels.WARN)
          return
        end

        local clients = vim.lsp.get_clients()
        local cs_client = nil
        for _, client in ipairs(clients) do
          -- You might want to be more specific here, e.g., check client.name for "omnisharp"
          if client.server_capabilities.documentRangeFormattingProvider then
            cs_client = client
            break
          end
        end

        if cs_client then
          require("lsp-format-modifications").format_modifications(cs_client, 0)
        else
          vim.notify("No LSP client with range formatting attached to this C# buffer.", vim.log.levels.WARN)
        end
      end, { desc = "Format only modified lines for C# files" })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "lewis6991/gitsigns.nvim",
    },
  },
}
