local wezterm = require "wezterm"

local cfg = {}

-- Disable annoying default behaviors
cfg.adjust_window_size_when_changing_font_size = false
-- !! this one opens a separate win on first unknown glyph, stealing windows focus !!
cfg.warn_about_missing_glyphs = false

cfg.font_size = 11

-- Makes FontAwesome's double-width glyphs display properly!
cfg.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

-- default font config comes from fontconfig and manages to find a lot of fonts,
-- but to have a more all-included config I'll list everything myself.

local function font_with_fallback(font_family)
  -- family names, not file names
  return wezterm.font_with_fallback({
    font_family,
    "Droid Sans Mono", -- nice double-spaced symbols!
  })
end

cfg.font = font_with_fallback("DejaVuSansMono Nerd Font")

-- Enable various OpenType features
-- See https://docs.microsoft.com/en-us/typography/opentype/spec/featurelist
cfg.harfbuzz_features = {
  "zero", -- Use a slashed zero '0' (instead of dotted)
  "kern", -- (default) kerning (todo check what is really is)
  "liga", -- (default) ligatures
  "clig", -- (default) contextual ligatures
}

-- Correct color changed by antialiasing. The default is Subpixel.
-- With Subpixel, the rendered color is beige-ish and slightly darker.
-- (explanation: https://gitter.im/wezterm/Lobby?at=5fbc5fb129cc4d7348294eb6)
cfg.font_antialias = "Greyscale"

return cfg
