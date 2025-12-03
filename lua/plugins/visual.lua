return {
    { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'ellisonleao/gruvbox.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('gruvbox').setup {
        integrations = {
          native_lsp = {
            enabled = true,
            inlay_hints = {
              background = true, -- if you want a subtle background
            },
          },
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'gruvbox'
      vim.cmd.highlight 'Normal guibg=none'
      vim.cmd.highlight 'NonText guibg=none'
      vim.cmd.highlight 'Normal ctermbg=none'
      vim.cmd.highlight 'NonText ctermbg=none'
    end,
  },
}
