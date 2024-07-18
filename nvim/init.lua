local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

-- <leader> key. Defaults to `\`. Some people prefer space.
g.mapleader = ' '
g.maplocalleader = ' '

opt.compatible = false

-- Enable true colour support
if fn.has('termguicolors') then
  opt.termguicolors = true
end

-- See :h <option> to see what the options do

-- Search down into subfolders
opt.path = vim.o.path .. '**'

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.lazyredraw = true
opt.showmatch = true -- Highlight matching parentheses, etc
opt.incsearch = true
opt.hlsearch = true

opt.spell = false
opt.spelllang = 'en'

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.foldenable = true
opt.history = 2000
opt.nrformats = 'bin,hex' -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

local sign = function(opts)
  fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = '',
  })
end
-- Requires Nerd fonts
sign { name = 'DiagnosticSignError', text = '󰅚' }
sign { name = 'DiagnosticSignWarn', text = '⚠' }
sign { name = 'DiagnosticSignInfo', text = 'ⓘ' }
sign { name = 'DiagnosticSignHint', text = '󰌶' }

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

g.editorconfig = true

vim.opt.colorcolumn = '100'
vim.opt.guifont = "Hack Nerd Font:h12"

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')
cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')

vim.opt.autowrite = true

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    pattern = { "*" },
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local buftype = vim.bo[bufnr].buftype
        local filetype = vim.bo[bufnr].filetype

        -- List of buffer types and filetypes we don't want to auto-save
        local excluded_types = {
            "prompt", "nofile", "help", "quickfix", "terminal", "telescope"
        }
        local excluded_filetypes = {
            "gitcommit", "gitrebase", "svg", "hgcommit"
        }

        if vim.tbl_contains(excluded_types, buftype) or vim.tbl_contains(excluded_filetypes, filetype) then
            return
        end

        if vim.fn.expand('%') ~= '' and vim.bo.modified then
            vim.cmd('silent! write')
        end
    end
})

-- load ~/.config/nvim/exp.lua if exists
local function get_config_home()
    return os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
end

local function load_exp_config()
    local config_home = get_config_home()
    local exp_path = config_home .. "/nvim/exp.lua"

    if vim.fn.filereadable(exp_path) == 1 then
        dofile(exp_path)
        print("Experimental config loaded from " .. exp_path)
    else
        print("Experimental config not found at " .. exp_path)
    end
end

-- Bind the function to a hotkey (e.g., <leader>le for "load experimental")
vim.keymap.set("n", "<leader>le", load_exp_config, { noremap = true, silent = false, desc = "Load experimental config" })

load_exp_config()
