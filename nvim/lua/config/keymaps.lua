local M = {}

local function disable_diagnostic_temp_then_reactivate(c)
  vim.diagnostic.disable()
  vim.cmd.execute(c)
  vim.diagnostic.enable()
end

function M.setup()
  local keymap = vim.keymap.set

  -- Leader key
  vim.g.mapleader = " "

  -- AI/Claude Code keymaps
  keymap("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
  keymap("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
  keymap("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
  keymap("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
  keymap("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
  keymap("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
  keymap("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })

  -- Claude Code diff management
  keymap("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
  keymap("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

  -- Easymotion
  vim.api.nvim_set_keymap("n", "f", "<Plug>(easymotion-bd-w)", { noremap=true, silent=true })

  -- Telescope
  local builtin = require('telescope.builtin')
  local file_browser = require("telescope").extensions.file_browser
  local recent_files = require("telescope").extensions.recent_files
  local telescope_dir = require("telescope").extensions.dir

  local custom_find_files = function()
    builtin.find_files {
      find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
      previewer = false
    }
  end

  keymap('n', '<leader>f', custom_find_files, {})
  keymap('n', '<leader>g', builtin.live_grep, {})
  keymap('n', '<leader>G', builtin.grep_string, {})
  keymap('n', '<leader>b', builtin.buffers, {})
  keymap('n', '<leader>s', builtin.lsp_document_symbols, {})
  keymap('n', '<leader>p', file_browser.file_browser, {})
  keymap('n', 'F', custom_find_files, {})
  keymap('n', '<leader>F', recent_files.pick, {})
  keymap('n', '<leader>df', telescope_dir.find_files, {})
  keymap('n', '<leader>dg', telescope_dir.live_grep, {})

  -- NvimTree
  local function find_and_focus_file()
    require('nvim-tree.api').tree.find_file({
      focus = true,
      open = true,
    })
  end

  vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<leader>r", ":NvimTreeRefresh<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<leader>N", ":NvimTreeFindFile<CR>", { noremap = true })
  keymap('n', '@', find_and_focus_file, { noremap = true })

  -- Vista
  vim.api.nvim_set_keymap("n", "<Leader>v", ":Vista!!<CR>", { noremap = true })

  -- Comments
  vim.api.nvim_set_keymap("n", "<A-/>", "<Plug>kommentary_line_default", {})
  vim.api.nvim_set_keymap("v", "<A-/>", "<Plug>kommentary_visual_default", {})
  vim.api.nvim_set_keymap("i", "<A-/>", "<Plug>kommentary_line_default", {})

  -- CtrlSF
  vim.api.nvim_set_keymap("n", "<Leader>m", "<Plug>CtrlSFCwordPath", { noremap = true })
  vim.api.nvim_set_keymap("v", "<Leader>m", "<Plug>CtrlSFVwordExec<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>O", ":CtrlSFOpen<CR> ", { noremap = true })

  -- Prettier
  vim.api.nvim_set_keymap("n", "<Leader>R", ":<Plug>(Prettier):retab", { noremap = true })

  -- Insert mode emacs-like keybindings
  vim.api.nvim_set_keymap("i", "<C-d>", "<C-o>x", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-e>", "<C-o>$", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-a>", "<C-o>^", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-b>", "<Left>", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-f>", "<Right>", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-k>", "<C-o>D", { noremap = true })
  vim.api.nvim_set_keymap("i", "<M-k>", "<C-o>d0", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-t>", "<C-o>O", { noremap = true })
  vim.api.nvim_set_keymap("i", "<M-BS>", "<C-w>", { noremap = true })

  -- Advanced insert mode navigation
  keymap("i", "<M-d>", function() disable_diagnostic_temp_then_reactivate('"normal dea"') end, { noremap = true })
  keymap("i", "<M-f>", function() disable_diagnostic_temp_then_reactivate('"normal wa"') end, { noremap = true })
  keymap("i", "<M-b>", function() disable_diagnostic_temp_then_reactivate('"normal ba"') end, { noremap = true })
  keymap("i", "<C-_>", function() disable_diagnostic_temp_then_reactivate('"normal ua"') end, { noremap = true })
  keymap("i", "<C-l>", function() disable_diagnostic_temp_then_reactivate('"normal zza"') end, { noremap = true })
  keymap("i", "<C-n>", function() disable_diagnostic_temp_then_reactivate('"normal j"') end, { noremap = true })
  keymap("i", "<C-p>", function() disable_diagnostic_temp_then_reactivate('"normal k"') end, { noremap = true })

  -- Normal mode word navigation
  keymap("n", "<M-d>", function() disable_diagnostic_temp_then_reactivate('"normal de"') end, { noremap = true })
  keymap("n", "<M-f>", function() disable_diagnostic_temp_then_reactivate('"normal w"') end, { noremap = true })
  keymap("n", "<M-b>", function() disable_diagnostic_temp_then_reactivate('"normal b"') end, { noremap = true })

  -- Quick escape
  vim.api.nvim_set_keymap("i", "<C-q>", "<Esc>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<C-q>", "a", { noremap = true })

  -- Buffer navigation
  keymap("n", "<Leader>h", "<cmd>bprev<cr>", { desc = "Previous buffer" })
  keymap("n", "<Leader>l", "<cmd>bnext<cr>", { desc = "Next buffer" })
  keymap("n", "<C-s>h", "<cmd>bprev<cr>", { desc = "Previous buffer" })
  keymap("n", "<C-s>l", "<cmd>bnext<cr>", { desc = "Next buffer" })
  keymap("n", "<Leader>k", "<cmd>Bclose<cr>", { desc = "Close buffer" })
  keymap("n", "<Leader>K", "<cmd>BufOnly<cr><cmd>bfirst<cr>", { desc = "Close all other buffers" })

  -- Window management
  keymap("n", "<C-h><C-h>", "<cmd>only<cr>", { desc = "Close other windows" })

  -- Window management
  vim.api.nvim_set_keymap("n", "<Leader>x", "<C-w>c", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>w", "<C-w>", { noremap = true })

  -- Utility mappings
  vim.api.nvim_set_keymap("n", "<Leader>L", ":set invnumber<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>U", ":g/^$/d<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>R", ":retab<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>.", ":@:<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<leader>;", ":nohlsearch<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>c", ":let @+=expand('%:p')<CR>", { noremap = true })

  -- Enhanced navigation
  vim.api.nvim_set_keymap("n", "J", "mzJ`z", { noremap = true })
  vim.api.nvim_set_keymap("n", "H", "^", { noremap = true })
  vim.api.nvim_set_keymap("n", "L", "$", { noremap = true })
  vim.api.nvim_set_keymap("v", "H", "^", { noremap = true })
  vim.api.nvim_set_keymap("v", "L", "g_", { noremap = true })
  vim.api.nvim_set_keymap("o", "H", "^", { noremap = true })
  vim.api.nvim_set_keymap("o", "L", "g_", { noremap = true })

  vim.api.nvim_set_keymap("n", "m", "%", { noremap = true })
  vim.api.nvim_set_keymap("v", "m", "%", { noremap = true })

  vim.api.nvim_set_keymap("n", "<C-l>", "zz", { noremap = true })

  -- Save shortcuts
  vim.api.nvim_set_keymap("n", "<C-j>", ":w<CR>", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-j>", "<ESC>:w<CR>", { noremap = true })
  vim.api.nvim_set_keymap("v", "<C-j>", "<ESC>:w<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>j", ":w<CR>", { noremap = true })

  -- Visual mode copy
  vim.api.nvim_set_keymap("v", "c", "y", { noremap = true })

  -- Scrolling
  vim.api.nvim_set_keymap("n", ";", "<C-d>", { noremap = true })
  vim.api.nvim_set_keymap("n", "'", "<C-u>", { noremap = true })
  vim.api.nvim_set_keymap("v", ";", "<C-d>", { noremap = true })
  vim.api.nvim_set_keymap("v", "'", "<C-u>", { noremap = true })

  -- Tab management
  vim.api.nvim_set_keymap("n", "th", ":tabfirst<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "tj", ":tabnext<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "tk", ":tabprev<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "tl", ":tablast<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "tt", ":tabedit<Space>", { noremap = true })
  vim.api.nvim_set_keymap("n", "tn", ":tabnext<Space>", { noremap = true })
  vim.api.nvim_set_keymap("n", "tm", ":tabm<Space>", { noremap = true })
  vim.api.nvim_set_keymap("n", "td", ":tabclose<CR>", { noremap = true })

  -- Paste without yanking
  vim.api.nvim_set_keymap("v", "p", '"_dp', { noremap = true })
  vim.api.nvim_set_keymap("v", "P", '"_dP', { noremap = true })

  -- Buffer switching
  vim.api.nvim_set_keymap("n", ",b", '<C-6>', { noremap = true })
  vim.api.nvim_set_keymap("n", "<Leader>o", ':ClangdSwitchSourceHeader<CR>', { noremap = true })

  -- Escape sequences
  vim.api.nvim_set_keymap("n", "<C-g>", "<ESC><ESC><ESC>", { noremap = true })
  vim.api.nvim_set_keymap("i", "<C-g>", "<ESC><ESC><ESC>", { noremap = true })
  vim.api.nvim_set_keymap("v", "<C-g>", "<ESC><ESC><ESC>", { noremap = true })

  -- Search and replace
  vim.api.nvim_set_keymap("v", '<C-r>', '"hy:%sno#<C-r>h##gc<left><left><left>', { noremap = true })
  vim.api.nvim_set_keymap("n", 'S', ':%sno##g<LEFT><LEFT>', { noremap = true })
  vim.api.nvim_set_keymap("i", '<C-y>', '<C-r>"', { noremap = true })
  vim.api.nvim_set_keymap("v", '//', 'y/<C-R>"<CR>"', { noremap = true })

  -- Command line emacs bindings
  vim.api.nvim_set_keymap("c", "<C-A>", "<Home>", { noremap = true })
  vim.api.nvim_set_keymap("c", "<C-F>", "<Right>", { noremap = true })
  vim.api.nvim_set_keymap("c", "<C-B>", "<Left>", { noremap = true })
  vim.api.nvim_set_keymap("c", "<Esc><Left>", "<S-Left>", { noremap = true })
  vim.api.nvim_set_keymap("c", "<Esc>b", "<S-Left>", { noremap = true })
  vim.api.nvim_set_keymap("c", "<Esc><Right>", "<S-Right>", { noremap = true })
  vim.api.nvim_set_keymap("c", "<Esc>f", "<S-Right>", { noremap = true })
  vim.api.nvim_set_keymap("c", "<Esc><BS>", "<C-W>", { noremap = true })
  vim.api.nvim_set_keymap("c", "w!!", "%!sudo tee > /dev/null %", { noremap = true })

  -- Window resizing
  vim.api.nvim_set_keymap("n", ">", ':exe "vertical resize +20"<CR>', { noremap = true })
  vim.api.nvim_set_keymap("n", "<", ':exe "vertical resize -20"<CR>', { noremap = true })

  -- Select mode
  vim.api.nvim_set_keymap("s", "<BS>", "<BS>i", { noremap = true })
  vim.api.nvim_set_keymap("s", "<C-k>", "<BS>i<C-o>D", { noremap = true })

  -- Text objects
  vim.api.nvim_set_keymap("v", "al", ":<C-U>normal 0v$h<CR>", { noremap = true })
  vim.api.nvim_set_keymap("v", "il", ":<C-U>normal ^vg_<CR>", { noremap = true })
  vim.api.nvim_set_keymap("o", "al", ":normal val<CR>", { noremap = true })
  vim.api.nvim_set_keymap("o", "il", ":normal vil<CR>", { noremap = true })

  -- Alt navigation
  vim.api.nvim_set_keymap("n", "<A-j>", "<C-e>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<A-k>", "<C-y>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<A-h>", ":bprev<CR>", { noremap = true })
  vim.api.nvim_set_keymap("n", "<A-l>", ":bnext<CR>", { noremap = true })

  -- Disable some keys
  keymap("n", "K", "<nop>", { desc = "Disabled" })
  keymap("n", "Q", "<nop>", { desc = "Disabled" })

  -- CMP completion
  vim.keymap.set("i", "<C-Tab>", function() require('cmp').mapping.complete() end, { noremap = true })

  -- Function key mappings (moved from init.lua)
  local functions = require('config.functions')
  keymap("n", "<F3>", "<cmd>set wrap!<cr>", { desc = "Toggle line wrap" })
  keymap("n", "<F4>", functions.toggle_mouse, { desc = "Toggle mouse" })
  keymap("n", "<F6>", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
  keymap("n", "<F8>", "*", { desc = "Search word under cursor" })
  keymap("n", "zm", functions.toggle_fold, { desc = "Toggle fold level" })
  keymap("n", "zo", "zA", { desc = "Toggle fold" })
  keymap("v", "Y", functions.copy_to_tmux, { silent = true, desc = "Copy to tmux" })

  -- Copy file path
  keymap("n", "<leader>PP", function()
    local filepath = vim.fn.expand('%:p')
    vim.fn.setreg('+', filepath)
    print('Copied to clipboard: ' .. filepath)
  end, { desc = "Copy absolute file path to clipboard" })
end

return M
