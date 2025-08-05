local M = {}

function M.setup()
  require("trouble").setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    mode = "workspace", -- "workspace" or "document"
    auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
    action_keys = { -- key mappings for actions in the trouble list
      -- map to {} to remove a mapping, for example:
      -- close = {},
      close = "q", -- close the list
      cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / tab
      refresh = "r", -- manually refresh
      jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
      open_in_browser = "gx", -- open the diagnostic in your browser
      copy_to_clipboard = "<C-c>", -- copy the diagnostic to your clipboard
      toggle_preview = "P", -- toggle auto_preview
      hover = "K", -- opens a small popup with the full multiline message
      preview = "p", -- preview the diagnostic location
      close_folds = {"zM", "zm"}, -- close all folds
      open_folds = {"zR", "zr"}, -- open all folds
      toggle_fold = {"zA", "za"}, -- toggle fold of current file
      previous = "k", -- previous item
      next = "j" -- next item and its severity and get a count of its occurences
    },
    include_declaration = false, -- include the declaration of the current symbol in the results
    cycle_results = true, -- cycle item list when reaching beginning or end of list
    auto_jump = {}, -- for modes that support auto jump to diagnostic
    signs = {
      -- icons / text used for a diagnostic
      error = " ",
      warning = " ",
      hint = " ",
      information = " ",
      other = " "
    },
    use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
  })
end

return M