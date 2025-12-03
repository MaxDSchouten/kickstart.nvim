vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 999

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

--  See `:help vim.keymap.set()`
vim.keymap.set('n', 'k', 'kzz')
vim.keymap.set('n', 'j', 'jzz')

-- Yank to system clipboard
vim.keymap.set({ 'n', 'v' }, 'y', '"+y', { noremap = true })
vim.keymap.set('n', 'Y', '"+Y', { noremap = true })

-- Paste from system clipboard
vim.keymap.set({ 'n', 'v' }, 'p', '"+p', { noremap = true })
vim.keymap.set('n', 'P', '"+P', { noremap = true })

-- Optional: delete to clipboard
vim.keymap.set({ 'n', 'v' }, 'd', '"+d', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'x', '"+x', { noremap = true })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show [D]iagnostic on line' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  { 'NMAC427/guess-indent.nvim' },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 100,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
      }
    end,
  },
  { 'folke/which-key.nvim' },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require('telescope').setup {}
      pcall(require('telescope').load_extension, 'fzf')
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    end,
  },
  {
    'mason-org/mason.nvim',
    opts = {},
  },
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        python = { 'Ruff' },
        ansible = { 'ansible-lint' },
        docker = { 'hadolint' },
        rust = { 'clippy' },
      }
      -- Lint on save
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          lint.try_lint()
        end,
      })
      -- Show linters for the current buffer's file type
      vim.api.nvim_create_user_command('LintInfo', function()
        local filetype = vim.bo.filetype
        local linters = require('lint').linters_by_ft[filetype]

        if linters then
          print('Linters for ' .. filetype .. ': ' .. table.concat(linters, ', '))
        else
          print('No linters configured for filetype: ' .. filetype)
        end
      end, {})
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
        'lua_ls',
        'pyright',
        'rust_analyzer',
        'jinja_lsp',
        'clangd',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    config = function() -- Toggle inlay hints
      vim.keymap.set('n', '<leader>ih', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        print('Inlay hints ' .. (enabled and 'disabled' or 'enabled'))
      end, { desc = '[I]nlay [H]ints toggle' })

      local lspconfig = require 'lspconfig'
      -- lspconfig.ansible_lint.setup {
      --   vim.filetype.add {
      --     yaml = 'ansible',
      --     yml = 'ansible',
      --   },
      -- }
      lspconfig.lua_ls.setup {}
      lspconfig.pyright.setup {}
      -- lspconfig.rust_analyzer.setup {
      --   vim.lsp.inlay_hint.enable(true, { 0 }),
      -- }
      lspconfig.yamlls.setup {
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = 'https://www.schemastore.org/api/json/catalog.json',
            },
            validate = true,
            hover = true,
            completion = true,
          },
        },
      }
      lspconfig.jinja_lsp.setup {
        vim.filetype.add {
          extension = {
            jinja = 'jinja',
            jinja2 = 'jinja',
            j2 = 'jinja',
            py = 'python',
          },
        },
      }
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { -- optional cmp completion source for require statements and module annotations
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = 'lazydev',
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  { -- optional blink completion source for require statements and module annotations
    'saghen/blink.cmp',
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      format_on_save = {
        lsp_format = 'fallback',
        timeout_ms = 5000,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        rust = { 'rustfmt' },
      },
    },
  },
  {
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
      vim.cmd.colorscheme 'gruvbox'
      vim.cmd.highlight 'Normal guibg=none'
      vim.cmd.highlight 'NonText guibg=none'
      vim.cmd.highlight 'Normal ctermbg=none'
      vim.cmd.highlight 'NonText ctermbg=none'
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'python', 'rust' },
      auto_install = true,
      highlight = {
        enable = true,
      },
    },
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  { 'nvim-mini/mini.surround', opts = {} },
  { 'm4xshen/autoclose.nvim', opts = {} },
}

vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', {
  fg = '#7c6f64', -- Gruvbox gray (subtle)
  italic = true,
})
