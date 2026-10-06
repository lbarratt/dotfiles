if vim.loader then
  vim.loader.enable()
end

local keymap = vim.keymap

-- Environment

vim.env.NODE_OPTIONS = "--max-old-space-size=16000" -- 16GB (!)

-- Global Variables

vim.g.mapleader = "\\"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Vim Options

vim.opt.nu = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.laststatus = 3
vim.opt.tabstop = 4
vim.opt.backspace = "indent,eol,start"
vim.opt.colorcolumn = "80"
vim.opt.undofile = true
vim.opt.undodir = "$HOME/.vim/undo"
vim.opt.undolevels = 10000
vim.opt.undoreload = 100000
vim.opt.lazyredraw = true
vim.opt.clipboard = "unnamedplus"
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.showmatch = true
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.cmdheight = 2
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.re = 0

-- Send "d" to a blackhole register
keymap.set("n", "d", '"_d', { silent = true, noremap = true })
keymap.set("v", "d", '"_d', { silent = true, noremap = true })

-- Split Navigation
keymap.set("n", "<C-H>", "<C-W><C-H>")
keymap.set("n", "<C-J>", "<C-W><C-J>")
keymap.set("n", "<C-K>", "<C-W><C-K>")
keymap.set("n", "<C-L>", "<C-W><C-L>")

-- Remove highlight on ESC
keymap.set("n", "<esc>", ":nohl<CR><esc>", { silent = true, noremap = true })

-- Keep cursor in the middle for specific motions
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")

-- Don't leave visual mode after indenting
keymap.set("v", ">", ">gv^")
keymap.set("v", "<", "<gv^")

-- Disable macro recording with q
keymap.set("n", "q", "<nop>")

-- Disable native LSP file watching
local ok, wf = pcall(require, "vim.lsp._watchfiles")

if ok then
  wf._watchfunc = function()
    return function() end
  end
end

-- Init lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local node_bin_dir_cache = {}

-- Resolve the node version pinned in the nearest `.nvmrc` via fnm.
local function node_bin_dir_from_nvmrc(dir)
  local root = vim.fs.root(dir, { ".nvmrc" })

  if not root or vim.fn.executable("fnm") ~= 1 then
    return nil
  end

  local version = vim.trim(table.concat(vim.fn.readfile(root .. "/.nvmrc"), ""))

  if version == "" then
    return nil
  end

  if node_bin_dir_cache[version] == nil then
    local result = vim.system({
      "fnm",
      "exec",
      "--using=" .. version,
      "--",
      "sh",
      "-c",
      'dirname "$(command -v node)"',
    }, { text = true }):wait()

    node_bin_dir_cache[version] = result.code == 0 and vim.trim(result.stdout) or false
  end

  return node_bin_dir_cache[version] or nil
end

-- Lazy Plugins

require("lazy").setup({
  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          nvimtree = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "catppuccin",
    },
    opt = true,
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin-nvim",
        },
        extensions = {
          "nvim-tree",
        },
        sections = {
          lualine_b = {
            {
              "branch",
              "diff",
              "diagnostics",
              sources = { "nvim_lsp", "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
            },
          },
        },
      })
    end,
  },

  -- Search
  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      debug = {
        enabled = true,
        show_scores = true,
      },
    },
    lazy = false,
    keys = {
      {
        "<C-p>",
        function() require('fff').find_files() end,
        desc = 'FFFind files',
      },
      {
        "<leader>ff",
        function() require('fff').find_files() end,
        desc = 'FFFind files',
      },
      {
        "<leader>ff",
        function() require('fff').live_grep() end,
        desc = 'LiFFFe grep',
      },
      {
        "<leader>fg",
        function()
          require('fff').live_grep({
            grep = {
              modes = { 'fuzzy', 'plain' }
            }
          })
        end,
        desc = 'Live fffuzy grep',
      }
    }
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("spectre").setup()

      keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
        desc = "Toggle Spectre",
      })

      keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = "Search current word",
      })

      keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = "Search current word",
      })

      keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
        desc = "Search on current file",
      })
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        update_debounce     = 5000,

        attach_to_untracked = false,
        signcolumn          = true,
        numhl               = false,
        linehl              = false,
        word_diff           = false,

        watch_gitdir        = {
          interval = 5000,
          enable = false
        },
      })
    end
  },

  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "go",
          "rust",
          "javascript",
          "typescript",
          "sql",
        },
        auto_install = true,
        highlight = {
          enable = true
        },
        indent = {
          enable = true
        },
      })
    end,
  },

  -- Files
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 50,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          api.config.mappings.default_on_attach(bufnr)

          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          -- Custom Keymap
          vim.keymap.set("n", "<R>", api.tree.reload, opts("Refresh"))
          vim.keymap.set("n", "<Tab>", api.tree.toggle, opts("Toggle"))
        end,
      })

      keymap.set("n", "<tab>", "<cmd>NvimTreeToggle<cr>", { silent = true, noremap = true })
      keymap.set("n", "<leader>f", "<cmd>NvimTreeFindFile<cr>", { silent = true, noremap = true })
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Comments
  {
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup()
    end,
  },

  -- Languages / LSP
  {
    "neovim/nvim-lspconfig",
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          -- rust_analyzer is deliberately not managed by Mason: see the
          -- rust_analyzer configuration below.
          "protols",
          "gopls",
        },
        automatic_installation = true,
      })

      require("mason-nvim-dap").setup({
        ensure_installed = {
          "delve",
        },
        automatic_installation = true,
      })
    end,
  },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },

  -- Formatters
  {
    "stevearc/conform.nvim",
    event = {
      "BufWritePre",
    },
    cmd = {
      "ConformInfo",
    },
    keys = {
      {
        "<leader>fa",
        function()
          require("conform").format({
            async = true,
          })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = {
          "stylua",
        },
        rust = {
          "rustfmt",
        },
        javascript = {
          "oxfmt",
        },
        javascriptreact = {
          "oxfmt",
        },
        typescript = {
          "oxfmt",
        },
        typescriptreact = {
          "oxfmt",
        },
        json = {
          "oxfmt",
        },
        jsonc = {
          "oxfmt",
        },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_after_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters = {
        oxfmt = {
          cwd = function(_, ctx)
            return vim.fs.root(ctx.dirname, {
              {
                "oxfmt.editor.config.ts"
              },
              {
                ".oxfmtrc.json",
                ".oxfmtrc.jsonc",
                "oxfmt.config.ts"
              },
              {
                "vite.config.ts",
                "vite.config.js"
              },
            })
          end,

          append_args = function(_, ctx)
            local root = vim.fs.root(ctx.dirname, { "oxfmt.editor.config.ts" })

            if root then
              return { "--config", root .. "/oxfmt.editor.config.ts" }
            end

            return {}
          end,

          env = function(_, ctx)
            local node_bin_dir = node_bin_dir_from_nvmrc(ctx.dirname)

            if node_bin_dir then
              return { PATH = node_bin_dir .. ":" .. vim.env.PATH }
            end

            return nil
          end,
        },
        shfmt = {
          prepend_args = {
            "-i",
            "2",
          },
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("dapui").setup()
      require("dap-go").setup()
      require("nvim-dap-virtual-text").setup()

      -- Automatically open/close UI
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.after.event_initialized.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- Essential Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<leader>dt", function() require('dap-go').debug_test() end, { desc = "Debug: Test" })
    end,
  },

  -- Snippets
  { "L3MON4D3/LuaSnip" },

  -- Autocomplete
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Controversial
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<c-n>",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },

  -- Claude
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
  }
})

-- Define on_attach function for LSP keymaps
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- LSP keymaps (similar to what lsp-zero provided)
  keymap.set("n", "K", vim.lsp.buf.hover, opts)
  keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
  keymap.set("n", "gr", vim.lsp.buf.references, opts)
  keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
  keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)

  -- Format through conform with LSP formatting only as fallback
  keymap.set({ "n", "x" }, "<F3>", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
  end, opts)

  keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
  keymap.set("n", "gl", vim.diagnostic.open_float, opts)
  keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  -- Handle JS/TS formatting with conform + oxfmt
  if client.name == "tsc" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  keymap.set("n", "<leader>rl", "<cmd>lua vim.diagnostic.reset()<CR>", opts)
end

-- Get capabilities from cmp_nvim_lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function find_typescript_lsp_binary(root_dir)
  local dir = root_dir

  while dir do
    for _, name in ipairs({ "tsc-native", "tsgo", "tsc" }) do
      local candidate = vim.fs.joinpath(dir, "node_modules", ".bin", name)

      if vim.fn.executable(candidate) == 1 then
        return candidate
      end
    end

    local parent = vim.fs.dirname(dir)

    if parent == dir then
      break
    end

    dir = parent
  end

  return "tsc"
end

vim.lsp.config("tsc", {
  capabilities = capabilities,
  on_attach = on_attach,

  cmd = function(dispatchers, config)
    local root_dir = config.root_dir or vim.fn.getcwd()
    local binary = find_typescript_lsp_binary(root_dir)

    return vim.lsp.rpc.start(
      {
        binary,
        "--lsp",
        "--stdio"
      },
      dispatchers,
      {
        cwd = root_dir,
      }
    )
  end,

  root_dir = function(bufnr, on_dir)
    local root_dir = vim.fs.root(bufnr, {
      "pnpm-lock.yaml",
      "package-lock.json",
      "yarn.lock",
      ".git",
    })

    on_dir(root_dir or vim.fn.getcwd())
  end,

  reuse_client = function(client, config)
    return client.name == config.name
  end,

  init_options = {
    preferences = {
      importModuleSpecifierPreference = "relative",
    },
  },

  settings = {
    typescript = {
      tsserver = {
        maxTsServerMemory = 8192,
        maxMemory = 8192,
      },
    },
  },

  -- Silence organize imports command warning
  commands = {
    ["_typescript.didOrganizeImports"] = function() end,
  },
})

-- Enable servers explicitly when configured but not installed via mason.
vim.lsp.enable("tsc")

-- lua_ls configuration
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  on_attach = on_attach,

  settings = {
    Lua = {
      diagnostics = {
        globals = {
          "vim"
        },
      },
    },
  },
})

-- Use the rust-analyzer shipped with the workspace's pinned toolchain.
local function find_rust_toolchain_channel(root_dir)
  local toolchain_file = vim.fs.find(
    { "rust-toolchain.toml", "rust-toolchain" },
    { path = root_dir, upward = true, type = "file" }
  )[1]

  if toolchain_file == nil then
    return nil
  end

  local lines = vim.fn.readfile(toolchain_file)

  if toolchain_file:sub(-5) == ".toml" then
    for _, line in ipairs(lines) do
      local channel = line:match('^%s*channel%s*=%s*"([^"]+)"')

      if channel ~= nil then
        return channel
      end
    end

    return nil
  end

  -- Legacy `rust-toolchain` files contain just the channel name.
  local channel = vim.trim(lines[1] or "")

  if channel == "" then
    return nil
  end

  return channel
end

local function rust_analyzer_cmd(root_dir)
  local channel = find_rust_toolchain_channel(root_dir)

  if channel == nil then
    return { "rust-analyzer" }
  end

  local which = vim.system({ "rustup", "which", "--toolchain", channel, "rust-analyzer" }):wait()

  if which.code ~= 0 then
    vim.notify(
      ("rust-analyzer is not installed for toolchain %s; falling back to the rust-analyzer on PATH.\n"
        .. "Install it with: rustup component add rust-analyzer --toolchain %s"):format(channel, channel),
      vim.log.levels.WARN
    )

    return { "rust-analyzer" }
  end

  return { "rustup", "run", channel, "rust-analyzer" }
end

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  on_attach = on_attach,

  cmd = function(dispatchers, config)
    local root_dir = config.root_dir or vim.fn.getcwd()

    return vim.lsp.rpc.start(rust_analyzer_cmd(root_dir), dispatchers, {
      cwd = root_dir,
    })
  end,

  settings = {
    ["rust-analyzer"] = {
      cargo = { features = "all" },
    },
  },
})

vim.lsp.enable("rust_analyzer")

-- protols configuration
vim.lsp.config("protols", {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- gopls configuration
vim.lsp.config("gopls", {
  capabilities = capabilities,
  on_attach = on_attach,

  settings = {
    gopls = {
      buildFlags = {
        "-tags=integration",
        "-tags=debug",
      },
      directoryFilters = {
        "-node_modules",
        "-.git",
      },
    },
  },
})

-- starpls configuration
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bzl",
    "bazel"
  },

  callback = function(args)
    local bufnr = args.buf
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    -- Skip if buffer is empty or a virtual URI (like fff:// or telescope://)
    if bufname == "" or bufname:match("^%w+://") then
      return
    end

    local starpls_config = {
      name = 'starpls',
      cmd = { 'starpls' },

      -- Pass the root marker function directly to find the workspace path
      root_dir = vim.fs.root(bufnr, { 'WORKSPACE', 'MODULE.bazel', '.git' }),
      settings = {}
    }

    if starpls_config.root_dir then
      vim.lsp.start(starpls_config, {
        bufnr = bufnr,
      })
    end
  end,
})

-- Disable eslint auto-start (auto-discovered by Neovim 0.11+)
vim.lsp.enable("eslint", false)

-- Debounce LSP updates
vim.diagnostic.config({
  update_in_insert = false,
})

-- Autocomplete

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "lazydev", group_index = 0 },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
})
