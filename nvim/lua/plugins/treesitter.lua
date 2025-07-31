local M = {}

function M.setup()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query" },
    highlight = {
      enable = true
    }
  }
end

return M