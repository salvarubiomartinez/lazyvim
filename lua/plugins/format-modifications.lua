-- ~/.config/nvim/lua/plugins/format-modifications.lua
return {
  {
    "joechrisellis/lsp-format-modifications.nvim",
    ft = "cs", -- Only load for C# files when a .cs file is opened
    -- Use the 'opts' table to pass configuration to the plugin's setup function.
    -- This ensures setup() is called *after* the plugin is loaded.
    opts = {
      on_attach = function(client, bufnr)
        if client.server_capabilities.documentRangeFormattingProvider then
          local filetype = vim.bo[bufnr].filetype
          if filetype == "cs" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspCsFormatModifications", { clear = true }),
              buffer = bufnr,
              callback = function()
                if client.attached_buffers[bufnr] then
                  require("lsp-format-modifications").format_modifications(client, bufnr)
                end
              end,
              desc = "Format C# modified lines on save",
            })
          end
        else
          vim.notify("No LSP client with range formatting attached to this C# buffer.", vim.log.levels.WARN)
        end
      end,
      -- You can add other global options here if needed
    },
    -- Ensure dependencies are loaded
    dependencies = {
      "nvim-lua/plenary.nvim",
      "lewis6991/gitsigns.nvim",
    },
  },

  -- IMPORTANT: The User Command needs to be defined outside the plugin's 'opts' or 'config'
  -- if the plugin is loaded lazily with 'ft' or 'event'.
  -- This is because the command should be available even before the plugin itself is loaded.
  -- You can wrap it in a separate empty spec or put it directly in a config file loaded on startup.
  -- For simplicity, let's put it in a separate spec here.
  {
    "joechrisellis/lsp-format-modifications.nvim", -- Re-referencing the plugin for the command
    -- This specific spec is just to define the command.
    -- It won't cause the plugin to load again unless it's not already loaded.
    lazy = false, -- This ensures the command is available immediately
    config = function()
      -- Define the user command here. It can call the plugin's functions once the plugin is loaded.
      -- The 'require' here will only actually load the plugin if it hasn't been loaded by 'ft="cs"' yet.
      vim.api.nvim_create_user_command("FormatCsModifications", function()
        if vim.bo[0].filetype ~= "cs" then
          vim.notify("This command is for C# files only.", vim.log.levels.WARN)
          return
        end

        -- Ensure the plugin is loaded before trying to call its functions
        local lfm_plugin = require("lsp-format-modifications")

        local clients = vim.lsp.get_clients()
        local cs_client = nil
        for _, client in ipairs(clients) do
          if client.server_capabilities.documentRangeFormattingProvider then
            cs_client = client
            break
          end
        end

        if cs_client then
          lfm_plugin.format_modifications(cs_client, 0)
        else
          vim.notify("No LSP client with range formatting attached to this C# buffer.", vim.log.levels.WARN)
        end
      end, { desc = "Format only modified lines for C# files" })
    end,
    -- No 'dependencies' needed for this specific spec if already listed in the main one
  },
}
