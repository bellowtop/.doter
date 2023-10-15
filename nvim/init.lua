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



  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-tree/nvim-tree.lua'

  use 'neovim/nvim-lspconfig'
  use 'kevinhwang91/nvim-bqf'

  use {'junegunn/fzf', run = function()
        vim.fn['fzf#install']()
    end
  }

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- lspconfig for clangd
  use 'p00f/clangd_extensions.nvim'


  use {
    requires = { "nvim-treesitter/nvim-treesitter" },
    "Badhi/nvim-treesitter-cpp-tools",
  }

  -- for diagnostic
  use "folke/trouble.nvim"

  use 'nvim-lua/plenary.nvim'

  use { 'nvim-telescope/telescope.nvim', tag =  '0.1.0' }
  use { "nvim-telescope/telescope-file-browser.nvim" }


  use 'Konfekt/FastFold'
  use 'tmhedberg/SimpylFold'
  use 'jiangmiao/auto-pairs'
  use 'dyng/ctrlsf.vim'
  use 'liuchengxu/vista.vim'
  use 'terryma/vim-multiple-cursors'
  use 'easymotion/vim-easymotion'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use { 'prettier/vim-prettier', run = 'npm install' }
  use 'schickling/vim-bufonly'
  use 'rbgrouleff/bclose.vim'
  use 'Yggdroot/indentLine'

  use 'fatih/vim-go'
  use 'rust-lang/rust.vim'
  use 'elzr/vim-json'

  use 'flazz/vim-colorschemes'
  use 'folke/tokyonight.nvim'
  use 'wojciechkepka/bogster'


  use 'itchyny/lightline.vim'
  use 'mengelbrecht/lightline-bufferline'

  use 'folke/which-key.nvim'
  use 'airblade/vim-rooter'

  use 'tpope/vim-abolish'
  use 'tpope/vim-fugitive'

  use 'godlygeek/tabular'
  use 'plasticboy/vim-markdown'
  use 'mzlogin/vim-markdown-toc'
  use 'kannokanno/previm'

  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use 'ziglang/zig.vim'


  if install_plugins then
    require('packer').sync()
  end
end)




-- fixme
-- vim.opt.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"

-- fixme
vim.opt.compatible = false
-- fixme
-- vim.opt.filetype = false
-- fixme
-- vim.opt.syntax = true

-- space as leader
vim.g.mapleader = " "

vim.cmd([[
filetype plugin indent on
]])

-- fixme
-- vim.opt.filetype = true
-- fixme
-- vim.opt.plugin  = true
-- fixme
-- vim.opt.indent  = true


vim.opt.completeopt:append("noselect")
vim.opt.completeopt:append("preview")
vim.opt.shortmess:append("c")
vim.opt.belloff:append("ctrlg")

vim.opt.lispwords:append("use-package")
vim.opt.lispwords:append("defun*")
vim.opt.lispwords:append("eval-after-load")
vim.opt.lispwords:append("with-eval-after-load")
vim.opt.lispwords:append("defadvice")




vim.opt.expandtab = true


--  """""""""""""""""""""""""""""""""""""""
--  """""""""
--  """""""" Settings for normal vi
--  """""""""
--  """""""""""""""""""""""""""""""""""""""

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.updatetime = 500

vim.opt.listchars = { tab = '▸ ' , trail = '·', extends = '❯', precedes = '❮', nbsp = '×' }
vim.opt.list = true
vim.opt.hid = true

vim.opt.number = true
vim.opt.modeline = false

vim.opt.history = 1000
vim.opt.scrolloff = 10
vim.opt.foldmethod = "syntax"
vim.opt.tabstop = 4
vim.opt.shiftwidth =4

vim.opt.hidden = true
vim.opt.autoindent = true
vim.opt.mouse = ""


vim.opt.maxmempattern = 20000
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- fixme
-- vim.opt.syntax = true
--
vim.opt.number = true
vim.opt.wrap = false
vim.opt.vb = true
vim.opt.ruler = true

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.startofline = false

vim.opt.exrc = true
vim.opt.secure = true



-- default no fold at all.
vim.opt.foldlevelstart = 99



vim.opt.wildmenu = true
vim.opt.wildmode = "full"
-- fixme
-- vim.opt.wildchar = '\t'
-- vim.opt.wildcharm = "<C-Z>"




-- vim.opt.clipboard:prepend("unnamed,unnamedplus")
vim.opt.backspace = "indent,eol,start"

-- fixme
-- vim.opt.pair_program_mode = 0






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






vim.cmd([[
function! LightlineTruncatedFileName()
let l:filePath = expand('%')
    if winwidth(0) > 100
        return l:filePath
    else
        return pathshorten(l:filePath)
    endif
endfunction
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()
]])

vim.opt.showtabline = 2

vim.g.lightline = {
       colorscheme = 'tokyonight',
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






--
-- easymotion
--
--

vim.api.nvim_set_keymap("n", "f", "<Plug>(easymotion-bd-w)", { noremap=true, silent=true })
-- wait 5s before start diagnostic after easymotion finish
vim.cmd([[
    autocmd User EasyMotionPromptBegin silent! :lua vim.diagnostic.disable()
    autocmd User EasyMotionPromptEnd   silent! :call timer_start(5000, { tid -> execute(':lua vim.diagnostic.enable()')})
]])


--
-- vim-rooter
--
--
-- vim.g.rooter_manual_only = 1

--- replace for this
---  " augroup vimrc_rooter
---  "     autocmd VimEnter * 
---  " augroup END
---
-- local rooter_augroup = vim.api.nvim_create_augroup('vimrc_rooter', {clear = true})
-- vim.api.nvim_create_autocmd('VimEnter', {
--   pattern = '*',
--   group = rooter_augroup,
--   command = ':Rooter'
-- })



--
-- nvim-telescope
--
--
-- reference:
-- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L136

vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true } )
vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua require('telescope.builtin').live_grep({layout_strategy='vertical'})<cr>",  { noremap = true } )
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<cr>",    { noremap = true } )
vim.api.nvim_set_keymap("n", "<leader>s",   "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",    { noremap = true } )
vim.api.nvim_set_keymap("n", "<leader>p", ":Telescope file_browser<cr>",    { noremap = true } )

-- vim.api.nvim_set_keymap("n", "<C-g>",     "<ESC><ESC><ESC>",                                        { noremap = true } )

local actions = require "telescope.actions"
local telescope_config = require "telescope.config"

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-g>"] = actions.close,
        ["<C-c>"] = actions.close,
        -- ["<C-[>"] = actions.close,
      },
      n = {
        ["<C-g>"] = actions.close,
        ["<C-c>"] = actions.close,
        -- ["<C-[>"] = actions.close,
      },
    }
  },
}
require("telescope").load_extension "file_browser"





--
-- nvim-bpf
--
--
require('bqf').setup({
    func_map = {
        open = 'o',
        openc = '<CR>',
    },
})




--
-- auto-pairs
--
--
vim.g.AutoPairsShortcutToggle = ''
vim.g.AutoPairsShortcutJump = ''





--
-- vim-multiple-cursors
--
--

vim.g.multi_cursor_use_default_mapping = 0
vim.g.multi_cursor_start_word_key      = '<C-n>'
vim.g.multi_cursor_next_key            = '<C-n>'
vim.g.multi_cursor_skip_key            = '<C-x>'
vim.g.multi_cursor_quit_key            = '<Esc>'






--
-- nvim-tree
--
--
vim.g.surround_no_insert_mappings = 1

require'nvim-tree'.setup {
    renderer = {
        group_empty = true,
        indent_markers = {
            enable = true,
            icons = {
                corner = "└─",
                item = "├─",
                edge = "│ ",
                none = "  ",
                },
            }
        }
    }


function find_and_focus_file()
  require('nvim-tree.api').tree.find_file({
    focus = true,
    open = true,
  })
end

vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<CR>",    { noremap = true } )
vim.api.nvim_set_keymap("n", "<leader>r", ":NvimTreeRefresh<CR>",   { noremap = true } )
vim.api.nvim_set_keymap("n", "<leader>N", ":NvimTreeFindFile<CR>",  { noremap = true } )

-- vim.api.nvim_set_keymap("n", "<leader>@", ":NvimTreeFindFile<CR>",  { noremap = true } )
-- vim.api.nvim_set_keymap("n", "@", "<cmd>lua find_and_focus_file()<cr>",    { noremap = true } )
vim.keymap.set('n', '@', find_and_focus_file, { noremap = true })




--
-- previm
--
--
vim.g.previm_open_cmd = 'open -a Safari'
vim.cmd([[
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END
]])



--
-- vista
--
--
vim.g.vista_echo_cursor_strategy = 'floating_win'

vim.api.nvim_set_keymap("n", "<Leader>v",         ":Vista!!",  { noremap = true } )






--
-- nvim-lspconfig
--
--

local function get_forced_lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  return capabilities
end


local function LspRename()
    local curr_name = vim.fn.expand("<cword>")
    local value = vim.fn.input("LSP Rename: ", curr_name)
    local lsp_params = vim.lsp.util.make_position_params()

    if not value or #value == 0 or curr_name == value then return end

    -- request lsp rename
    lsp_params.newName = value
    vim.lsp.buf_request(0, "textDocument/rename", lsp_params, function(_, res, ctx, _)
      if not res then return end

      -- apply renames
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

      -- print renames
      local changed_files_count = 0
      local changed_instances_count = 0
      
      if (res.documentChanges) then
        for _, changed_file in pairs(res.documentChanges) do
          changed_files_count = changed_files_count + 1
          changed_instances_count = changed_instances_count + #changed_file.edits
        end
      elseif (res.changes) then
        for _, changed_file in pairs(res.changes) do
          changed_instances_count = changed_instances_count + #changed_file
          changed_files_count = changed_files_count + 1
        end
      end
      
      -- compose the right print message
      print(string.format("renamed %s instance%s in %s file%s. %s", 
        changed_instances_count,
        changed_instances_count == 1 and '' or 's',
        changed_files_count,
        changed_files_count == 1 and '' or 's',
        changed_files_count > 1 and "To save them run ':wa'" or ''
      ))
    end)
end




-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local my_lsp_on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.keymap.set('n', 'gF', vim.lsp.buf.format, bufopts)
  vim.keymap.set('n', 'gR', LspRename, bufopts)

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)

  vim.keymap.set('n', 'ga',     vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, bufopts)


  vim.keymap.set('n', 'gr', function() vim.lsp.buf.references({ includeDeclaration = false }) end, bufopts)
  vim.keymap.set('n', 'gF', vim.lsp.buf.format, bufopts)
  vim.keymap.set('n', 'gF', vim.lsp.buf.format, bufopts)


  -- -- Set autocommands conditional on server_capabilities
  -- if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  -- end

  vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
      end
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        signs = true,
        update_in_insert = false,
        virtual_text = false
  })

  require("cmp_nvim_lsp").default_capabilities(get_forced_lsp_capabilities())
end















--
--nvim-cmp
--
--
local cmp = require'cmp'


local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = {

    ['<C-Space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,

    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})










local servers = { "gopls",  "rust_analyzer", "zls", "clangd" }
for _, lsp in ipairs(servers) do
  if vim.fn.executable(lsp) == 1 then
      require('lspconfig')[lsp].setup { on_attach = my_lsp_on_attach, capabilities = get_forced_lsp_capabilities() }
  end
end


require("clangd_extensions").setup{
    server = {
          cmd = {
           "clangd",
           "-j=4",
           "--background-index",
           "--clang-tidy",
           "--fallback-style=llvm",
           "--all-scopes-completion",
           "--completion-style=detailed",
           "--header-insertion=iwyu",
           "--header-insertion-decorators",
           "--pch-storage=memory",
        },
        initialization_options = {
           fallback_flags = { "-std=c++20" },
        },
        on_attach = my_lsp_on_attach,
        capabilities = get_forced_lsp_capabilities(),
    }
}





require 'nt-cpp-tools'.setup({
    preview = {
        quit = 'q', -- optional keymapping for quit preview
        accept = '<tab>' -- optional keymapping for accept preview
    },
    header_extension = 'h', -- optional
    source_extension = 'cpp', -- optional
    custom_define_class_function_commands = { -- optional
        TSCppImplWrite = {
            output_handle = require'nt-cpp-tools.output_handlers'.get_add_to_cpp()
        }
        --[[
        <your impl function custom command name> = {
            output_handle = function (str, context) 
                -- string contains the class implementation
                -- do whatever you want to do with it
            end
        }
        ]]
    }
})











vim.cmd([[

""""""    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""    " cscope setting
""""""    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""    if has("cscope")
""""""        set csprg=/usr/bin/cscope
""""""        set csto=1
""""""        set cst
""""""        set nocsverb
""""""        " add any database in current directory
""""""        if filereadable(".cscope.out")
""""""            cs add .cscope.out
""""""        endif
""""""        set csverb
""""""    endif
""""""    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
""""""    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
""""""    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
""""""    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
""""""    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
""""""    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
""""""    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
""""""    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
""""""    if filereadable(".tags")
""""""        set tags=.tags
""""""    else
""""""        set tags=tags
""""""    endif
]])







--
-- ctrlsf
--

vim.api.nvim_set_keymap("n", "<Leader>m",         "<Plug>CtrlSFCwordPath",  { noremap = true } )
vim.api.nvim_set_keymap("v", "<Leader>m",         "<Plug>CtrlSFVwordExec<CR>",  { noremap = true } )
vim.api.nvim_set_keymap("n", "<Leader>O",         ":CtrlSFOpen<CR> ",           { noremap = true } )

vim.g.ctrlsf_backend = 'rg'
vim.g.ctrlsf_auto_focus = { at = "start" }
vim.g.ctrlsf_search_mode = 'async'
vim.g.ctrlsf_extra_backend_args = { rg = '--no-ignore' }






--
-- prettier
--

vim.api.nvim_set_keymap("n", "<Leader>R",         ":<Plug>(Prettier):retab",  { noremap = true } )


--
--vim-go
--


vim.g.go_imports_autosave = 1
vim.g.go_fmt_autosave=1
vim.g.go_def_mapping_enabled=0
vim.g.go_doc_popup_window = 1
vim.g.go_gopls_enabled = 0
vim.g.go_code_completion_enabled = 0
vim.g.go_diagnostics_enabled = 0
vim.g.go_echo_command_info = 0
vim.g.go_echo_go_info=0
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_parameters = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_types = 1
vim.g.go_highlight_operators = 1



-- """""""""""""""""""""""""""""""""""""""
-- """""""""
-- """""""" Settings for FileType
-- """""""""
-- """""""""""""""""""""""""""""""""""""""

vim.cmd([[
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
autocmd FileType scss set iskeyword+=-
autocmd BufNewFile,BufReadPost *.scss set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.sh set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.sls set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.lua set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.json set shiftwidth=4 softtabstop=4
]])


vim.cmd([[
autocmd FileType vista,NvimTree noremap <buffer> <c-j> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <c-i> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <c-o> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <c-h> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <c-l> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <Leader>L <nop>
autocmd FileType vista,NvimTree noremap <buffer> <Leader>q <nop>
autocmd FileType vista,NvimTree noremap <buffer> <Leader>x <nop>
autocmd FileType vista,NvimTree noremap <buffer> <Leader>j <nop>
]])







vim.g.rust_fold = 1
vim.g.perl_fold = 1
vim.g.python_fold = 1
vim.g.erlang_fold = 1
vim.g.go_fold = 1
vim.g.fastfold_fold_command_suffixes = { 'x','X','a','A' }
vim.g.fastfold_savehook = 0
vim.g.vim_markdown_folding_disabled = 1





-- vim.g.indentLine_setConceal = 0
vim.g.vim_json_syntax_conceal = 0
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.bclose_no_plugin_maps = 1










vim.api.nvim_set_keymap("i", "<C-n>", "<C-o>j", { noremap = true } )
vim.api.nvim_set_keymap("i", "<C-d>", "<C-o>x", { noremap = true } )
vim.api.nvim_set_keymap("i", "<C-p>", "<C-o>k", { noremap = true } )
vim.api.nvim_set_keymap("i", "<C-e>", "<C-o>$", { noremap = true } )
vim.api.nvim_set_keymap("i", "<C-a>", "<C-o>^", { noremap = true } )
vim.api.nvim_set_keymap("i", "<C-b>", "<Left>", { noremap = true } )
vim.api.nvim_set_keymap("i", "<C-f>", "<Right>", { noremap = true } )
vim.api.nvim_set_keymap("i", "<C-k>", "<C-o>D", { noremap = true } )
vim.api.nvim_set_keymap("i", "<M-k>", "<C-o>d0", { noremap = true } )
vim.api.nvim_set_keymap("i", "<C-t>", "<C-o>O", { noremap = true } )
vim.api.nvim_set_keymap("i", "<M-BS>", "<C-o>db", { noremap = true } )
vim.api.nvim_set_keymap("i", "<M-d>", "<C-o>de", { noremap = true } )


vim.api.nvim_set_keymap("i", "<C-q>", "<Esc>", { noremap = true } )
vim.api.nvim_set_keymap("n", "<C-q>", "a",     { noremap = true } )



---   ---  q as window prefix
---   ---  qq to cycle windows
---   ---  qQ to delete current window
---   ---  qd to delete all ther windows
---   --
---   vim.api.nvim_set_keymap("n", "q", "<C-w>", { noremap = true })
---   vim.api.nvim_set_keymap("n", "qq", "<C-w><C-w>", { noremap = true })
---   vim.api.nvim_set_keymap("n", "qQ", "<C-w>q", { noremap = true })
---   vim.api.nvim_set_keymap("n", "qd", "<C-w>o", { noremap = true })




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

" used to track the quickfix window
augroup QFixToggle
 autocmd!
 autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
 autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END
]])

vim.api.nvim_set_keymap("n", "<C-h><C-h>", ":QFix<CR>", { noremap = true })


vim.api.nvim_set_keymap("n", "<Leader>h", ":bprev<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>l", ":bnext<CR>", { noremap = true })

vim.api.nvim_set_keymap("n", "<Leader>k", ":Bclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>K", ":BufOnly<CR> :bfirst<CR>", { noremap = true })


vim.api.nvim_set_keymap("n", "<Leader>x", "<C-w>c", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>w", "<C-w>", { noremap = true })

vim.api.nvim_set_keymap("n", "<Leader>L", ":set invnumber<CR>", { noremap = true })
-- fixme
-- vim.api.nvim_set_keymap("n", "<Leader>T", ":%s/\s\+$//<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>U", ":g/^$/d<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>R", ":retab<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>.", ":@:<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>;", ":nohlsearch<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>c", ":let @+=expand('%:p')<CR>", { noremap = true })





vim.api.nvim_set_keymap("n", "J", "mzJ`z",  { noremap = true })
vim.api.nvim_set_keymap("n", "H", "^",      { noremap = true })
vim.api.nvim_set_keymap("n", "L", "$",      { noremap = true })
vim.api.nvim_set_keymap("v", "H", "^",      { noremap = true })
vim.api.nvim_set_keymap("v", "L", "g_",     { noremap = true })
vim.api.nvim_set_keymap("o", "H", "^",      { noremap = true })
vim.api.nvim_set_keymap("o", "L", "g_",     { noremap = true })

vim.api.nvim_set_keymap("n", "m", "%", { noremap = true })
vim.api.nvim_set_keymap("v", "m", "%", { noremap = true })

vim.api.nvim_set_keymap("n", "<C-l>", "zz", { noremap = true })


-- occur
-- fixme
-- vim.api.nvim_set_keymap("n", "g/", ":vimgrep /<C-R>//j %<CR>\|:cw<CR>", { noremap = true })


vim.api.nvim_set_keymap("n", "<C-j>",     ":w<CR>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-j>",     "<ESC>:w<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-j>",     "<ESC>:w<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>j", ":w<CR>", { noremap = true })



vim.api.nvim_set_keymap("n", ";", "<C-d>", { noremap = true })
vim.api.nvim_set_keymap("n", "'", "<C-u>", { noremap = true })
vim.api.nvim_set_keymap("v", ";", "<C-d>", { noremap = true })
vim.api.nvim_set_keymap("v", "' ", "<C-u>", { noremap = true })

vim.api.nvim_set_keymap("n", "\\\\", "zz", { noremap = true })
vim.api.nvim_set_keymap("n", "\\|",  "zt", { noremap = true })

vim.api.nvim_set_keymap("n", "th", ":tabfirst<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "tj", ":tabnext<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "tk", ":tabprev<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "tl", ":tablast<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "tt", ":tabedit<Space>", { noremap = true })
vim.api.nvim_set_keymap("n", "tn", ":tabnext<Space>", { noremap = true })
vim.api.nvim_set_keymap("n", "tm", ":tabm<Space>", { noremap = true })
vim.api.nvim_set_keymap("n", "td", ":tabclose<CR>", { noremap = true })


vim.api.nvim_set_keymap("v", "p", '"_dp', { noremap = true })
vim.api.nvim_set_keymap("v", "P", '"_dP', { noremap = true })

-- switch to last buffer
vim.api.nvim_set_keymap("n", ",b", '<C-6>', { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>o", ':ClangdSwitchSourceHeader<CR>', { noremap = true })

vim.api.nvim_set_keymap("n", "<C-g>", "<ESC><ESC><ESC>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-g>", "<ESC><ESC><ESC>", { noremap = true })
vim.api.nvim_set_keymap("v", "<C-g>", "<ESC><ESC><ESC>", { noremap = true })


vim.api.nvim_set_keymap("v", '<C-r>',   '"hy:%sno#<C-r>h##gc<left><left><left>',    { noremap = true })
vim.api.nvim_set_keymap("n", 'S',       ':%sno##g<LEFT><LEFT>',                     { noremap = true })
vim.api.nvim_set_keymap("i", '<C-y>',   '<C-r>"',                                   { noremap = true })
vim.api.nvim_set_keymap("v", '//',      'y/<C-R>"<CR>"',                            { noremap = true })





-- SEE more at https://vimhelp.org/cmdline.txt.html
vim.api.nvim_set_keymap("c", "<C-A>",            "<Home>",    { noremap = true } )
vim.api.nvim_set_keymap("c", "<C-F>",            "<Right>",   { noremap = true } )
vim.api.nvim_set_keymap("c", "<C-B>",            "<Left>",    { noremap = true } )
vim.api.nvim_set_keymap("c", "<Esc><Left>",      "<S-Left>",  { noremap = true } )
vim.api.nvim_set_keymap("c", "<Esc>b",           "<S-Left>",  { noremap = true } )
vim.api.nvim_set_keymap("c", "<Esc><Right>",     "<S-Right>", { noremap = true } )
vim.api.nvim_set_keymap("c", "<Esc>f",           "<S-Right>", { noremap = true } )
vim.api.nvim_set_keymap("c", "<Esc><BS>",        "<C-W>",     { noremap = true } )
-- cnoremap <C-G>          <C-C>

vim.api.nvim_set_keymap("c", "w!!",        "%!sudo tee > /dev/null %",     { noremap = true } )




vim.api.nvim_set_keymap("n", ">", ':exe "vertical resize +20"<CR>', { noremap = true } )
vim.api.nvim_set_keymap("n", "<", ':exe "vertical resize -20"<CR>', { noremap = true } )



vim.cmd([[




function! MyHighlights() abort
    " for term
    hi Search                       cterm=reverse           ctermfg=214         ctermbg=232
    hi SpellCap                                             ctermfg=black       ctermbg=green

    hi link LspReferenceText Special
    " hi LspReferenceText                                     ctermfg=black       ctermbg=green
    " hi LspDiagnosticsError                                  ctermfg=cyan
    " hi LspDiagnosticsVirtualTextError                       ctermfg=red

    hi SignColumn                                           ctermfg=white       ctermbg=black
    " hi Whitespace                                           ctermfg=DarkGray
    hi VertSplit                                            ctermfg=green       ctermbg=black
    hi multiple_cursors_cursor                              ctermfg=green       ctermbg=red
    hi multiple_cursors_visual                              ctermfg=black       ctermbg=white
    " hi LineNr                                                                   ctermbg=NONE
    " hi Normal                                               ctermbg=234

    " hi CursorLine                                           cterm=none          ctermbg=234


    " for gui
    hi Search                       gui=reverse                guifg=goldenrod2         guibg=black
    hi SpellCap                                             guifg=black         guibg=springgreen

    hi link LspReferenceText Special
    " hi LspReferenceText                                     guifg=black         guibg=limegreen
    " hi CocHighlightText                                     guifg=black         guibg=limegreen
    " hi LspDiagnosticsError                                  guifg=cyan
    " hi LspDiagnosticsVirtualTextError                       guifg=red

    hi SignColumn                                           guifg=white
    " hi Whitespace                                           guifg=DarkSlateGray
    hi VertSplit                                            guifg=springgreen   guibg=NONE
    hi multiple_cursors_cursor                              guifg=springgreen   guibg=red
    hi multiple_cursors_visual                              guifg=black         guibg=white
    " hi LineNr                                                                   guibg=NONE
    " hi Normal                                                                   guibg=#1c1c1c

    " hi CursorLine                                                               guibg=black


endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

if has("termguicolors")
    set termguicolors
endif


colorscheme bogster

" colorscheme space-vim-dark
" let g:tokyonight_style = "night"
" let g:tokyonight_italic_functions = 1
" let g:tokyonight_sidebars = [ "qf", "vista_kind", "terminal", "packer" ]
" colorscheme tokyonight



]])







vim.opt.pastetoggle = '<F2>'




vim.cmd([[


"""""""""""""""""""""""""""""""""""""""
"""""""""
"""""""" Settings for Custom Funcs
"""""""""
"""""""""""""""""""""""""""""""""""""""

nnoremap <F3> :set wrap!<Enter>

function! ToggleMouse()
    if &mouse == 'a'
        set mouse=
    else
        set mouse=a
    endif
endfunc
nnoremap <F4> :call ToggleMouse() <Enter>

nnoremap <F6> :LspRestart<CR>

nnoremap <F8> *


function! ToggleFold()
    let &foldlevel = 100 - &foldlevel
    :normal zz
endfunc
nnoremap zm :call ToggleFold() <Enter>
nnoremap zo zA


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
vnoremap <silent> Y :call <sid>CopyToTmux()<cr>

]])



vim.cmd([[

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction
" Restore current view settings.
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
" When switching buffers, preserve window view.
autocmd BufLeave * call AutoSaveWinView()
autocmd BufEnter * call AutoRestoreWinView()

]])




-- fixme
--- vim.api.nvim_create_user_command(
---     'Jsonf',
---     ':execute \'%!python2 -m json.tool\' | :execute \'%!python2 -c "import re,sys;sys.stdout.write(re.sub(r\"\\\u[0-9a-f]{4}\", lambda m:m.group().decode(\"unicode_escape\").encode(\"utf-8\"), sys.stdin.read()))"\''
--- )


vim.api.nvim_set_keymap("n", "K", "<nop>", { noremap = true })
vim.api.nvim_set_keymap("n", "Q", "<nop>", { noremap = true })


-- vil/val to select line

vim.api.nvim_set_keymap("v", "al", ":<C-U>normal 0v$h<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "il", ":<C-U>normal ^vg_<CR>", { noremap = true })

vim.api.nvim_set_keymap("o", "al", ":normal val<CR>", { noremap = true })
vim.api.nvim_set_keymap("o", "il", ":normal vil<CR>", { noremap = true })




vim.api.nvim_set_keymap("n", "<M-n>", "<C-e>",    { noremap = true } )
vim.api.nvim_set_keymap("n", "<M-p>", "<C-y>",    { noremap = true } )




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





if install_plugins then
  return
end
