local M = {}

function M.setup()
  -- Create centered floating window function
  vim.cmd([[
    function! CreateCenteredFloatingWindow()
        let width = min([&columns - 4, max([80, &columns - 20])])
        let height = min([&lines - 4, max([20, &lines - 10])])
        let top = ((&lines - height) / 2) - 1
        let left = (&columns - width) / 2
        let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
        let top = "╭" . repeat("─", width - 2) . "╮"
        let mid = "│" . repeat(" ", width - 2) . "│"
        let bot = "╰" . repeat("─", width - 2) . "╯"
        let lines = [top] + repeat([mid], height - 2) + [bot]
        let s:buf = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
        call nvim_open_win(s:buf, v:true, opts)
        set winhl=Normal:Floating
        let opts.row += 1
        let opts.height -= 2
        let opts.col += 2
        let opts.width -= 4
        call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
        au BufWipeout <buffer> exe 'bw '.s:buf
    endfunction
  ]])

  -- Lightline truncated filename function
  vim.cmd([[
    function! LightlineTruncatedFileName()
    let l:filePath = expand('%')
        if winwidth(0) > 100
            return l:filePath
        else
            return pathshorten(l:filePath)
        endif
    endfunction
  ]])

  -- QuickFix toggle function
  vim.cmd([[
    command -bang -nargs=? QFix call QFixToggle(<bang>0)
    function! QFixToggle(forced)
      if exists("g:qfix_win") && a:forced == 0
        cclose
        unlet g:qfix_win
      else
        copen 10
        let g:qfix_win = bufnr("$")
      endif
    endfunction
  ]])

  -- Toggle mouse function
  vim.cmd([[
    function! ToggleMouse()
        if &mouse == 'a'
            set mouse=
        else
            set mouse=a
        endif
    endfunc
  ]])

  -- Toggle fold function
  vim.cmd([[
    function! ToggleFold()
        let &foldlevel = 100 - &foldlevel
        :normal zz
    endfunc
  ]])

  -- Copy to tmux function
  vim.cmd([[
    function! s:CopyToTmux()
      let [lnum1, col1] = getpos("'<")[1:2]
      let [lnum2, col2] = getpos("'>")[1:2]
      let lines = getline(lnum1, lnum2)
      let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
      let lines[0] = lines[0][col1 - 1:]
      let tempfile = tempname()
      call writefile(lines, tempfile, "b")
      call system('tmux load-buffer '.tempfile)
      call delete(tempfile)
    endfunction
  ]])

  -- Window view save/restore functions
  vim.cmd([[
    function! AutoSaveWinView()
        if !exists("w:SavedBufView")
            let w:SavedBufView = {}
        endif
        let w:SavedBufView[bufnr("%")] = winsaveview()
    endfunction

    function! AutoRestoreWinView()
        let buf = bufnr("%")
        if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
            let v = winsaveview()
            let atStartOfFile = v.lnum == 1 && v.col == 0
            if atStartOfFile && !&diff
                call winrestview(w:SavedBufView[buf])
            endif
            unlet w:SavedBufView[buf]
        endif
    endfunction
  ]])


  -- Check for local override file
  local function file_exists(name)
    local f = io.open(name,"r")
    if f ~= nil then
      io.close(f)
      return true
    else
      return false
    end
  end

  local local_override = os.getenv("HOME") .. "/.vimrc_local.lua"
  if file_exists(local_override) then
    print("import ~/.vimrc_local.lua")
    dofile(local_override)
  end
end

return M
