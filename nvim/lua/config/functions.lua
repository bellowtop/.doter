local M = {}

-- Create centered floating window
function M.create_centered_floating_window()
  local width = math.min(vim.o.columns - 4, math.max(80, vim.o.columns - 20))
  local height = math.min(vim.o.lines - 4, math.max(20, vim.o.lines - 10))
  local top = math.floor((vim.o.lines - height) / 2) - 1
  local left = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = 'editor',
    row = top,
    col = left,
    width = width,
    height = height,
    style = 'minimal'
  }

  -- Create border
  local top_line = "╭" .. string.rep("─", width - 2) .. "╮"
  local mid_line = "│" .. string.rep(" ", width - 2) .. "│"
  local bot_line = "╰" .. string.rep("─", width - 2) .. "╯"

  local lines = { top_line }
  for _ = 1, height - 2 do
    table.insert(lines, mid_line)
  end
  table.insert(lines, bot_line)

  -- Create border buffer
  local border_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(border_buf, 0, -1, true, lines)
  local border_win = vim.api.nvim_open_win(border_buf, true, opts)

  -- Set border window highlight
  vim.wo[border_win].winhighlight = 'Normal:Floating'

  -- Create content window
  opts.row = opts.row + 1
  opts.height = opts.height - 2
  opts.col = opts.col + 2
  opts.width = opts.width - 4

  local content_buf = vim.api.nvim_create_buf(false, true)
  local content_win = vim.api.nvim_open_win(content_buf, true, opts)

  -- Auto-close border when content buffer is closed
  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = content_buf,
    callback = function()
      if vim.api.nvim_buf_is_valid(border_buf) then
        vim.api.nvim_buf_delete(border_buf, { force = true })
      end
    end,
    once = true
  })

  return content_win, border_win
end

-- Lightline truncated filename
function M.lightline_truncated_filename()
  local filepath = vim.fn.expand('%')
  if vim.fn.winwidth(0) > 100 then
    return filepath
  else
    return vim.fn.pathshorten(filepath)
  end
end

-- QuickFix toggle
function M.qfix_toggle(forced)
  forced = forced or false

  -- Check if quickfix window is open
  local qf_winid = nil
  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'quickfix' then
      qf_winid = win
      break
    end
  end

  if qf_winid and not forced then
    vim.cmd('cclose')
  else
    vim.cmd('copen 10')
  end
end

-- Toggle mouse
function M.toggle_mouse()
  if vim.o.mouse == 'a' then
    vim.o.mouse = ''
  else
    vim.o.mouse = 'a'
  end
end

-- Toggle fold
function M.toggle_fold()
  vim.o.foldlevel = 100 - vim.o.foldlevel
  vim.cmd('normal! zz')
end

-- Copy to tmux
function M.copy_to_tmux()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lnum1, col1 = start_pos[2], start_pos[3]
  local lnum2, col2 = end_pos[2], end_pos[3]

  local lines = vim.fn.getline(lnum1, lnum2)
  if #lines == 0 then return end

  -- Adjust last line
  if #lines > 0 then
    local last_line = lines[#lines]
    local end_col = col2 - (vim.o.selection == 'inclusive' and 1 or 2)
    lines[#lines] = string.sub(last_line, 1, end_col)
  end

  -- Adjust first line
  if #lines > 0 then
    lines[1] = string.sub(lines[1], col1)
  end

  local tempfile = vim.fn.tempname()
  vim.fn.writefile(lines, tempfile, 'b')
  vim.fn.system('tmux load-buffer ' .. tempfile)
  vim.fn.delete(tempfile)
end

-- Window view save/restore
function M.auto_save_win_view()
  local winid = vim.api.nvim_get_current_win()
  if not vim.w[winid].SavedBufView then
    vim.w[winid].SavedBufView = {}
  end
  vim.w[winid].SavedBufView[vim.fn.bufnr('%')] = vim.fn.winsaveview()
end

function M.auto_restore_win_view()
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.fn.bufnr('%')

  if vim.w[winid].SavedBufView and vim.w[winid].SavedBufView[buf] then
    local current_view = vim.fn.winsaveview()
    local at_start_of_file = current_view.lnum == 1 and current_view.col == 0

    if at_start_of_file and not vim.wo.diff then
      vim.fn.winrestview(vim.w[winid].SavedBufView[buf])
    end

    vim.w[winid].SavedBufView[buf] = nil
  end
end

-- Pulse current line (like Emacs)
function M.pulse_current_line()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local bufnr = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_create_namespace('pulse')

  -- Create highlight group for pulse effect (reverse colors)
  vim.api.nvim_set_hl(0, 'PulseLine', { reverse = true })

  -- Get line content to determine end column
  local line_content = vim.api.nvim_buf_get_lines(bufnr, current_line - 1, current_line, false)[1] or ""
  local end_col = #line_content

  -- Add highlight
  local mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, current_line - 1, 0, {
    end_col = end_col,
    hl_group = 'PulseLine',
    priority = 1000,
  })

  -- Remove highlight after a short delay
  vim.defer_fn(function()
    pcall(vim.api.nvim_buf_del_extmark, bufnr, ns_id, mark_id)
  end, 300)
end

function M.setup()
  -- Create user commands
  vim.api.nvim_create_user_command('QFix', function(opts)
    M.qfix_toggle(opts.bang)
  end, { bang = true })

  -- Expose functions globally for backward compatibility
  _G.CreateCenteredFloatingWindow = M.create_centered_floating_window
  _G.LightlineTruncatedFileName = M.lightline_truncated_filename
  _G.ToggleMouse = M.toggle_mouse
  _G.ToggleFold = M.toggle_fold

  -- Check for local override file
  local function file_exists(name)
    local f = io.open(name, "r")
    if f then f:close() return true else return false end
  end

  -- Load local override if it exists
  if file_exists(vim.fn.expand("~/.config/nvim/local.lua")) then
    require("local")
  end
end

end

return M