local wezterm = require "wezterm"

local cfg = {}

-- Disable annoying default behaviors
cfg.adjust_window_size_when_changing_font_size = false
-- !! this one opens a separate win on first unknown glyph, stealing windows focus !!
cfg.warn_about_missing_glyphs = false

cfg.font_size = 15.5
cfg.line_height = 1.1

-- Makes FontAwesome's double-width glyphs display properly!
cfg.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"


cfg.font = wezterm.font_with_fallback{
    { family = "IBM Plex Mono", weight = "Regular" },
    { family = "DejavuSansMono Nerd Font" },
    { family = "Cascadia Mono PL", weight = "DemiLight" },
    { family = "冬青黑体简体中文", weight = "DemiLight" },
}

-- Enable various OpenType features
-- See https://docs.microsoft.com/en-us/typography/opentype/spec/featurelist
cfg.harfbuzz_features = {
  "zero", -- Use a slashed zero '0' (instead of dotted)
  "kern", -- (default) kerning (todo check what is really is)
  "liga", -- (default) ligatures
  "clig", -- (default) contextual ligatures
}

return cfg
