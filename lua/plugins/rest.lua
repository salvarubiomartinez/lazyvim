return {
  {
    "rest-nvim/rest.nvim",
    config = function()
      require("rest-nvim").setup({
        request = {
          skip_ssl_verification = true, -- Set to true to skip SSL verification
        },
        -- Add any other rest.nvim specific options here
        -- For example:
        -- result_split_horizontal = false,
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    },
  },
}
