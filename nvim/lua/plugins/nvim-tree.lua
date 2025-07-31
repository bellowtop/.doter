local M = {}

function M.setup()
  local function nvim_tree_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    
    vim.keymap.set('n', '<C-]>',   api.tree.change_root_to_node,        opts('CD'))
    vim.keymap.set('n', '<CR>',    api.node.open.edit,                  opts('Open'))
    vim.keymap.set('n', '<C-v>',   api.node.open.vertical,              opts('Open: Vertical Split'))
    vim.keymap.set('n', '<C-x>',   api.node.open.horizontal,            opts('Open: Horizontal Split'))
    vim.keymap.set('n', '<Tab>',   api.node.open.preview,               opts('Open Preview'))
    vim.keymap.set('n', 'a',       api.fs.create,                       opts('Create File Or Directory'))
    vim.keymap.set('n', 'd',       api.fs.remove,                       opts('Delete'))
    vim.keymap.set('n', 'D',       api.fs.trash,                        opts('Trash'))
    vim.keymap.set('n', 'o',       api.node.open.edit,                  opts('Open'))
    vim.keymap.set('n', 'p',       api.fs.paste,                        opts('Paste'))
    vim.keymap.set('n', 'P',       api.node.navigate.parent,            opts('Parent Directory'))
    vim.keymap.set('n', 'q',       api.tree.close,                      opts('Close'))
    vim.keymap.set('n', 'r',       api.fs.rename,                       opts('Rename'))
    vim.keymap.set('n', 'g',       api.tree.reload,                     opts('Refresh'))
    vim.keymap.set('n', 'x',       api.fs.cut,                          opts('Cut'))
    vim.keymap.set('n', 'y',       api.fs.copy.filename,                opts('Copy Name'))
    vim.keymap.set('n', 'Y',       api.fs.copy.relative_path,           opts('Copy Relative Path'))
  end

  require'nvim-tree'.setup {
    renderer = {
      group_empty = true,
      indent_markers = {
        enable = true,
        icons = {
          corner = "└─",
          item = "├─",
          edge = "│ ",
          none = "  ",
        },
      }
    },
    on_attach = nvim_tree_on_attach,
  }
end

return M