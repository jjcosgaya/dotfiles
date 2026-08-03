-- which-key
local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

-- Utility mappings
-- Clear search with <Esc>.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { noremap = true, silent = true, desc = 'Clear search highlight' })

-- Clipboard: <leader>y yanks to +; <leader>p/P paste from +.
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true, silent = true, desc = "Yank to system clipboard" })
vim.keymap.set('n', '<leader>p', '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard after cursor" })
vim.keymap.set('n', '<leader>P', '"+P', { noremap = true, silent = true, desc = "Paste from system clipboard before cursor" })
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true, desc = "Yank selection to system clipboard" })
vim.keymap.set('v', '<leader>p', '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard over selection" })
vim.keymap.set('v', '<leader>P', '"+P', { noremap = true, silent = true, desc = "Paste from system clipboard before selection (like normal P)"})
wk.add({
  mode = { 'n', 'v' },
  hidden = true,
  { '<leader>y' },
  { '<leader>p' },
  { '<leader>P' }
})

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Right' })

vim.keymap.set('n', '<leader>wh', '<C-w>h', { noremap = true, silent = true, desc = 'Move left' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { noremap = true, silent = true, desc = 'Move down' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { noremap = true, silent = true, desc = 'Move up' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { noremap = true, silent = true, desc = 'Move right' })

wk.add({
  { '<leader>w', group = 'Windows', mode = 'n' }
})

-- Close buffers
vim.keymap.set('n', '<leader>cb', ':bd<CR>', { noremap = true, silent = true, desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>cw', ':close<CR>', { noremap = true, silent = true, desc = 'Close current window' })

wk.add({
  { '<leader>c', group = 'Close', mode = 'n' }
})

-- Terminal
vim.keymap.set('n', '<leader>tn', ":term<cr>", { noremap = true, silent = true, desc = "New terminal"})
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    -- Enter executes in terminal mode.
    vim.keymap.set('n', '<cr>', [[i<Cr><C-\><C-n>]], { noremap = true, silent = true, buffer = true, desc = "Execute command" })
    -- Open terminals in splits.
    vim.keymap.set('n', '<C-w>v', ':vsplit | term<cr>', { noremap = true, silent = true, buffer = true, desc = "Vertical split new terminal" })
    vim.keymap.set('n', '<C-w>s', ':split | term<cr>', { noremap = true, silent = true, buffer = true, desc = "Horizontal split new terminal" })
  end,
})
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], { remap = true, silent = true, desc = "Toggle terminals tab"})
vim.keymap.set('t', '<C-y>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Copy mode" })

local showTerminals = function()
  local tab_count = vim.fn.tabpagenr('$')
  if tab_count == 1 then
    vim.cmd("tabnew")
    vim.cmd("term")
  elseif tab_count == 2 then
    vim.cmd("tabnext")
  else
    print("You're using more than two tabs!")
  end
end
vim.keymap.set('n', '<A-t>', showTerminals, { noremap = true, silent = true, desc = "Toggle terminals tab"})
vim.keymap.set('t', '<A-t>', [[<C-\><C-n>:tabnext<cr>]], { noremap = true, silent = true, desc = "Toggle terminals tab"})


wk.add({
  { '<leader>t', group = 'Terminal', mode = 'n' }
})

-- Keep the visual selection after indenting.
vim.keymap.set('v', '<S-tab>', '<gv', { noremap = true, silent = true, desc = 'Outdent line(s) and reselect' })
vim.keymap.set('v', '<tab>', '>gv', { noremap = true, silent = true, desc = 'Indent line(s) and reselect' })
