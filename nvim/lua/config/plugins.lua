local M = {}

function M.setup()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  local install_plugins = false

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    print('Installing packer...')
    local packer_url = 'https://github.com/wbthomason/packer.nvim'
    vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
    print('Done.')

    vim.cmd('packadd packer.nvim')
    install_plugins = true
  end

  require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'

    -- Colorschemes
    use 'Mofiqul/vscode.nvim'

    -- File management
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-tree/nvim-tree.lua'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'kevinhwang91/nvim-bqf'
    use {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    }
    use 'p00f/clangd_extensions.nvim'
    use "lukas-reineke/lsp-format.nvim"

    -- Treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'nvim-treesitter/playground'}
    use {
      requires = { "nvim-treesitter/nvim-treesitter" },
      "Badhi/nvim-treesitter-cpp-tools",
    }

    -- Diagnostics
    use "folke/trouble.nvim"

    -- Telescope
    use 'nvim-lua/plenary.nvim'
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope.nvim', tag =  '0.1.4' }
    use { "nvim-telescope/telescope-file-browser.nvim" }
    use { "smartpde/telescope-recent-files" }
    use {
      "princejoogie/dir-telescope.nvim",
      requires = {"nvim-telescope/telescope.nvim"},
      config = function() end,
    }

    -- Code navigation and search
    use { "dhananjaylatkar/cscope_maps.nvim" }
    use 'dyng/ctrlsf.vim'
    use 'liuchengxu/vista.vim'

    -- Text editing
    use 'Konfekt/FastFold'
    use 'tmhedberg/SimpylFold'
    use 'jiangmiao/auto-pairs'
    use 'terryma/vim-multiple-cursors'
    use 'easymotion/vim-easymotion'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use { 'prettier/vim-prettier', run = 'npm install' }
    use 'schickling/vim-bufonly'
    use 'rbgrouleff/bclose.vim'

    -- use 'Yggdroot/indentLine'
    use "lukas-reineke/indent-blankline.nvim"


    -- Language support
    use 'fatih/vim-go'
    use 'rust-lang/rust.vim'
    use 'elzr/vim-json'
    use 'ziglang/zig.vim'
    use 'keith/swift.vim'
    use {
      "pmizio/typescript-tools.nvim",
      requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    }

    -- Themes
    use 'flazz/vim-colorschemes'
    use 'folke/tokyonight.nvim'
    use 'wojciechkepka/bogster'

    -- UI
    use 'itchyny/lightline.vim'
    use 'mengelbrecht/lightline-bufferline'

    -- Utils
    use 'folke/which-key.nvim'
    use 'airblade/vim-rooter'
    use 'tpope/vim-abolish'
    use 'tpope/vim-fugitive'

    -- Markdown
    use 'godlygeek/tabular'
    use 'plasticboy/vim-markdown'
    use 'mzlogin/vim-markdown-toc'
    use 'kannokanno/previm'

    -- Completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'

    -- Comments
    use 'b3nj5m1n/kommentary'

    -- AI
    use {
      "coder/claudecode.nvim"
    }

    if install_plugins then
      require('packer').sync()
    end
  end)

  return install_plugins
end

return M
