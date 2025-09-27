return {
  'neovim/nvim-lspconfig',
  config = function()
    -- vim.lsp.enable()
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true })
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { noremap = true })
  end
}
