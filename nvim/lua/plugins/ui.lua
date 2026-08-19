return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "vscode",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        -- Top buffer tabs (replaces lightline-bufferline)
        tabline = {
          lualine_a = {
            {
              "buffers",
              icons_enabled = false, -- no file-type icons
              symbols = {
                modified = "*", -- plain asterisk for modified buffers
                alternate_file = "", -- no alternate-buffer marker
                directory = "",
              },
            },
          },
        },
        extensions = { "fugitive", "nvim-tree" },
      })
    end,
  },

  -- Which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("which-key").setup({})
    end,
  },
}
