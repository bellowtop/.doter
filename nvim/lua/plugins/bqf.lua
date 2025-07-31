local M = {}

function M.setup()
  require('bqf').setup({
    func_map = {
      open = 'o',
      openc = '<CR>',
    },
    preview = {
      winblend = 0,  -- Remove transparency from preview window
    },
  })
end

return M