
local col = {}

-- Bew colors
col.background = "#191919"
col.foreground = "#eeeeee"

col.cursor_bg = "#eeeeee"
col.cursor_fg = "#202020"
col.cursor_border = "#eeeeee" -- same as cursor_bg

col.ansi = {
  "#2F2F2F", -- black
  "#ff6565", -- red
  "#4CAF50", -- green
  "#eab93d", -- yellow
  "#5788FF", -- blue
  "#ce5c00", -- orange (magentas usually)
  "#89b6e2", -- cyan
  "#cccccc", -- white
}

col.brights = {
  "#555753", -- black
  "#ff6565", -- red
  "#4CAF50", -- green
  "#ffc123", -- yellow
  "#2C82F2", -- blue
  "#f57900", -- orange (magentas usually)
  "#89b6e2", -- cyan
  "#fafafa", -- white
}

col.tab_bar = {
        -- The color of the strip that goes along the top of the window
      background = "#0b0022",

      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = "#00ff00",
        -- The color of the text for the tab
        fg_color = "#000000",

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Normal",

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      }
}

return col
