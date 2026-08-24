return {
  -- Fast fold
  {
    "Konfekt/FastFold",
    event = "BufReadPost",
  },
  {
    "tmhedberg/SimpylFold",
    ft = "python",
  },

  -- Auto pairs - Modern Neovim-compatible version
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true, -- Enable treesitter integration
        ts_config = {
          lua = {'string'},-- it will not add a pair on that treesitter node
          javascript = {'template_string'},
          java = false,-- don't check treesitter on java
        },
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%'%"%)%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey='Comment'
        },
      })

      -- Integration with nvim-cmp
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },

  -- Easy motion (original plugin; f = bidirectional word jump, as before)
  {
    "easymotion/vim-easymotion",
    keys = {
      { "f", "<Plug>(easymotion-bd-w)", mode = "n", desc = "EasyMotion word" },
      "<leader><leader>",
    },
  },

  -- Jump (flash kept for treesitter jumps only; char mode disabled so it
  -- does not take over f/F/t/T)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "gs", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
    config = function()
      require("flash").setup({
        modes = {
          char = { enabled = false },
        },
      })
    end,
  },

  -- Multiple cursors (replaces vim-multiple-cursors; C-n muscle memory kept)
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add next occurrence of the word/selection (old multi_cursor_* keys)
      set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "MultiCursor: add next match" })
      set({ "n", "x" }, "<C-x>", function() mc.matchSkipCursor(1) end, { desc = "MultiCursor: skip next match" })

      -- Only active while multiple cursors exist, so <Esc> still exits Visual
      mc.addKeymapLayer(function(layerSet)
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },

  -- Surround (replaces vim-surround; keys kept for muscle memory)
  {
    "echasnovski/mini.surround",
    version = "*",
    event = "VeryLazy",
    keys = {
      { "ys", desc = "Add Surrounding", mode = "n" },
      { "ds", desc = "Delete Surrounding", mode = "n" },
      { "cs", desc = "Replace Surrounding", mode = "n" },
    },
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "ys", -- gsa
          delete = "ds", -- gsd
          replace = "cs", -- gsr
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          update_n_lines = "gsn",
          suffix_last = "l",
          suffix_next = "n",
        },
      })
      -- Keep vim-surround's visual-mode key for muscle memory.
      -- String form with <C-u>: add() must run after leaving Visual mode
      -- (marks '< '>' persist), same pattern as vim-surround's own vnoremap.
      vim.keymap.set("x", "S", [[:<C-u>lua require('mini.surround').add('visual')<CR>]],
        { noremap = true, silent = true, desc = "Add Surrounding" })
    end,
  },

  -- Repeat
  {
    "tpope/vim-repeat",
    keys = ".",
  },

  -- Buffer management
  {
    "schickling/vim-bufonly",
    cmd = "BufOnly",
  },
  {
    "rbgrouleff/bclose.vim",
    cmd = "Bclose",
  },
}
