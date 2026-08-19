return {
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Highlight groups for the custom buffer-tab component:
      -- active tab uses lualine's section-a color (vscode blue), matching the
      -- look of lualine's built-in buffers component.
      vim.api.nvim_set_hl(0, "BufTabActive", { link = "lualine_a_normal" })
      vim.api.nvim_set_hl(0, "BufTabInactive", { link = "TabLine" })

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
        -- Top buffer tabs (replaces lightline-bufferline).
        -- Custom component: lualine's "buffers" component has no filtering and
        -- falls back to rendering the current buffer even when unlisted, so
        -- special buffers (nvim-tree, telescope, terminal, ...) would show up
        -- while focused. This one only renders listed file buffers.
        tabline = {
          lualine_a = {
            {
              function()
                local parts = {}
                local cur = vim.api.nvim_get_current_buf()
                for _, b in ipairs(vim.api.nvim_list_bufs()) do
                  if
                    vim.api.nvim_buf_is_valid(b)
                    and vim.fn.buflisted(b) == 1
                    and vim.bo[b].buftype == ""
                  then
                    local name = vim.fn.bufname(b)
                    if name ~= "" then
                      name = vim.fn.fnamemodify(name, ":t")
                      local mod = vim.bo[b].modified and "*" or ""
                      local hl = b == cur and "BufTabActive" or "BufTabInactive"
                      -- %N@LualineSwitchBuffer@ = clickable tab (lualine's global helper)
                      parts[#parts + 1] = string.format(
                        "%%#%s#%%%d@LualineSwitchBuffer@ %s%s %%T%%*",
                        hl, b, name, mod
                      )
                    end
                  end
                end
                return table.concat(parts, " ")
              end,
              "buffer-tabs",
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
