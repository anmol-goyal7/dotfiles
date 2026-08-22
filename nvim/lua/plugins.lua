-- =============================================================================
-- PLUGINS — managed by lazy.nvim
-- =============================================================================
return {

  -- ============================================================================
  -- COLORSCHEME: Catppuccin Mocha
  -- ============================================================================
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config   = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        integrations = {
          cmp        = true,
          gitsigns   = true,
          harpoon    = true,
          telescope  = { enabled = true },
          treesitter = true,
          which_key  = true,
          mini       = { enabled = true },
          indent_blankline = { enabled = true },
          mason      = true,
          lsp_trouble = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ============================================================================
  -- STATUS LINE
  -- ============================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme                = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators   = { left = "", right = "" },
          disabled_filetypes   = { statusline = { "oil", "lazy", "mason" } },
          globalstatus         = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ============================================================================
  -- WHICH-KEY — shows available keybindings as you type
  -- ============================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts  = {
      delay = 400,
      icons = { mappings = false },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>b",  group = "Buffers" },
        { "<leader>c",  group = "Code / Utils" },
        { "<leader>d",  group = "Diagnostics" },
        { "<leader>f",  group = "Find (Telescope)" },
        { "<leader>g",  group = "Git" },
        { "<leader>h",  group = "Harpoon" },
        { "<leader>l",  group = "LSP" },
        { "<leader>r",  group = "Replace" },
        { "<leader>s",  group = "Splits" },
        { "<leader>t",  group = "Tabs" },
        { "<leader>D",  group = "Debug (DAP)" },
        { "<leader>X",  group = "Trouble" },
        { "<leader>m",  group = "Make / Build" },
        { "<leader>ag", group = "Antigravity" },
      })
    end,
  },

  -- ============================================================================
  -- OIL.NVIM — file explorer as an editable buffer
  -- Edit files/dirs like text: rename = edit text, delete = delete line
  -- ============================================================================
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        delete_to_trash       = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden  = true,
          is_hidden_file = function(name, _)
            return vim.startswith(name, ".")
          end,
        },
        float = {
          padding    = 2,
          max_width  = 80,
          max_height = 30,
          border     = "rounded",
        },
        keymaps = {
          ["g?"]     = "actions.show_help",
          ["<CR>"]   = "actions.select",
          ["<C-v>"]  = "actions.select_vsplit",
          ["<C-h>"]  = "actions.select_split",
          ["<C-t>"]  = "actions.select_tab",
          ["<C-p>"]  = "actions.preview",
          ["<C-r>"]  = "actions.refresh",
          ["-"]      = "actions.parent",
          ["_"]      = "actions.open_cwd",
          ["`"]      = "actions.cd",
          ["~"]      = "actions.tcd",
          ["g."]     = "actions.toggle_hidden",
          ["<Esc>"]  = "actions.close",
          ["q"]      = "actions.close",
        },
        use_default_keymaps = false,
      })
    end,
  },

  -- ============================================================================
  -- HARPOON — instant file jumping (bookmark up to 4 key files)
  -- ============================================================================
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config       = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      local map = vim.keymap.set
      map("n", "<leader>ha", function() harpoon:list():add() end,              { desc = "Harpoon: add file" })
      map("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: menu" })
      map("n", "<leader>hc", function() harpoon:list():clear() end,            { desc = "Harpoon: clear list" })

      -- Jump to files 1-4 with <leader>1-4
      map("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      map("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      map("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      map("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

      -- Cycle through harpoon list
      map("n", "[h", function() harpoon:list():prev() end, { desc = "Harpoon: prev" })
      map("n", "]h", function() harpoon:list():next() end, { desc = "Harpoon: next" })
    end,
  },

  -- ============================================================================
  -- TELESCOPE — fuzzy find everything
  -- ============================================================================
  {
    "nvim-telescope/telescope.nvim",
    tag          = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix    = " ❯ ",
          selection_caret  = " ▶ ",
          border           = true,
          layout_strategy  = "horizontal",
          sorting_strategy = "ascending",
          layout_config    = {
            horizontal = {
              prompt_position = "top",
              preview_width   = 0.55,
            },
          },
          file_ignore_patterns = { "node_modules", ".git/", "%.lock" },
          mappings = {
            i = {
              ["<C-k>"]  = actions.move_selection_previous,
              ["<C-j>"]  = actions.move_selection_next,
              ["<C-q>"]  = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"]  = actions.close,
              ["jk"]     = actions.close,
              ["<C-u>"]  = false,   -- free up for scrolling preview
              ["<C-d>"]  = false,
            },
            n = {
              ["q"] = actions.close,
              ["<Esc>"] = actions.close,
            },
          },
        },
      })

      telescope.load_extension("fzf")

      local builtin = require("telescope.builtin")
      local map     = vim.keymap.set

      map("n", "<leader>ff", builtin.find_files,              { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep,               { desc = "Live grep" })
      map("n", "<leader>fb", builtin.buffers,                 { desc = "Buffers" })
      map("n", "<leader>fh", builtin.help_tags,               { desc = "Help tags" })
      map("n", "<leader>fr", builtin.oldfiles,                { desc = "Recent files" })
      map("n", "<leader>fs", builtin.grep_string,             { desc = "Grep word under cursor" })
      map("n", "<leader>fc", builtin.commands,                { desc = "Commands" })
      map("n", "<leader>fk", builtin.keymaps,                 { desc = "Keymaps" })
      map("n", "<leader>fd", builtin.diagnostics,             { desc = "Diagnostics" })
      map("n", "<leader>ft", "<cmd>TodoTelescope<CR>",        { desc = "Find TODOs" })
      map("n", "<leader>f/", function()
        builtin.current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown({ previewer = false })
        )
      end, { desc = "Fuzzy find in buffer" })

      -- Find files including hidden
      map("n", "<leader>fF", function()
        builtin.find_files({ hidden = true, no_ignore = true })
      end, { desc = "Find files (all)" })
    end,
  },

  -- ============================================================================
  -- GIT
  -- ============================================================================
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>",            { desc = "LazyGit" })
      vim.keymap.set("n", "<leader>gf", "<cmd>LazyGitFilter<CR>",      { desc = "LazyGit file commits" })
      vim.keymap.set("n", "<leader>gc", "<cmd>LazyGitFilterCurrentFile<CR>", { desc = "LazyGit current file" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▎" },
          change       = { text = "▎" },
          delete       = { text = "" },
          topdelete    = { text = "" },
          changedelete = { text = "▎" },
          untracked    = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs  = package.loaded.gitsigns
          local map = function(mode, l, r, opts)
            opts        = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Hunk navigation
          map("n", "]g", gs.next_hunk,           { desc = "Next hunk" })
          map("n", "[g", gs.prev_hunk,           { desc = "Prev hunk" })

          -- Staging
          map("n", "<leader>gs", gs.stage_hunk,  { desc = "Stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk,  { desc = "Reset hunk" })
          map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk (visual)" })
          map("n", "<leader>gS", gs.stage_buffer,  { desc = "Stage buffer" })
          map("n", "<leader>gR", gs.reset_buffer,  { desc = "Reset buffer" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })

          -- Info
          map("n", "<leader>gp", gs.preview_hunk,   { desc = "Preview hunk" })
          map("n", "<leader>gb", gs.blame_line,      { desc = "Blame line" })
          map("n", "<leader>gB", function() gs.blame_line({ full = true }) end, { desc = "Blame line (full)" })
          map("n", "<leader>gd", gs.diffthis,        { desc = "Diff this" })
          map("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff this ~" })

          -- Toggle
          map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
          map("n", "<leader>gtd", gs.toggle_deleted,            { desc = "Toggle deleted" })
        end,
      })
    end,
  },

  -- ============================================================================
  -- LSP
  -- ============================================================================
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "bashls", "jsonls", "cssls", "html",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Diagnostics appearance
      vim.diagnostic.config({
        virtual_text     = true,
        signs            = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = "󰠠 ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
        underline        = true,
        update_in_insert = false,
        float            = { border = "rounded", source = true },
      })

      -- Keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
          end
          local tb = require("telescope.builtin")

          map("gd",         tb.lsp_definitions,       "Go to definition")
          map("gD",         vim.lsp.buf.declaration,  "Go to declaration")
          map("gr",         tb.lsp_references,        "References")
          map("gi",         tb.lsp_implementations,   "Go to implementation")
          map("gt",         tb.lsp_type_definitions,  "Type definition")
          map("K",          vim.lsp.buf.hover,         "Hover docs")
          map("<C-k>",      vim.lsp.buf.signature_help,"Signature help")
          map("<leader>lr", vim.lsp.buf.rename,        "Rename")
          map("<leader>la", vim.lsp.buf.code_action,   "Code action")
          -- NOTE: <leader>lf is owned by conform.nvim (clang-format et al,
          -- with LSP as fallback) — see the FORMATTING block below.
          map("<leader>ls", tb.lsp_document_symbols,  "Document symbols")
          map("<leader>lS", tb.lsp_workspace_symbols, "Workspace symbols")
          map("<leader>li", "<cmd>LspInfo<CR>",        "LSP info")
          map("<leader>lR", "<cmd>LspRestart<CR>",     "Restart LSP")
        end,
      })

      -- Server configs via new vim.lsp.config API
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
            telemetry   = { enable = false },
          },
        },
      })

      -- C / C++ — system clangd (/usr/bin/clangd from the `clang` package).
      -- Warning flags live in ~/.config/clangd/config.yaml so they also apply
      -- to loose single-file translation units with no compile_commands.json.
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=never",
          "--fallback-style=llvm",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
      })

      -- Rust — rust-analyzer from rustup/cargo (~/.cargo/bin), not mason.
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            cargo       = { allFeatures = true },
            check       = { command = "clippy" },
            checkOnSave = true,
          },
        },
      })

      vim.lsp.enable({
        "lua_ls", "pyright", "bashls", "jsonls", "cssls", "html",
        "clangd", "rust_analyzer",
      })
    end,
  },

  -- ============================================================================
  -- LINTING — real compiler warnings (-Wall -Wextra) on save
  -- ============================================================================
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint   = require("lint")
      local parser = require("lint.parser")

      -- gcc/g++ diagnostics: "file.c:12:5: warning: msg [-Wunused-variable]"
      local pattern  = "([^:]+):(%d+):(%d+):%s+(%w+):%s+(.+)"
      local groups   = { "file", "lnum", "col", "severity", "message" }
      local severity = {
        ["error"]   = vim.diagnostic.severity.ERROR,
        ["warning"] = vim.diagnostic.severity.WARN,
        ["note"]    = vim.diagnostic.severity.HINT,
      }

      local function cc(cmd, extra)
        local args = { "-fsyntax-only", "-Wall", "-Wextra", "-fdiagnostics-plain-output" }
        vim.list_extend(args, extra or {})
        return {
          cmd             = cmd,
          stdin           = false,
          append_fname    = true,
          args            = args,
          stream          = "stderr",
          ignore_exitcode = true,
          parser          = parser.from_pattern(pattern, groups, severity, { source = cmd }),
        }
      end

      lint.linters.gcc = cc("gcc")
      lint.linters.gpp = cc("g++")

      lint.linters_by_ft = {
        c   = { "gcc" },
        cpp = { "gpp" },
      }

      -- clangd already reports most of -Wall live, so the compiler pass is
      -- opt-out: it exists to catch gcc-only warnings (-Wmaybe-uninitialized,
      -- -Wstringop-overflow, ...) and to match what your build actually prints.
      vim.g.cc_lint_enabled = true

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        group    = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          if vim.g.cc_lint_enabled == false and vim.tbl_contains({ "c", "cpp" }, vim.bo.filetype) then
            return
          end
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ll", function() lint.try_lint() end, { desc = "Lint buffer now" })

      vim.keymap.set("n", "<leader>lt", function()
        vim.g.cc_lint_enabled = not vim.g.cc_lint_enabled
        if vim.g.cc_lint_enabled then
          lint.try_lint()
        else
          vim.diagnostic.reset(lint.get_namespace("gcc"))
          vim.diagnostic.reset(lint.get_namespace("gpp"))
        end
        vim.notify("gcc/g++ lint " .. (vim.g.cc_lint_enabled and "on" or "off"))
      end, { desc = "Toggle gcc/g++ lint" })
    end,
  },

  -- ============================================================================
  -- DEBUGGING — nvim-dap + codelldb (C / C++ / Rust)
  -- F-keys, not <leader>d: that prefix is already delete-to-void + diagnostics.
  -- ============================================================================
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
    },
    keys = {
      "<F5>", "<F9>", "<F10>", "<F11>", "<F12>",
      "<leader>Db", "<leader>Dr", "<leader>Du", "<leader>Dc", "<leader>Dx",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup({ floating = { border = "rounded" } })
      require("nvim-dap-virtual-text").setup({ commented = true })

      -- codelldb ships via mason: :MasonInstall codelldb
      local codelldb = vim.fn.stdpath("data") .. "/mason/bin/codelldb"

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb,
          args    = { "--port", "${port}" },
        },
      }

      -- Ask for the binary, defaulting to the nearest sensible guess.
      local function pick_binary()
        local guess = vim.fn.getcwd() .. "/"
        local stem  = vim.fn.expand("%:t:r")
        for _, cand in ipairs({ guess .. stem, guess .. "build/" .. stem, guess .. "a.out" }) do
          if vim.fn.executable(cand) == 1 then guess = cand break end
        end
        return vim.fn.input("Executable: ", guess, "file")
      end

      local cfg = {
        {
          name         = "Launch",
          type         = "codelldb",
          request      = "launch",
          program      = pick_binary,
          cwd          = "${workspaceFolder}",
          stopOnEntry  = false,
          args         = function()
            local a = vim.fn.input("Args: ")
            return a ~= "" and vim.split(a, " ") or {}
          end,
        },
        {
          name    = "Attach to process",
          type    = "codelldb",
          request = "attach",
          pid     = require("dap.utils").pick_process,
          cwd     = "${workspaceFolder}",
        },
      }

      dap.configurations.c    = cfg
      dap.configurations.cpp  = cfg
      dap.configurations.rust = cfg

      -- UI opens/closes with the session
      dap.listeners.before.attach.dapui_config           = function() dapui.open() end
      dap.listeners.before.launch.dapui_config           = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end

      vim.fn.sign_define("DapBreakpoint",          { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DapLogPoint",            { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DapStopped",             { text = " ", texthl = "DiagnosticSignHint", linehl = "Visual" })

      local map = function(k, fn, desc) vim.keymap.set("n", k, fn, { desc = desc }) end

      map("<F5>",  dap.continue,          "Debug: start / continue")
      map("<F9>",  dap.toggle_breakpoint, "Debug: toggle breakpoint")
      map("<F10>", dap.step_over,         "Debug: step over")
      map("<F11>", dap.step_into,         "Debug: step into")
      map("<F12>", dap.step_out,          "Debug: step out")

      map("<leader>Db", dap.toggle_breakpoint, "Debug: toggle breakpoint")
      map("<leader>DB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, "Debug: conditional breakpoint")
      map("<leader>Dr", dap.repl.toggle,   "Debug: REPL")
      map("<leader>Du", dapui.toggle,      "Debug: toggle UI")
      map("<leader>Dc", dap.run_to_cursor, "Debug: run to cursor")
      map("<leader>Dl", dap.run_last,      "Debug: re-run last")
      map("<leader>Dx", function()
        dap.terminate()
        dapui.close()
      end, "Debug: terminate")
      map("<leader>De", dapui.eval,        "Debug: eval expression")
      vim.keymap.set("v", "<leader>De", dapui.eval, { desc = "Debug: eval selection" })
    end,
  },

  -- ============================================================================
  -- FORMATTING — clang-format / stylua / etc on save
  -- ============================================================================
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd   = "ConformInfo",
    config = function()
      local conform = require("conform")

      conform.setup({
        -- Only formatters actually installed are listed (clang-format and
        -- rustfmt are system/cargo; stylua and shfmt come from mason).
        -- Everything else falls through to the LSP formatter via
        -- lsp_format = "fallback" below.
        formatters_by_ft = {
          c    = { "clang_format" },
          cpp  = { "clang_format" },
          cuda = { "clang_format" },
          rust = { "rustfmt" },
          lua  = { "stylua" },
          sh   = { "shfmt" },
        },
        -- Opt-out: :FormatToggle, or <leader>lF
        format_on_save = function(bufnr)
          if vim.g.format_on_save == false or vim.b[bufnr].format_on_save == false then
            return nil
          end
          return { timeout_ms = 1000, lsp_format = "fallback" }
        end,
      })

      vim.g.format_on_save = true

      vim.keymap.set({ "n", "v" }, "<leader>lf", function()
        conform.format({ async = true, lsp_format = "fallback" })
      end, { desc = "Format buffer/selection" })

      vim.keymap.set("n", "<leader>lF", function()
        vim.g.format_on_save = not vim.g.format_on_save
        vim.notify("format on save " .. (vim.g.format_on_save and "on" or "off"))
      end, { desc = "Toggle format on save" })
    end,
  },

  -- ============================================================================
  -- DIAGNOSTICS PANEL
  -- ============================================================================
  {
    "folke/trouble.nvim",
    cmd  = "Trouble",
    opts = { focus = true },
    keys = {
      -- <leader>X, not <leader>x: lowercase x is already "save and quit".
      { "<leader>Xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (workspace)" },
      { "<leader>Xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>Xs", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols" },
      { "<leader>Xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix list" },
      { "<leader>Xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location list" },
      { "<leader>Xt", "<cmd>Trouble todo toggle<cr>",                     desc = "TODOs" },
    },
  },

  -- ============================================================================
  -- COMPLETION
  -- ============================================================================
  {
    "saghen/blink.cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    version = "*",
    opts = {
      keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "fallback" },
        ["<C-e>"]     = { "hide", "fallback" },
        ["<CR>"]      = { "accept", "fallback" },
        ["<C-k>"]     = { "select_prev", "fallback" },
        ["<C-j>"]     = { "select_next", "fallback" },
        ["<C-u>"]     = { "scroll_documentation_up", "fallback" },
        ["<C-d>"]     = { "scroll_documentation_down", "fallback" },
        ["<Tab>"]     = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"]   = { "snippet_backward", "select_prev", "fallback" },
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        menu = { border = "rounded" },
        documentation = { auto_show = true, window = { border = "rounded" } },
      },
    },
  },

  -- ============================================================================
  -- TREESITTER
  -- ============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash", "c", "css", "html", "javascript", "json",
        "lua", "markdown", "markdown_inline", "python",
        "typescript", "vim", "vimdoc", "yaml", "toml",
      },
      auto_install = true,
      highlight    = { enable = true },
      indent       = { enable = true },
    },
  },

  -- ============================================================================
  -- UTILITIES
  -- ============================================================================

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
    end,
  },

  -- Comments: gcc / gc + motion
  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main   = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope  = { enabled = true },
      })
    end,
  },

  -- TODO / FIXME / HACK / NOTE highlights + telescope integration
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config       = function() require("todo-comments").setup() end,
  },

  -- Tmux ↔ nvim pane navigation with the same C-hjkl keys
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd  = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp",   "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>" },
    },
  },

  -- Surround: ys, ds, cs (ysiw" wraps word in quotes, etc.)
  {
    "kylechui/nvim-surround",
    event  = "VeryLazy",
    config = function() require("nvim-surround").setup() end,
  },

  -- Flash: press s + 2 chars to jump anywhere on screen
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts  = {},
    keys  = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,            desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,      desc = "Flash treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,           desc = "Flash remote" },
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash treesitter search" },
    },
  },

  -- Mini.nvim — small focused utilities
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Highlight word under cursor
      require("mini.cursorword").setup()
      -- Better text objects: around/inside function, class, etc.
      require("mini.ai").setup({ n_lines = 500 })
    end,
  },

}
