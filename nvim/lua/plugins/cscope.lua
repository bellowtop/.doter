local M = {}

function M.setup()
  require('cscope_maps').setup({
    disable_maps = false,
    skip_input_prompt = false,
    prefix = "<leader>,",
    cscope = {
      db_file = "./.cscope.out",
      exec = "cscope",
      picker = "quickfix",
      skip_picker_for_single_result = false,
      db_build_cmd = {args = { "-bqkv" }},
      statusline_indicator = nil,
    }
  })
end

return M