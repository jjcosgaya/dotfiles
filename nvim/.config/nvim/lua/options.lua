-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- UI

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Search highlighting
vim.opt.hlsearch = true

-- Status line
vim.opt.showcmd = true

vim.opt.laststatus = 3 -- Global status line

local statusline = {
  ' ',
  ' %f',
  ' %m%h%r%w',
  '%=',
  '%=',
  '󰳂 %l:%c',
  ' | ',
  ' %L',
  ' | ',
  '▰ %p%% ',
}

vim.o.statusline = table.concat(statusline, '')
vim.opt.cmdheight = 1;


-- Tabs
vim.opt.showtabline = 0;

-- Cursor
vim.opt.cursorline = true

-- Colors
vim.opt.termguicolors = false


-- Folding and conceal
vim.opt.foldlevel = 99
vim.opt.foldenable = true

vim.opt.foldmethod = 'expr'
vim.g.vimwiki_folding = 'syntax'

vim.opt_local.foldcolumn = '1'
vim.opt.conceallevel = 2


-- Editing

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.breakindent = true

-- Undo
vim.opt.undofile = true

-- Buffers
vim.opt.hidden = true

-- Search behavior
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Whitespace
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Scrolling
vim.opt.scrolloff = 5

-- Mouse
vim.opt.mouse = 'a'

-- Virtual edit
vim.opt.virtualedit = 'block'

-- Incremental command preview
vim.opt.inccommand = 'split'

-- Behavior

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Netrw
vim.g.netrw_liststyle = 3

-- Marks
-- Swap case of mark names.
local low = function(i) return string.char(97+i) end
local upp = function(i) return string.char(65+i) end

for i=0,25 do vim.keymap.set("n", "m"..low(i), "m"..upp(i)) end
for i=0,25 do vim.keymap.set("n", "m"..upp(i), "m"..low(i)) end
for i=0,25 do vim.keymap.set("n", "'"..low(i), "'"..upp(i)) end
for i=0,25 do vim.keymap.set("n", "'"..upp(i), "'"..low(i)) end


-- Terminal
local term_group = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = term_group,
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
    vim.opt_local.cursorline = true
    vim.opt_local.scrollback = 100000
  end,
})

vim.api.nvim_create_autocmd("TermLeave", {
  group = term_group,
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
    vim.opt_local.cursorline = true
  end,
})

-- Remove non-floating terminal buffers.
vim.api.nvim_create_autocmd("WinClosed", {
  group = term_group,
  callback = function(event)
    local function is_floating(win)
      if not vim.api.nvim_win_is_valid(win) then return false end

      local config = vim.api.nvim_win_get_config(win)
      return config.relative ~= ""
    end

    local win = tonumber(event.match)
    local buf = tonumber(event.buf)

    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" and not is_floating(win) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end,
})
