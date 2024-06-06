-- vim:foldmethod=marker:foldlevel=0:

-- preamble {{{
local keymap = vim.keymap
-- }}}
-- options {{{

-- Nice colors
vim.opt.termguicolors = true

-- Space as leader
vim.g.mapleader = " "

-- Useful for checking options and completing some commands
vim.opt.wildmenu = true

-- Useful when someone else wants to select some text
vim.opt.mouse = "a"

-- Line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- Marker folding
vim.opt.foldmethod = 'marker'

-- Highlight cursor line
vim.opt.cursorline = true

-- Incremental search
vim.opt.incsearch = true

-- Start scrolling before I reach the last visible line
vim.opt.scrolloff = 6

-- Conceals quotes on json files, making them more readable
vim.g.vim_json_syntax_conceal = 1

-- Doesn't show help banner whe navigating through directories
vim.g.netrw_banner = 0

-- Start netrw with hidden files hidden
vim.g.netrw_list_hide = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

-- }}}
-- remaps {{{

-- Window navigation
keymap.set("n", "<leader>wh", "<C-w>h")
keymap.set("n", "<leader>wj", "<C-w>j")
keymap.set("n", "<leader>wk", "<C-w>k")
keymap.set("n", "<leader>wl", "<C-w>l")

-- Window spliting
keymap.set("n", "<leader>ws", "<C-w>s")
keymap.set("n", "<leader>wv", "<C-w>v")
keymap.set("n", "<leader>w=", "<C-w>=")
keymap.set("n", "<leader>wq", "<C-w>q")
keymap.set("n", "<leader>ww", "<C-w>w")

-- Open current window in a newtab
keymap.set("n", "<leader>wt", ":<C-u>tabnew %<Enter>", { silent = true })

-- Saving without modifier keys
keymap.set("n", "<leader>fw", ":<C-u>w<CR>", { silent = true })

-- Make current buffer's file executable
keymap.set("n", "<leader>fx", ":<C-u>!chmod +x %<CR>")

-- Cleaning search highlights
keymap.set("n", "<ESC>", ":<C-u>noh<CR>", { silent = true })

-- Easier folding/unfolding
keymap.set("n", "<TAB>", "za")

-- Open config on new tab
keymap.set("n", "<leader>c", ":<C-u>tabnew $MYVIMRC<CR>")

-- New tab
keymap.set("n", "<leader>t", ":<C-u>tabnew<CR>")

-- Open file explorer on current buffer
keymap.set("n", "<leader>e", ":<C-u>Ex<CR>")

-- Start substitution
keymap.set("n", "<leader>s", ":%s/")
keymap.set("v", "<leader>s", ":s/")

-- Easier send to clipboard
keymap.set("n", "<leader>y", "\"+y", { silent = true })
keymap.set("v", "<leader>y", "\"+y", { silent = true })

-- Enter capture on command line mode (for easier captured substitutions)
keymap.set("c", "<C-.>", "\\(.\\+\\)")

-- Wrap current paragraph
keymap.set("n", "<leader>i", "gwip", { silent = true })

-- }}}
-- plugin manager/plugins {{{

-- lazy.nvim initialization {{{
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
-- }}}
-- plugins {{{
require("lazy").setup({
    -- Other
    "nvim-treesitter/nvim-treesitter",
    {
        "nvim-telescope/telescope.nvim", tag = "0.1.5", branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    
    "sheerun/vim-polyglot",         -- Supports many languages, including org and json
    "gmoe/vim-faust",               -- Faust language for audio plugin creation
    "terrastruct/d2-vim",           -- D2 lang for fancy diagrams
    "tpope/vim-commentary",         -- Useful to comment/uncomment lines and blocks
    "lilydjwg/colorizer",           -- Renders colors (like #fafaca). Pretty.
    "mbbill/undotree",              -- Better undo handling
    "jiangmiao/auto-pairs",         -- Closes bracket/quote/parenthesis whenever one is opened
    "tpope/vim-endwise",            -- Puts an 'end' on lua/ruby blocks
    "tpope/vim-fugitive",           -- Git blame
    "mhinz/vim-signify",            -- Nice to navigate between changes with '[c'
    "mattn/emmet-vim",              -- Easier writing html
    "terryma/vim-multiple-cursors", -- Fancy multicursors. Not used much, but nice to have
    "junegunn/goyo.vim",            -- Zen writing experience
    "junegunn/limelight.vim",       -- Highlight blocks of code for better focus

    -- Colorschemes
    "AhmedAbdulrahman/aylin.vim",
    "whatyouhide/gotham",
    "dracula/vim",
    "nelstrom/vim-mac-classic-theme",
    "rebelot/kanagawa.nvim",

    -- LSP related plugins
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-nvim-lua'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
    {'saadparwaiz1/cmp_luasnip'},
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'}
})
-- }}}

-- }}}
-- Telescope config/keymap {{{
local telescope = require("telescope.builtin")
keymap.set("n", "<leader>ff", telescope.find_files, {})
keymap.set("n", "<leader>fg", telescope.live_grep, {})
keymap.set("n", "<leader>fb", telescope.buffers, {})
keymap.set("n", "<leader>fh", telescope.help_tags, {})

local telescope_actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-n>"] = false,
                ["<C-p>"] = false,
                ["<C-j>"] = telescope_actions.move_selection_next,
                ["<C-k>"] = telescope_actions.move_selection_previous,
            }
        }
    }
})
-- }}}
-- LSP setup {{{
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    local set = vim.keymap.set

    -- TODO: keybinds taken from Primeagen config, test to see if they work for me
    -- default mappings are:
    -- map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    -- map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    -- map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    -- map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    -- map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    -- map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    -- map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    -- map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
    -- map('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    -- map('x', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    -- map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')

    set("n", "gd", '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    set("n", "K", '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    set("n", "<leader>vws", '<cmd>lua vim.lsp.buf.workspace_symbol()<cr>', opts)
    set("n", "<leader>vd", '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    set("n", "[d", '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    set("n", "]d", '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    set("n", "<leader>vca", '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    set("n", "<leader>vrr", '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    set("n", "<leader>vrn", '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    set("i", "<C-h>", '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {'tsserver', 'rust_analyzer', 'zls'},
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end
    }
})

-- }}}
-- cmp completion setup {{{
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "buffer", keyword_length = 3 },
        { name = "luasnip", keyword_length = 2 }
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        -- 'Enter' key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({select = false}),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        -- TODO: configure this with super tab like mapping
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),

        -- Scroll up and down in the completion documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- Use C-j, C-k instead of C-n, C-p to navigate
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select)
    })
})

-- }}}
-- other {{{

-- I don't want numbered lines on terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
    desc = "Hide line numbers on terminal",
    callback = function(event)
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.foldcolumn = "2"
    end
})

-- Beautiful colorscheme
vim.cmd [[colorscheme aylin]]
-- }}}
