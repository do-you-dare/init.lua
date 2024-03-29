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

-- Incremental search
vim.opt.incsearch = true

-- Start scrolling before I reach the last visible line
vim.opt.scrolloff = 6

-- Conceals quotes on json files, making them more readable
vim.g.vim_json_syntax_conceal = 1

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

-- Cleaning search highlights
keymap.set("n", "<ESC>", ":<C-u>noh<CR>", { silent = true })

-- Easier folding/unfolding
keymap.set("n", "<TAB>", "za")
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

    -- The closer to org mode I've found on vim
    {
        "nvim-neorg/neorg",
        build = "Neorg sync-parsers"
    }
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
    mappings = {
        i = {
            ["<C-n>"] = false,
            ["<C-p>"] = false,
            ["<C-j>"] = telescope_actions.move_selection_next,
            ["<C-k>"] = telescope_actions.move_selection_previous,
        }
    }
})
-- }}}
-- Neorg config {{{
require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = { notes = "~/notes" }
        }
    }
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
