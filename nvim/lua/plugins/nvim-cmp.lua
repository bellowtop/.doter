local M = {}

function M.setup()
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
        else
          fallback()
        end
      end, { "i", "s" }),
    },

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    })
  })

  -- Set configuration for specific filetype
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' },
    }, {
      { name = 'buffer' },
    })
  })

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
end

return M