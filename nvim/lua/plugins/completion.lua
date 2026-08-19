return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    keys = {
      { "<C-Tab>", function() require('cmp').mapping.complete() end, mode = "i", desc = "Complete" },
    },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require'cmp'
      local luasnip = require'luasnip'

      local cmp_select_next = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end

      local cmp_select_prev = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end

      cmp.setup({
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s", "c" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s", "c" }),

          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expandable() then
                luasnip.expand()
              else
                cmp.confirm({
                  select = true,
                })
              end
            else
              fallback()
            end
          end, { "i", "s", "c" }),

          ["<C-n>"] = cmp.mapping(cmp_select_next, { "i", "s", "c" }),
          ["<C-p>"] = cmp.mapping(cmp_select_prev, { "i", "s", "c" }),
          ['<C-g>'] = cmp.close,
          ['<C-y>'] = cmp.config.disable,
          ['<Esc>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.close()
              -- 关闭补全候选框后，如果在插入模式，则退出到 normal 模式
              if vim.fn.mode() == 'i' then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, true, true), 'n', true)
              end
            else
              -- 在命令行模式模拟 Ctrl-c 退出，其他模式正常 fallback
              if vim.fn.mode() == 'c' then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, true, true), 'n', true)
              else
                fallback()
              end
            end
          end, { "i", "s", "c" }),

        },

        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        })
      })

      -- Set configuration for specific filetype

      -- Use buffer source for `/`
      cmp.setup.cmdline('/', {
        completion = {
          autocomplete = false, -- 禁用自动补全
        },
        mapping = {
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete({ config = { sources = { { name = 'buffer' } } } })
            end
          end, { "c" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "c" }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for `:`
      cmp.setup.cmdline(':', {
        completion = {
          autocomplete = false, -- 禁用自动补全
        },
        mapping = {
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete({ config = { sources = { { name = 'path' }, { name = 'cmdline' } } } })
            end
          end, { "c" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "c" }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = true,
  },
  {
    "hrsh7th/cmp-path",
    lazy = true,
  },
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    lazy = true,
  },
}