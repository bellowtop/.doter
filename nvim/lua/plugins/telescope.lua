local M = {}

function M.setup()
  local telescope_actions = require("telescope.actions")
  local telescope_config = require("telescope.config")
  local telescope_state = require("telescope.state")
  local ts_action_set = require("telescope.actions.set")

  require('telescope').setup{
    defaults = {
      scroll_strategy = "limit",
      mappings = {
        i = {
          ["<C-g>"] = telescope_actions.close,
          ["<C-c>"] = telescope_actions.close,

          ["<M-BS>"] = function() vim.api.nvim_input "<c-s-w>" end,
          ["<C-d>"]  = function() vim.api.nvim_input "<C-o>x" end,
          ["<C-e>" ] = function() vim.api.nvim_input "<C-o>$" end,
          ["<C-a>" ] = function() vim.api.nvim_input "<C-o>^" end,
          ["<C-b>" ] = function() vim.api.nvim_input "<Left>" end,
          ["<C-f>" ] = function() vim.api.nvim_input "<Right>" end,
          ["<C-k>" ] = function() vim.api.nvim_input "<C-o>D" end,
          ["<M-k>" ] = function() vim.api.nvim_input "<C-o>d0" end,
          ["<C-t>" ] = function() vim.api.nvim_input "<C-o>O" end,
        },
        n = {
          ["<C-g>"] = telescope_actions.close,
          ["<C-c>"] = telescope_actions.close,
          ["<M-BS>"] = function() vim.api.nvim_input "a<c-s-w>" end,
          [";"] = function(prompt_bufnr)
            local results_win = telescope_state.get_status(prompt_bufnr).results_win
            local height = vim.api.nvim_win_get_height(results_win)
            ts_action_set.shift_selection(prompt_bufnr, math.floor(height/2))
          end,
          ["'"] = function(prompt_bufnr)
            local results_win = telescope_state.get_status(prompt_bufnr).results_win
            local height = vim.api.nvim_win_get_height(results_win)
            ts_action_set.shift_selection(prompt_bufnr, -math.floor(height/2))
          end,
        },
      }
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      }
    }
  }

  require("telescope").load_extension("file_browser")
  require("telescope").load_extension("recent_files")
  require('telescope').load_extension('fzf')

  require("dir-telescope").setup()
  require("telescope").load_extension("dir")



  -- indent-blankline.nvim
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
  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)

  require("ibl").setup { indent = {
      highlight = highlight,
      char = "┊",
      -- char = "▏",
  } }



end

return M
