local M = {}

---
--- :SetProxy http://localhost:9910

---  or
--- :SetEnv CLAUDE_API_KEY=your_key
--- :SetEnv DEBUG=1
--- :SetEnv MY_CUSTOM_VAR=value
---
---

function M.setup()

  -- 环境变量管理函数
  local function set_proxy(proxy_url)
      vim.env.HTTP_PROXY = proxy_url
      vim.env.HTTPS_PROXY = proxy_url
      print("Proxy set to: " .. proxy_url)
  end

  local function clear_proxy()
      vim.env.HTTP_PROXY = nil
      vim.env.HTTPS_PROXY = nil
      print("Proxy cleared")
  end

  local function show_proxy()
      local http_proxy = vim.env.HTTP_PROXY or "Not set"
      local https_proxy = vim.env.HTTPS_PROXY or "Not set"
      print("HTTP_PROXY: " .. http_proxy)
      print("HTTPS_PROXY: " .. https_proxy)
  end

  -- 通用环境变量设置函数
  local function set_env(var_name, value)
    vim.env[var_name] = value
    print(string.format("Set %s=%s", var_name, value))
  end

  -- 创建用户命令
  vim.api.nvim_create_user_command('SetProxy', function(opts)
      set_proxy(opts.args)
  end, { nargs = 1 })

  vim.api.nvim_create_user_command('ClearProxy', clear_proxy, {})
  vim.api.nvim_create_user_command('ShowProxy', show_proxy, {})

  vim.api.nvim_create_user_command('SetEnv', function(opts)
    local args = vim.split(opts.args, '=', { plain = true })
    if #args == 2 then
      set_env(args[1], args[2])
    else
      print("Usage: :SetEnv VAR_NAME=value")
    end
  end, {
    nargs = 1,
    desc = "Set environment variable (format: VAR=value)"
  })

  -- 默认的代理
  -- set_proxy('http://localhost:9910')

end

return M
