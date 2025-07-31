local M = {}

function M.setup()
  require('bqf').setup({
    func_map = {
      open = 'o',
      openc = '<CR>',
    },
  })
end

return M