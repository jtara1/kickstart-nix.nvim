if vim.g.did_load_lualine_plugin then
    return
end
vim.g.did_load_lualine_plugin = true

local navic = require('nvim-navic')
navic.setup {}

---Indicators for special modes,
---@return string status
local function extra_mode_status()
    -- recording macros
    local reg_recording = vim.fn.reg_recording()
    if reg_recording ~= '' then
        return ' @' .. reg_recording
    end
    -- executing macros
    local reg_executing = vim.fn.reg_executing()
    if reg_executing ~= '' then
        return ' @' .. reg_executing
    end
    -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'ix' then
        return '^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)'
    end
    return ''
end

-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
    blue = '#80a0ff',
    cyan = '#79dac8',
    black = '#080808',
    white = '#c6c6c6',
    red = '#ff5189',
    violet = '#d183e8',
    grey = '#303030',
}

local bubbles_theme = {
    normal = {
        a = { fg = colors.black, bg = colors.violet },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.white },
    },

    insert = { a = { fg = colors.black, bg = colors.blue } },
    visual = { a = { fg = colors.black, bg = colors.cyan } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
        a = { fg = colors.white, bg = colors.black },
        b = { fg = colors.white, bg = colors.black },
        c = { fg = colors.white },
    },
}

require('lualine').setup {
    globalstatus = true,
    sections = {
        -- bubbles theme
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_b = { 'filename', 'branch' },
        lualine_c = {
            '%=', --[[ add your center compoentnts here in place of this comment ]]
        },
        lualine_x = {},
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
        },
    },
    options = {
        theme = bubbles_theme,
        component_separators = '',
        section_separators = { left = '', right = '' },
    },

    inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
    },
    -- Example top tabline configuration (this may clash with other plugins)
    -- tabline = {
    --   lualine_a = {
    --     {
    --       'tabs',
    --       mode = 1,
    --     },
    --   },
    --   lualine_b = {
    --     {
    --       'buffers',
    --       show_filename_only = true,
    --       show_bufnr = true,
    --       mode = 4,
    --       filetype_names = {
    --         TelescopePrompt = 'Telescope',
    --         dashboard = 'Dashboard',
    --         fzf = 'FZF',
    --       },
    --       buffers_color = {
    --         -- Same values as the general color option can be used here.
    --         active = 'lualine_b_normal', -- Color for active buffer.
    --         inactive = 'lualine_b_inactive', -- Color for inactive buffer.
    --       },
    --     },
    --   },
    --   lualine_c = {},
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = {},
    -- },
    winbar = {
        lualine_z = {
            {
                'filename',
                path = 1,
                file_status = true,
                newfile_status = true,
            },
        },
    },
    extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix' },
}
