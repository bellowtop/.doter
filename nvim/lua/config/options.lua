local M = {}

function M.setup()
  local opt = vim.opt
  local g = vim.g

  -- Encoding
  opt.encoding = "utf-8"
  opt.compatible = false

  -- Completion
  opt.completeopt:append("noselect")
  opt.completeopt:append("preview")
  opt.shortmess:append("c")
  opt.belloff:append("ctrlg")

  -- Lisp words
  opt.lispwords:append("use-package")
  opt.lispwords:append("defun*")
  opt.lispwords:append("eval-after-load")
  opt.lispwords:append("with-eval-after-load")
  opt.lispwords:append("defadvice")

  -- Indentation
  opt.expandtab = true
  opt.tabstop = 4
  opt.shiftwidth = 4
  opt.autoindent = true

  -- Window behavior
  opt.splitbelow = true
  opt.splitright = true
  opt.cursorline = true
  opt.updatetime = 500

  -- Visual
  opt.listchars = { tab = '▸ ', trail = '·', extends = '❯', precedes = '❮', nbsp = '×' }
  opt.list = true
  opt.number = true
  opt.signcolumn = "yes"  -- Always show sign column to prevent layout shifts
  opt.modeline = false
  opt.wrap = false
  opt.ruler = true
  opt.showtabline = 2

  -- Buffer behavior
  opt.hid = true
  opt.hidden = true
  opt.history = 1000
  opt.scrolloff = 2

  -- Folding
  opt.foldmethod = "syntax"
  opt.foldlevelstart = 99

  -- Mouse and timing
  opt.mouse = "a"
  opt.maxmempattern = 20000
  opt.timeoutlen = 0
  opt.ttimeoutlen = 0

  -- Search
  opt.incsearch = true
  opt.ignorecase = true
  opt.smartcase = true
  opt.hlsearch = true
  opt.startofline = false

  -- Security
  opt.exrc = true
  opt.secure = true

  -- Completion
  opt.wildmenu = true
  opt.wildmode = "full"

  -- Backspace
  opt.backspace = "indent,eol,start"

  -- Visual bell
  opt.vb = true

  -- Color settings
  if vim.fn.has("termguicolors") == 1 then
    opt.termguicolors = true
  end

  -- Plugin-specific settings

  -- Auto-pairs
  g.AutoPairsShortcutToggle = ''
  g.AutoPairsShortcutJump = ''
  g.AutoPairsShortcutBackInsert = ''

  -- Multiple cursors
  g.multi_cursor_use_default_mapping = 0
  g.multi_cursor_start_word_key = '<C-n>'
  g.multi_cursor_next_key = '<C-n>'
  g.multi_cursor_skip_key = '<C-x>'
  g.multi_cursor_quit_key = '<Esc>'

  -- Surround
  g.surround_no_insert_mappings = 1

  -- Previm
  g.previm_open_cmd = 'open -a Safari'

  -- Vista
  g.vista_echo_cursor_strategy = 'floating_win'

  -- Folding plugins
  g.rust_fold = 1
  g.perl_fold = 1
  g.python_fold = 1
  g.erlang_fold = 1
  g.go_fold = 1
  g.fastfold_fold_command_suffixes = { 'x','X','a','A' }
  g.fastfold_savehook = 0
  g.vim_markdown_folding_disabled = 1

  -- Conceal settings
  g.vim_json_syntax_conceal = 0
  g.vim_markdown_conceal = 0
  g.vim_markdown_conceal_code_blocks = 0
  g.bclose_no_plugin_maps = 1

  -- CtrlSF
  g.ctrlsf_backend = 'rg'
  g.ctrlsf_auto_focus = { at = "start" }
  g.ctrlsf_search_mode = 'async'
  g.ctrlsf_extra_backend_args = { rg = '--no-ignore --hidden --glob "!.git" --glob "!backups"' }

  -- Go settings
  g.go_imports_autosave = 1
  g.go_fmt_autosave = 1
  g.go_def_mapping_enabled = 0
  g.go_doc_popup_window = 1
  g.go_gopls_enabled = 0
  g.go_code_completion_enabled = 0
  g.go_diagnostics_enabled = 0
  g.go_echo_command_info = 0
  g.go_echo_go_info = 0
  g.go_highlight_functions = 1
  g.go_highlight_function_parameters = 1
  g.go_highlight_function_calls = 1
  g.go_highlight_types = 1
  g.go_highlight_operators = 1

  -- Kommentary
  g.kommentary_create_default_mappings = false

  -- Lightline
  g.lightline = {
    colorscheme = 'ayu_mirage',
    active = {
      left = { { 'mode', 'paste' }, { 'readonly', 'filename', 'modified' } }
    },
    tabline = {
      left = { { 'buffers' } },
      right = { { 'close' } }
    },
    component_expand = {
      buffers = 'lightline#bufferline#buffers'
    },
    component_type = {
      buffers = 'tabsel'
    },
    component_function = {
      filename = 'LightlineTruncatedFileName'
    },
  }

  -- Lightline-bufferline 过滤特殊 buffer
  g['lightline#bufferline#exclude_ft'] = { 'help', 'man', 'qf', 'fugitive', 'NvimTree', 'TelescopePrompt', 'claude' }
  g['lightline#bufferline#exclude_name'] = { '[No Name]' }
end

return M
