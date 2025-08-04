-- ═══════════════════════════════════════════════════════════════════════════════
-- Neovim Configuration - Modular Structure
-- ═══════════════════════════════════════════════════════════════════════════════

-- Install and setup plugins first
local install_plugins = require('config.plugins').setup()

-- If plugins are being installed, exit early to avoid errors
if install_plugins then
  return
end

-- Load core configuration modules
require('config.options').setup()     -- Vim options and global settings
require('config.functions').setup()   -- Custom functions and utilities
require('config.highlights')          -- Color scheme and highlights
require('config.autocmds').setup()    -- Autocommands
require('config.keymaps').setup()     -- Key mappings
require('config.proxy').setup()       -- SetProxy

-- Load LSP configuration
require('config.lsp').setup()         -- Language Server Protocol setup

-- Load plugin configurations
require('plugins.telescope').setup()      -- Telescope fuzzy finder
require('plugins.nvim-cmp').setup()       -- Completion engine
require('plugins.nvim-tree').setup()      -- File explorer
require('plugins.treesitter').setup()     -- Syntax highlighting
require('plugins.indent-blankline').setup() -- Indent guides with rainbow colors
require('plugins.bqf').setup()            -- bqf
require('plugins.claudecode').setup()     -- claudecode
require('plugins.cscope').setup()         -- cscope
require('plugins.kommentary').setup()     -- kommentary
require('plugins.trouble').setup()        -- Trouble.nvim for better diagnostics display

-- print("✓ Neovim configuration loaded successfully!")
