local M = {}

local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

-- Store custom_attach function for external use
local custom_attach = nil

local function LspRename()
  local curr_name = vim.fn.expand("<cword>")
  local value = vim.fn.input("LSP Rename: ", curr_name)
  local lsp_params = vim.lsp.util.make_position_params()

  if not value or #value == 0 or curr_name == value then
    return
  end

  lsp_params.newName = value
  vim.lsp.buf_request(0, "textDocument/rename", lsp_params, function(_, res, ctx, _)
    if not res then
      return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

    local changed_files_count = 0
    local changed_instances_count = 0

    if res.documentChanges then
      for _, changed_file in pairs(res.documentChanges) do
        changed_files_count = changed_files_count + 1
        changed_instances_count = changed_instances_count + #changed_file.edits
      end
    elseif res.changes then
      for _, changed_file in pairs(res.changes) do
        changed_instances_count = changed_instances_count + #changed_file
        changed_files_count = changed_files_count + 1
      end
    end

    print(
      string.format(
        "renamed %s instance%s in %s file%s. %s",
        changed_instances_count,
        changed_instances_count == 1 and "" or "s",
        changed_files_count,
        changed_files_count == 1 and "" or "s",
        changed_files_count > 1 and "To save them run ':wa'" or ""
      )
    )
  end)
end

custom_attach = function(client, bufnr)
  local bufopts = { silent = true, buffer = bufnr }

  vim.keymap.set("n", "gF", vim.lsp.buf.format, bufopts)
  vim.keymap.set("n", "gR", function()
    vim.lsp.buf.references({ includeDeclaration = false }, {
      on_list = function(options)
        if #options.items == 1 then
          vim.api.nvim_command("edit " .. options.items[1].filename)
          vim.api.nvim_win_set_cursor(0, { options.items[1].lnum, options.items[1].col - 1 })
          -- Pulse the current line after jumping
          require("config.functions").pulse_current_line()
        else
          vim.fn.setqflist({}, " ", options)
          vim.cmd("copen")
        end
      end,
    })
  end, bufopts)

  vim.keymap.set("n", "gD", function()
    vim.lsp.buf.declaration()
    vim.defer_fn(function()
      require("config.functions").pulse_current_line()
    end, 100)
  end, bufopts)
  vim.keymap.set("n", "gd", function()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
      if err then
        vim.notify("Error getting definition: " .. err.message, vim.log.levels.ERROR)
        return
      end

      if not result or vim.tbl_isempty(result) then
        vim.notify("No definition found", vim.log.levels.INFO)
        return
      end

      -- Normalize result: could be a single location or an array
      local locations = {}
      if vim.islist(result) then
        locations = result
      else
        locations = { result }
      end

      -- Jump to the first location
      if locations[1] then
        vim.lsp.util.jump_to_location(locations[1], "utf-8")
        vim.defer_fn(function()
          require("config.functions").pulse_current_line()
        end, 100)
      end
    end)
  end, bufopts)
  vim.keymap.set("n", "gh", function()
    vim.lsp.buf.hover({ border = "single", max_height = 25, max_width = 120 })
  end, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)

  vim.keymap.set("n", "ga", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action, bufopts)

  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, bufopts)

  vim.keymap.set("n", "grr", function()
    vim.lsp.buf.references({ includeDeclaration = false }, {
      on_list = function(options)
        if #options.items == 1 then
          vim.api.nvim_command("edit " .. options.items[1].filename)
          vim.api.nvim_win_set_cursor(0, { options.items[1].lnum, options.items[1].col - 1 })
          -- Pulse the current line after jumping
          require("config.functions").pulse_current_line()
        else
          vim.fn.setqflist({}, " ", options)
          vim.cmd("copen")
        end
      end,
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
  -- ⚠️ 最优先禁用 ts_ls - 必须在任何 LSP 启动之前
  -- Prevent ts_ls/tsserver from being set up (we use typescript-tools.nvim instead)
  -- The mason handlers below will have empty functions for these servers

  -- 添加 autocmd 作为第一道防线：在 FileType 触发时立即阻止 ts_ls
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    callback = function()
      -- 停止任何已启动的 ts_ls 客户端（静默模式）
      vim.defer_fn(function()
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.name == "ts_ls" or client.name == "tsserver" then
            vim.lsp.stop_client(client.id, true)
          end
        end
      end, 100) -- 100ms 后检查
    end,
  })

  -- 如果仍有 ts_ls 附加，在 LspAttach 阶段立即停止
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and (client.name == "ts_ls" or client.name == "tsserver") then
        -- 使用调度确保在附加完成后停止，避免竞态
        vim.schedule(function()
          vim.lsp.stop_client(client.id, true)
        end)
      end
    end,
  })

  require("lsp-format").setup({})

  -- Change diagnostic signs
  fn.sign_define("DiagnosticSignError", { text = "🆇", texthl = "DiagnosticSignError" })
  fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
  fn.sign_define("DiagnosticSignInfo", { text = "ℹ️", texthl = "DiagnosticSignInfo" })
  fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

  -- Global config for diagnostic
  diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    severity_sort = true,
    float = {
      border = "rounded",
      focusable = true,
      source = "always",
    },
  })

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

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Setup language servers using vim.lsp.config
  if vim.fn.executable("clangd") then
    vim.lsp.config.clangd = {
      cmd = { "clangd" },
      filetypes = { "c", "cpp", "cc" },
      on_attach = custom_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 500,
      },
    }
  end

  if vim.fn.executable("gopls") then
    vim.lsp.config.gopls = {
      cmd = { "gopls" },
      filetypes = { "go" },
      on_attach = custom_attach,
      capabilities = capabilities,
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
    vim.lsp.config.qmlls = {
      cmd = { "qmlls" },
      filetypes = { "qml" },
      on_attach = custom_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 500,
      },
    }
  end

  if vim.fn.executable("clojure-lsp") then
    vim.lsp.config.clojure_lsp = {
      cmd = { "clojure-lsp" },
      filetypes = { "clojure", "edn" },
      on_attach = custom_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 500,
      },
      root_markers = { "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", ".git" },
    }
    vim.lsp.enable("clojure_lsp")
  end

  if vim.fn.executable("sourcekit-lsp") then
    vim.lsp.config.sourcekit = {
      cmd = { "sourcekit-lsp" },
      filetypes = { "swift" },
      on_attach = custom_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 500,
      },
    }
  end

  if vim.fn.executable("rust-analyzer") then
    vim.lsp.config.rust_analyzer = {
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },
      on_attach = custom_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = { command = "clippy" },
          inlayHints = { enable = true },
        },
      },
    }
    vim.lsp.enable("rust_analyzer")
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

  -- Mason setup (ts_ls 已在函数开头和 init.lua 中禁用)
  local mason_lsp = require("mason-lspconfig")

  -- 获取要跳过的服务器列表
  local skip_servers = vim.g.lsp_skip_servers or {}

  mason_lsp.setup({
    ensure_installed = {}, -- Removed ts_ls to avoid conflict with typescript-tools.nvim
    automatic_installation = {
      exclude = skip_servers, -- Exclude TypeScript servers from automatic installation
    },
    handlers = {
      -- Default handler for all servers
      function(server_name)
        -- Skip servers in the skip list
        for _, skip_server in ipairs(skip_servers) do
          if server_name == skip_server then
            return
          end
        end

        -- Use new vim.lsp.config API
        -- Get server config from lspconfig for cmd and filetypes
        local ok, lspconfig = pcall(require, "lspconfig")
        if ok and lspconfig[server_name] then
          local config = lspconfig[server_name].document_config.default_config
          vim.lsp.config[server_name] = vim.tbl_extend("force", {
            cmd = config.cmd,
            filetypes = config.filetypes,
            root_markers = config.root_dir and { ".git" } or nil,
          }, {
            on_attach = custom_attach,
            capabilities = capabilities,
          })
          -- Enable the server for configured filetypes
          if config.filetypes then
            vim.lsp.enable(server_name)
          end
        end
      end,
      -- Explicitly disable ts_ls to avoid conflict with typescript-tools.nvim
      ["ts_ls"] = function() end,
      ["tsserver"] = function() end,
    },
  })

  -- TypeScript setup is now handled in lua/plugins/lsp.lua with lazy loading
  -- (FileType autocmd 已在函数开头设置)

  -- C++ method implementation is covered by clangd code actions
  -- (implement function / generate declaration); nvim-treesitter-cpp-tools
  -- was removed with nvim-treesitter (archived, incompatible with 0.12).

  -- python lsp
  if vim.fn.executable("basedpyright-langserver") == 1 then
    vim.lsp.config.basedpyright = {
      cmd = { "basedpyright-langserver", "--stdio" },
      filetypes = { "python" },
      on_attach = custom_attach,
      capabilities = capabilities,
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
    }
    vim.lsp.enable("basedpyright")
  end
end

-- Export custom_attach function for use by other modules
function M.get_custom_attach()
  return custom_attach
end

return M
