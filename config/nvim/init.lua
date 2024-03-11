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
vim.opt.laststatus = 2
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
          telescope = {
            enabled = true,
          },
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
    },
    opt = true,
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
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
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      require("telescope").setup({
        defaults = {
          cache_picker = false,
          mappings = {
            i = {
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
            },
          },
          history = {
            path = "~/.local/share/nvim/telescope_history.sqlite3",
            limit = 100,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
              },
            },
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("smart_history")

      keymap.set("n", "<C-p>", builtin.find_files)
      keymap.set("n", "<leader>ff", builtin.find_files)
      keymap.set("n", "<leader>fF", builtin.git_files)
      keymap.set("n", "<leader>fb", builtin.buffers)
      keymap.set("n", "<leader>fh", builtin.help_tags)
      keymap.set("n", "<leader>fo", builtin.oldfiles)

      keymap.set("n", "<leader>fg", function()
        telescope.extensions.live_grep_args.live_grep_args()
      end)
      keymap.set("v", "<leader>fv", require("telescope-live-grep-args.shortcuts").grep_visual_selection)
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = "nvim-telescope/telescope.nvim",
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
  },
  {
    "nvim-telescope/telescope-smart-history.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "kkharji/sqlite.lua" },
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
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
  { "lewis6991/gitsigns.nvim" },

  -- Syntax
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

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

  -- Languages
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      separate_diagnostic_server = false,
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
  },

  -- Autocomplete
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },

  -- Controversial
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "smoka7/hydra.nvim",
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
})

-- LSP Setup
local lsp = require("lsp-zero").preset({
  name = "recommended",
  manage_nvim_cmp = {
    set_extra_mappings = true,
    set_format = true,
    documentation_window = true,
  },
})

local null_ls = require("null-ls")

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  keymap.set("n", "<leader>rl", "<cmd>lua vim.diagnostic.reset()<CR>", { buffer = bufnr })
end)

lsp.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ["null-ls"] = { "lua" },
  },
})

lsp.ensure_installed({
  "rust_analyzer",
  "lua_ls",
  "eslint",
})

lsp.configure("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

lsp.configure("eslint", {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

lsp.setup()

require("typescript-tools").setup({
  settings = {
    tsserver_plugins = {
      "@styled/typescript-styled-plugin",
    },
  },
})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
  },
})

require("mason-null-ls").setup({
  ensure_installed = {},
  automatic_installation = true,
})

-- Autocomplete

local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
})
