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

-- Utility methods

local function first(bufnr, ...)
  local conform = require("conform")

  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end

  return select(1, ...)
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
      { "mason-org/mason.nvim" },
      { "mason-org/mason-lspconfig.nvim" },
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
          lsp_format = "fallback",
        },
        javascript = function(bufnr)
          return {
            "biome",
            "biome-organize-imports",
            lsp_format = "fallback",
          }
        end,
        typescript = function(bufnr)
          return {
            "biome",
            "biome-organize-imports",
            lsp_format = "fallback",
          }
        end,
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 2000,
      },
      formatters = {
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

  -- Autocomplete
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },

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

  -- AI
  {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- for example
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "stevearc/dressing.nvim",
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
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

require("lspconfig").gopls.setup({
  settings = {
    gopls = {
      buildFlags = {
        "-tags=integration"
      }
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "biome",
    "lua_ls",
    "rust_analyzer",
  },
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  keymap.set("n", "<leader>rl", "<cmd>lua vim.diagnostic.reset()<CR>", { buffer = bufnr })
end)

lsp.configure("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

lsp.setup()

require("typescript-tools").setup({
  settings = {
    separate_diagnostic_server = false,
    tsserver_max_memory = "auto",
    tsserver_plugins = {
      "@styled/typescript-styled-plugin",
    },
    tsserver_file_preferences = {
      includeCompletionsForModuleExports = true,
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      quotePreference = "auto",
    },
  },
})

-- Formatting

require("conform").setup()

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
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
