local M = {}

function M.setup()
  -- indent-blankline.nvim rainbow colors
  local highlight = {
    "RainbowRed",
    "RainbowYellow", 
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }

  local hooks = require "ibl.hooks"
  -- Create the highlight groups with darker colors
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#B85450" })      -- Darker red
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#C19A56" })   -- Darker yellow
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#4A8BC2" })     -- Darker blue
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#A67C52" })   -- Darker orange
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#7A9F62" })    -- Darker green
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#A062B8" })   -- Darker violet
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#4A9BA5" })     -- Darker cyan
  end)

  require("ibl").setup { 
    indent = {
      highlight = highlight,
      char = "┊",
      -- char = "▏",
    } 
  }
end

return M