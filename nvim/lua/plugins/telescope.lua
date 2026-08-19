return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "smartpde/telescope-recent-files",
      "princejoogie/dir-telescope.nvim",
    },
    keys = {
      {
        "<leader>f",
        function()
          require('telescope.builtin').find_files {
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
            previewer = false
          }
        end,
        desc = "Find Files"
      },
      { "<leader>g", function() require('telescope.builtin').live_grep() end, desc = "Live Grep" },
      { "<leader>G", function() require('telescope.builtin').grep_string() end, desc = "Grep String" },
      { "<leader>b", function() require('telescope.builtin').buffers() end, desc = "Buffers" },
      { "<leader>ss", function() require('telescope.builtin').lsp_document_symbols({ default_text = "" }) end, desc = "LSP Symbols" },
      { "<leader>p", function() require("telescope").extensions.file_browser.file_browser() end, desc = "File Browser" },
      {
        "F",
        function()
          require('telescope.builtin').find_files {
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
            previewer = false
          }
        end,
        desc = "Find Files"
      },
      { "<leader>F", function() require("telescope").extensions.recent_files.pick() end, desc = "Recent Files" },
      { "<leader>df", function() require("telescope").extensions.dir.find_files() end, desc = "Find Files in Dir" },
      { "<leader>dg", function() require("telescope").extensions.dir.live_grep() end, desc = "Grep in Dir" },
    },
    config = function()
      local telescope_actions = require("telescope.actions")
      local telescope_config = require("telescope.config")
      local telescope_state = require("telescope.state")
      local ts_action_set = require("telescope.actions.set")

      require('telescope').setup{
        defaults = {
          scroll_strategy = "limit",
          -- Default action for all pickers
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

              -- Send results to quickfix list
              ["<C-q>"] = telescope_actions.send_to_qflist,
              -- Send results to location list
              ["<C-l>"] = telescope_actions.send_to_loclist,
              -- Send to quickfix and open trouble
              ["<M-CR>"] = function(prompt_bufnr)
                telescope_actions.send_to_qflist(prompt_bufnr)
                vim.schedule(function()
                  require('trouble').open('quickfix')
                end)
              end,
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

              -- Send results to quickfix list
              ["<C-q>"] = telescope_actions.send_to_qflist,
              -- Send results to location list
              ["<C-l>"] = telescope_actions.send_to_loclist,
              -- Send to quickfix and open trouble
              ["<M-CR>"] = function(prompt_bufnr)
                telescope_actions.send_to_qflist(prompt_bufnr)
                vim.schedule(function()
                  require('trouble').open('quickfix')
                end)
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
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = true,
  },
  {
    "smartpde/telescope-recent-files",
    lazy = true,
  },
  {
    "princejoogie/dir-telescope.nvim",
    lazy = true,
  },
}