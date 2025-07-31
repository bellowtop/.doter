local M = {}

function M.setup()
  -- File type settings
  vim.cmd([[
    filetype plugin indent on

    autocmd FileType qf wincmd J
    autocmd BufRead,BufNewFile *.json set filetype=json
    autocmd BufNewFile,BufRead *.webapp set filetype=json
    autocmd BufNewFile,BufRead *.jshintrc set filetype=json
    autocmd BufNewFile,BufRead *.eslintrc set filetype=json
    autocmd BufNewFile,BufReadPost *.go set shiftwidth=4 softtabstop=4 expandtab!
    autocmd BufNewFile,BufReadPost *.cpp set shiftwidth=4 tabstop=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.cc  set shiftwidth=4 tabstop=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.c   set shiftwidth=4 tabstop=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.hh  set shiftwidth=4 tabstop=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.h   set shiftwidth=4 tabstop=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.coffee set shiftwidth=2 softtabstop=2
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
    autocmd BufWritePost *.coffee silent make!
    autocmd QuickFixCmdPost * nested cwindow | redraw!
    autocmd BufNewFile,BufReadPost *.js set shiftwidth=4 softtabstop=4
    autocmd BufNewFile,BufRead *.js set filetype=javascript.jsx
    autocmd BufNewFile,BufRead *.ejs set filetype=html
    autocmd BufNewFile,BufRead *.qml set filetype=qml
    autocmd FileType scss set iskeyword+=-
    autocmd BufNewFile,BufReadPost *.scss set shiftwidth=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.sh set shiftwidth=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.sls set shiftwidth=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.lua set shiftwidth=4 softtabstop=4
    autocmd BufNewFile,BufReadPost *.json set shiftwidth=4 softtabstop=4
  ]])

  -- Disable some mappings for specific file types
  vim.cmd([[
    autocmd FileType vista,NvimTree noremap <buffer> <c-j> <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <c-i> <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <c-o> <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <c-h> <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <c-l> <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <c-e> <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <Leader>L <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <Leader>q <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <Leader>x <nop>
    autocmd FileType vista,NvimTree noremap <buffer> <Leader>j <nop>
  ]])

  -- EasyMotion diagnostic management
  vim.cmd([[
    autocmd User EasyMotionPromptBegin silent! :lua vim.diagnostic.disable()
    autocmd User EasyMotionPromptEnd   silent! :call timer_start(5000, { tid -> execute(':lua vim.diagnostic.enable()')})
  ]])

  -- BQF settings
  vim.cmd([[
    augroup BQFSettings
        autocmd!
        autocmd FileType qf nnoremap <buffer><silent> q :cclose<cr>
    augroup END
  ]])

  -- Previm settings
  vim.cmd([[
    augroup PrevimSettings
        autocmd!
        autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
    augroup END
  ]])

  -- Color scheme autocmd
  vim.cmd([[
    augroup MyColors
        autocmd!
        autocmd ColorScheme * call MyHighlights()
    augroup END
  ]])

  -- Lightline update
  vim.cmd([[
    autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
  ]])

  -- Window view save/restore
  vim.cmd([[
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
  ]])

  -- QuickFix toggle
  vim.cmd([[
    augroup QFixToggle
     autocmd!
     autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
     autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
    augroup END
  ]])

  -- Remove trailing spaces on save
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
  })

  -- Claude Code file tree keymaps
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "NvimTree", "neo-tree", "oil" },
    callback = function()
      vim.keymap.set("n", "<leader>at", "<cmd>ClaudeCodeTreeAdd<cr>", { desc = "Add file", buffer = true })
    end,
  })
end

return M
