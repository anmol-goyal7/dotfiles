-- =============================================================================
-- NEOVIM KEYMAPS
-- =============================================================================
local map = vim.keymap.set

-- =============================================================================
-- ESCAPE
-- =============================================================================
map("i", "jk", "<Esc>",  { desc = "Exit insert mode" })
map("i", "kj", "<Esc>",  { desc = "Exit insert mode" })

-- =============================================================================
-- SAVING & QUITTING
-- =============================================================================
map("n", "<leader>w",  "<cmd>w<CR>",   { desc = "Save" })
map("n", "<leader>q",  "<cmd>q<CR>",   { desc = "Quit" })
map("n", "<leader>Q",  "<cmd>qa!<CR>", { desc = "Quit all (force)" })
map("n", "<leader>x",  "<cmd>x<CR>",   { desc = "Save and quit" })
map("n", "<leader>W",  "<cmd>wa<CR>",  { desc = "Save all" })

-- =============================================================================
-- VISUAL MODE — LINE MOVING & INDENTING
-- =============================================================================
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<", "<gv",              { desc = "Indent left (stay in visual)" })
map("v", ">", ">gv",              { desc = "Indent right (stay in visual)" })

-- =============================================================================
-- CENTERED SCROLLING (muscle memory from vim)
-- =============================================================================
map("n", "<C-d>", "<C-d>zz",  { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz",  { desc = "Scroll up (centered)" })
map("n", "n",     "nzzzv",    { desc = "Next search result (centered)" })
map("n", "N",     "Nzzzv",    { desc = "Prev search result (centered)" })
map("n", "G",     "Gzz",      { desc = "Go to bottom (centered)" })

-- =============================================================================
-- WINDOW MANAGEMENT (C-hjkl: unified with tmux via vim-tmux-navigator)
-- =============================================================================
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", "<cmd>split<CR>",  { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=",          { desc = "Equal splits" })
map("n", "<leader>sc", "<cmd>close<CR>",  { desc = "Close split" })
map("n", "<leader>so", "<C-w>o",          { desc = "Close other splits" })

-- =============================================================================
-- BUFFER NAVIGATION
-- =============================================================================
map("n", "<S-h>",      "<cmd>bprevious<CR>",     { desc = "Prev buffer" })
map("n", "<S-l>",      "<cmd>bnext<CR>",          { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>",        { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<CR>",       { desc = "Force delete buffer" })
map("n", "<leader>ba", "<cmd>bufdo bdelete<CR>",  { desc = "Delete all buffers" })
map("n", "<leader>bo", "<cmd>%bdelete|e#|bdelete#<CR>", { desc = "Delete other buffers" })

-- =============================================================================
-- TAB MANAGEMENT
-- =============================================================================
map("n", "<leader>tn", "<cmd>tabnew<CR>",    { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>",  { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<CR>",   { desc = "Close other tabs" })

-- =============================================================================
-- CLIPBOARD & REGISTERS
-- =============================================================================
-- Paste over selection without losing the register
map("x", "<leader>p", '"_dP', { desc = "Paste (keep register)" })

-- Delete without polluting the register
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void" })

-- Explicit system clipboard yank
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n",          "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

-- =============================================================================
-- SEARCH & REPLACE
-- =============================================================================
-- Replace word under cursor across the file
map("n", "<leader>rw",
  ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
  { desc = "Replace word under cursor" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- =============================================================================
-- DIAGNOSTICS
-- =============================================================================
map("n", "[d",        vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
map("n", "]d",        vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>k", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
map("n", "<leader>dl",vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- =============================================================================
-- MISC UTILITIES
-- =============================================================================
-- Make current file executable
map("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

-- Source current file
map("n", "<leader>so", "<cmd>source %<CR>", { desc = "Source current file" })

-- Open current file's directory in oil
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "File explorer" })
map("n", "-",         "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- Quickfix list navigation
map("n", "<leader>co", "<cmd>copen<CR>",  { desc = "Open quickfix" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
map("n", "]q", "<cmd>cnext<CR>",          { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<CR>",          { desc = "Prev quickfix item" })

-- =============================================================================
-- ANTIGRAVITY — open files/project in Google Antigravity IDE
-- =============================================================================
-- Open current file at current line
map("n", "<leader>agf", function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  local col  = vim.fn.col(".")
  vim.fn.system({ "antigravity", "--goto", file .. ":" .. line .. ":" .. col })
end, { desc = "Antigravity: open file at cursor" })

-- Open project (cwd) in Antigravity
map("n", "<leader>agp", function()
  vim.fn.system({ "antigravity", vim.fn.getcwd() })
end, { desc = "Antigravity: open project" })

-- Open current file's diff in Antigravity
map("n", "<leader>agd", function()
  local file = vim.fn.expand("%:p")
  vim.fn.system({ "antigravity", "--diff", file, file })
end, { desc = "Antigravity: diff current file" })

-- =============================================================================
-- BUILD — :make into the quickfix list, then jump to the first error
-- Uses the project's Makefile when there is one, otherwise compiles the
-- current file straight to build/<name>. Quickfix nav is ]q / [q as usual.
-- =============================================================================
local function project_root()
  local found = vim.fs.find({ "Makefile", "makefile", "CMakeLists.txt", "Cargo.toml" }, {
    upward = true,
    path   = vim.fn.expand("%:p:h"),
  })[1]
  return found and vim.fs.dirname(found) or nil
end

local function build(extra)
  vim.cmd("silent! write")
  local root = project_root()

  if root and vim.uv.fs_stat(root .. "/Cargo.toml") then
    vim.o.makeprg = "cargo build"
  elseif root then
    vim.o.makeprg = "make -C " .. vim.fn.fnameescape(root)
  else
    -- Lone file: gcc/g++ it into build/ with warnings + debug info on.
    local ft  = vim.bo.filetype
    local cc  = (ft == "cpp") and "g++" or "gcc"
    local src = vim.fn.expand("%")
    local out = vim.fn.expand("%:p:h") .. "/build/" .. vim.fn.expand("%:t:r")
    vim.fn.mkdir(vim.fn.fnamemodify(out, ":h"), "p")
    vim.o.makeprg = string.format("%s -g -Wall -Wextra -o %s %s", cc, out, src)
  end

  vim.cmd("make! " .. (extra or ""))
  local qf = vim.fn.getqflist()
  local bad = vim.tbl_filter(function(e) return e.valid == 1 end, qf)
  if #bad > 0 then
    vim.cmd("copen")
    vim.cmd("cfirst")
  else
    vim.cmd("cclose")
    vim.notify("build ok: " .. vim.o.makeprg)
  end
end

map("n", "<leader>mm", function() build() end,           { desc = "Make / build" })
map("n", "<leader>mc", function() build("clean") end,    { desc = "Make clean" })
map("n", "<leader>mr", function() build("run") end,      { desc = "Make run" })
map("n", "<leader>mt", function() build("test") end,     { desc = "Make test" })

-- Regenerate compile_commands.json so clangd sees the project's real flags.
map("n", "<leader>mb", function()
  local root = project_root()
  if not root then
    vim.notify("no Makefile/CMakeLists found above this file", vim.log.levels.WARN)
    return
  end
  vim.notify("running bear -- make in " .. root .. " ...")
  -- `make clean` first: bear only records compiles that actually run, so an
  -- already-built tree would produce an empty compile_commands.json.
  vim.system({ "make", "clean" }, { cwd = root, text = true }, function()
    vim.system({ "bear", "--", "make" }, { cwd = root, text = true }, function(res)
      vim.schedule(function()
        if res.code == 0 then
          vim.notify("compile_commands.json written to " .. root .. " — restarting clangd")
          vim.cmd("LspRestart clangd")
        else
          vim.notify("bear failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end, { desc = "Bear: regen compile_commands.json" })

-- =============================================================================
-- CPPCHECK — deeper static analysis, on demand (not on save: clangd's
-- clang-tidy already runs live, and three sources of squiggles is too many).
-- Results land in the quickfix list; ]q / [q to walk them.
-- =============================================================================
map("n", "<leader>lc", function()
  local target = vim.fn.expand("%:p")
  if vim.bo.filetype ~= "c" and vim.bo.filetype ~= "cpp" then
    vim.notify("cppcheck: not a C/C++ buffer", vim.log.levels.WARN)
    return
  end
  vim.notify("cppcheck: analysing " .. vim.fn.expand("%:t") .. " ...")
  vim.system({
    "cppcheck", "--enable=warning,style,performance,portability",
    "--inline-suppr", "--quiet",
    "--template={file}:{line}:{column}: {severity}: {message} [{id}]",
    target,
  }, { text = true }, function(res)
    vim.schedule(function()
      local out = (res.stderr or "") .. (res.stdout or "")
      if vim.trim(out) == "" then
        vim.notify("cppcheck: clean")
        return
      end
      vim.fn.setqflist({}, " ", {
        title = "cppcheck",
        lines = vim.split(vim.trim(out), "\n"),
        efm   = "%f:%l:%c: %t%*[^:]: %m",
      })
      vim.cmd("copen")
    end)
  end)
end, { desc = "cppcheck current file" })
