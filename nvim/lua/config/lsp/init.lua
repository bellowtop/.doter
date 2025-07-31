local M = {}

local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local function LspRename()
  local curr_name = vim.fn.expand("<cword>")
  local value = vim.fn.input("LSP Rename: ", curr_name)
  local lsp_params = vim.lsp.util.make_position_params()

  if not value or #value == 0 or curr_name == value then return end

  lsp_params.newName = value
  vim.lsp.buf_request(0, "textDocument/rename", lsp_params, function(_, res, ctx, _)
    if not res then return end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

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

    print(string.format("renamed %s instance%s in %s file%s. %s",
      changed_instances_count,
      changed_instances_count == 1 and '' or 's',
      changed_files_count,
      changed_files_count == 1 and '' or 's',
      changed_files_count > 1 and "To save them run ':wa'" or ''
    ))
  end)
end

local function custom_attach(client, bufnr)
  local bufopts = { silent=true, buffer=bufnr }

  vim.keymap.set('n', 'gF', vim.lsp.buf.format, bufopts)
  vim.keymap.set('n', 'gR', LspRename, bufopts)

  vim.keymap.set('n', 'gD', function() 
    vim.lsp.buf.declaration()
    vim.defer_fn(function() require('config.functions').pulse_current_line() end, 100)
  end, bufopts)
  vim.keymap.set('n', 'gd', function() 
    vim.lsp.buf.definition()
    vim.defer_fn(function() require('config.functions').pulse_current_line() end, 100)
  end, bufopts)
  vim.keymap.set('n', 'gh',
    function()
        vim.lsp.buf.hover { border = "single", max_height = 25, max_width = 120 }
    end,
  bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)

  vim.keymap.set('n', 'ga',     vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, bufopts)

  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, bufopts)

  vim.keymap.set('n', 'grr', function() 
    vim.lsp.buf.references({ includeDeclaration = false }, {
      on_list = function(options)
        if #options.items == 1 then
          vim.api.nvim_command('edit ' .. options.items[1].filename)
          vim.api.nvim_win_set_cursor(0, {options.items[1].lnum, options.items[1].col - 1})
          -- Pulse the current line after jumping
          require('config.functions').pulse_current_line()
        else
          vim.fn.setqflist({}, ' ', options)
          vim.cmd('copen')
        end
      end
    })
  end, bufopts)

  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "gF", vim.lsp.buf.format)
  end

  api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local float_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "cursor",
      }
      diagnostic.open_float(nil, float_opts)
    end,
  })

  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
      hi! LspReferenceRead guifg=black guibg=#59dcb7
      hi! LspReferenceText guifg=black guibg=#59dcb7
      hi! LspReferenceWrite guifg=black guibg=#59dcb7
    ]])

    vim.cmd([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end

  if vim.g.logging_level == "debug" then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
  end

  require("lsp-format").on_attach(client, bufnr)
end

function M.setup()
  require("lsp-format").setup{}

  -- Change diagnostic signs
  fn.sign_define("DiagnosticSignError", { text = '🆇', texthl = "DiagnosticSignError" })
  fn.sign_define("DiagnosticSignWarn", { text = '!', texthl = "DiagnosticSignWarn" })
  fn.sign_define("DiagnosticSignInfo", { text = 'ℹ️', texthl = "DiagnosticSignInfo" })
  fn.sign_define("DiagnosticSignHint", { text = '', texthl = "DiagnosticSignHint" })

  -- Global config for diagnostic
  diagnostic.config {
    underline = true,
    virtual_text = false,
    signs = true,
    severity_sort = true,
  }

  -- Set diagnostic colors
  vim.cmd([[
    hi DiagnosticError guifg=#ff6b6b
    hi DiagnosticWarn guifg=#feca57
    hi DiagnosticInfo guifg=#48cae4
    hi DiagnosticHint guifg=#95e1d3
  ]])

  -- Configure LSP handlers
  lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lspconfig = require('lspconfig')

  -- Setup language servers
  if vim.fn.executable("clangd") then
    lspconfig.clangd.setup {
      on_attach = custom_attach,
      capabilities = capabilities,
      filetypes = { "c", "cpp", "cc" },
      flags = {
        debounce_text_changes = 500,
      },
    }
  end

  if vim.fn.executable("gopls") then
    lspconfig.gopls.setup {
      on_attach = custom_attach,
      capabilities = capabilities,
      filetypes = { "go" },
      flags = {
        debounce_text_changes = 500,
      },
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          semanticTokens = true,
          ["ui.inlayhint.hints"] = {
            compositeLiteralFields = true,
            constantValues = true,
            parameterNames = true,
            functionTypeParameters = true,
          },
        },
      },
    }
  end

  if vim.fn.executable("qmlls") then
    lspconfig.qmlls.setup {
      on_attach = custom_attach,
      capabilities = capabilities,
      filetypes = { "qml" },
      flags = {
        debounce_text_changes = 500,
      },
    }
  end

  if vim.fn.executable("sourcekit-lsp") then
    lspconfig.sourcekit.setup {
      on_attach = custom_attach,
      capabilities = capabilities,
      filetypes = { "swift" },
      flags = {
        debounce_text_changes = 500,
      },
    }
  end

  -- Clangd extensions
  require("clangd_extensions").setup({
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
      on_attach = custom_attach,
      capabilities = capabilities,
    },
  })

  -- Mason setup
  require("mason").setup()
  local mason_lsp = require('mason-lspconfig')
  mason_lsp.setup({
    ensure_installed = { 'ts_ls', },
    automatic_installation = true,
  })

  -- TypeScript setup
  require("typescript-tools").setup {
    on_attach = custom_attach,
  }

  -- C++ tools
  require 'nt-cpp-tools'.setup({
    preview = {
      quit = 'q',
      accept = '<tab>'
    },
    header_extension = 'h',
    source_extension = 'cpp',
    custom_define_class_function_commands = {
      TSCppImplWrite = {
        output_handle = require'nt-cpp-tools.output_handlers'.get_add_to_cpp()
      }
    }
  })


  -- python lsp
  require('lspconfig').basedpyright.setup({
    on_attach = custom_attach,
  })

end

return M
