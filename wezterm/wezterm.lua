-- WezTerm configuration
---------------------------------------------------------------

local wezterm = require "wezterm"
local mytable = require "lib/mystdlib".mytable

-- Misc
------------------------------------------

local cfg_misc = {
  window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE",
  check_for_updates = false,

  -- default_cursor_style = 'SteadyBar',

  -- Avoid unexpected config breakage and unusable terminal
  automatically_reload_config = true,

  -- Make sure word selection stops on most punctuations.
  -- Note that dot (.) & slash (/) are allowed though for
  -- easy selection of paths.
  selection_word_boundary = " \t\n{}[]()\"'`,;:@",

  hide_tab_bar_if_only_one_tab = true,
  tab_max_width = 32,

  -- Do not hold on exit by default.
  -- Because the default 'CloseOnCleanExit' can be annoying when exiting with
  -- Ctrl-D and the last command exited with non-zero: the shell will exit
  -- with non-zero and the terminal would hang until the window is closed manually.
  exit_behavior = "Close",

  -- Pad window to avoid the content to be too close to the border,
  -- so it's easier to see and select.
  window_padding = {
    left = 3, right = 3,
    top = 3, bottom = 3,
  },

}

-- Colors & Appearance
------------------------------------------

local cfg_colors = {
  color_scheme = "Dracula",
  colors = {
    cursor_bg = '#ff0000',
    cursor_fg = '#000000',
    cursor_border = '#ff0000',
  }
}

-- Font
------------------------------------------
local cfg_fonts = require("cfg_fonts")

-- Key/Mouse bindings
------------------------------------------

-- Key bindings
local cfg_key_bindings = require("cfg_keys")

-- Mouse bindings
local cfg_mouse_bindings = require("cfg_mouse")

-- Merge configs and return!
------------------------------------------

local config = mytable.merge_all(
  cfg_misc,
  cfg_colors,
  cfg_fonts,
  -- cfg_mouse_bindings,
  cfg_key_bindings,
  {
        mouse_bindings = {
            {
                mods="NONE",
                event={Down={streak=1, button="Right" }},
                action=wezterm.action.SendString '\x13\x5b\x4d',
            },
        },
  },
  {} -- so the last table can have an ending comma for git diffs :)
)

return config
