return {
  'rebelot/kanagawa.nvim',
  config = function()
    require("kanagawa").setup({
        transparent = true
      })
    require("kanagawa").load("wave")

    -- Custom Highlight Group Overrides
    -- These fine-tune the appearance of specific UI elements.
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' }) -- (NonCurrent)
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = 'NONE' })

    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#777777', bg = 'none' })

    -- vim.api.nvim_set_hl(0, 'Underlined', { fg = '#f9e2af', bg = 'NONE' })

    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffa066' }) -- Color for the line number on the current cursor line.
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#717c7c' })       -- Color for absolute line numbers.
    -- vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'None' })
    vim.api.nvim_set_hl(0, 'FoldColumn', { bg = 'None' })

    vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none', fg = '#cccccc' })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none', fg = '#717c7c' })
  end
}
