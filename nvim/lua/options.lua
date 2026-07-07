-- =============================================================================
-- NEOVIM OPTIONS
-- =============================================================================
local o = vim.opt

-- Line numbers
o.number         = true
o.relativenumber = true

-- Tabs & indentation
o.tabstop     = 4
o.shiftwidth  = 4
o.expandtab   = true
o.smartindent = true
o.autoindent  = true

-- Visuals
o.wrap         = false
o.cursorline   = true
o.termguicolors= true
o.signcolumn   = "yes"
o.colorcolumn  = "100"
o.scrolloff    = 8
o.sidescrolloff= 8
o.splitright   = true
o.splitbelow   = true
o.showmode     = false    -- lualine shows mode instead
o.pumheight    = 10
o.cmdheight    = 1

-- Files
o.swapfile = false
o.backup   = false
o.undodir  = vim.fn.stdpath("data") .. "/undodir"
o.undofile = true

-- Search
o.hlsearch  = false
o.incsearch = true
o.ignorecase= true
o.smartcase = true

-- Clipboard — yank/paste directly to system clipboard
o.clipboard = "unnamedplus"

-- Performance
o.updatetime = 100
o.timeoutlen = 300

-- Folds (treesitter-based)
o.foldlevel  = 99
o.foldmethod = "expr"
o.foldexpr   = "v:lua.vim.treesitter.foldexpr()"

-- Misc
o.mouse = ""   -- disable mouse completely
o.formatoptions:remove({ "c", "r", "o" })  -- don't auto-insert comment leaders
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Better diff
o.diffopt:append("linematch:60")
