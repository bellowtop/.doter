local M = {}

function M.setup()
  local kommentary_config = require('kommentary.config')
  kommentary_config.configure_language("c", { prefer_single_line_comments = true, })
  kommentary_config.configure_language("cpp", { prefer_single_line_comments = true, })
end

return M