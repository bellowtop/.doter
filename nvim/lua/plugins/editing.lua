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

  -- Jump (replaces easymotion)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
      { "F", mode = { "n", "x", "o" }, function() require("flash").jump({ search = { forward = false } }) end, desc = "Flash Jump Back" },
      { "gs", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
    config = function()
      require("flash").setup()
    end,
  },

  -- Surround (replaces vim-surround; keys kept for muscle memory)
  {
    "echasnovski/mini.surround",
    version = "*",
    keys = {
      { "ys", desc = "Add Surrounding", mode = "n" },
      { "ds", desc = "Delete Surrounding", mode = "n" },
      { "cs", desc = "Replace Surrounding", mode = "n" },
      { "S", desc = "Add Surrounding Visual", mode = "v" },
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
      -- Keep vim-surround's visual-mode key for muscle memory
      vim.keymap.set("v", "S", function()
        require("mini.surround").add()
      end, { desc = "Add Surrounding" })
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
