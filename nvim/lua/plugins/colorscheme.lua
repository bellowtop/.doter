return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    lazy = false,
    config = function()
      vim.cmd([[colorscheme vscode]])
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
  },
}
