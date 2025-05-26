-- ~/.config/nvim/lua/plugins/lazyvim_format_config.lua
return {
  -- This is a general config for LazyVim's formatting
  {
    "LazyVim/LazyVim",
    opts = {
      -- Ensure this block is added if you don't have it, or merge if you do.
      format = {
        -- Add 'cs' to the list of excluded filetypes for LazyVim's conform formatting.
        excluded = { "cs" },
      },
    },
  },
}
