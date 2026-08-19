local M = {}

function M.setup()
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    print("Installing lazy.nvim...")
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
    print("Done.")
  end
  vim.opt.rtp:prepend(lazypath)

  -- Configure lazy.nvim
  require("lazy").setup("plugins", {
    defaults = {
      lazy = true, -- lazy-load plugins by default (specs declare their own triggers)
    },
    install = {
      missing = true, -- install missing plugins on startup
      colorscheme = { "vscode" }, -- try to load one of these colorschemes when starting an installation during startup
    },
    ui = {
      border = "rounded",
    },
    change_detection = {
      enabled = true,
      notify = false, -- get a notification when changes are found
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end

return M