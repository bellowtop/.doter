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
end

return M