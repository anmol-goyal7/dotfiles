-- =============================================================================
-- NEOVIM CONFIG — VIM-FIRST, KEYBOARD-ONLY WORKFLOW
-- Symlink: ln -sf ~/repos/dotfiles/nvim ~/.config/nvim
-- =============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key must be set before plugins load
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("lazy").setup("plugins", {
  ui = { border = "rounded" },
  checker = { enabled = false },
  change_detection = { notify = false },
})
