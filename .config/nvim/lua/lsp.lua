vim.lsp.enable('pyright')
vim.lsp.enable('ruff')

vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { noremap = true })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true })

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
  signs = false,
  update_in_insert = false
})
