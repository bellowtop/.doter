local wezterm = require "wezterm"

local cfg = {}

cfg.disable_default_key_bindings = true

  -- NOTE: For bindings with mod SHIFT and a letter, the `key` field (the letter)
  --       must be uppercase'd and the mods should NOT contain 'SHIFT'.
cfg.keys = {
  -- {mods = "SHIFT", key = "PageUp", action = wezterm.action{ScrollByPage = -1}},
  -- {mods = "SHIFT", key = "PageDown", action = wezterm.action{ScrollByPage = 1}},

  -- Wezterm features
  {mods = "SUPER",  key = "k", action = wezterm.action{ClearScrollback = "ScrollbackAndViewport"}}, -- Ctrl-Shift-l
  {mods = "SUPER",  key = "f", action = wezterm.action{Search = {CaseInSensitiveString = ""}}}, -- Ctrl-Shift-f

  -- Copy (to Clipboard) / Paste (from Clipboard or PrimarySelection)
  {mods = "SUPER",   key = "c", action = wezterm.action{CopyTo = "Clipboard"}}, -- Ctrl-Shift-c
  {mods = "SUPER",   key = "v", action = wezterm.action{PasteFrom = "Clipboard"}}, -- Ctrl-Shift-v
  {mods = "SHIFT",   key = "Insert", action = wezterm.action{PasteFrom = "PrimarySelection"}},

  -- Tabs
  {mods = "SUPER",   key = "n", action = wezterm.action{SpawnTab="DefaultDomain"}}, -- Ctrl-Shift-t
  {mods = "SUPER",   key = "l", action = wezterm.action{ActivateTabRelative=1}},
  {mods = "SUPER",   key = "h", action = wezterm.action{ActivateTabRelative=-1}},
  {mods = "SUPER",   key = "w", action = wezterm.action{CloseCurrentTab={confirm=true}}}, -- Ctrl-Shift-w

  {mods = "SUPER",   key = "r",  action = "ReloadConfiguration"},


  -- {mods = "CTRL", key = "X", action = "ShowLauncher"},

  -- Font size
  -- {mods = "CTRL", key = "0", action = "ResetFontSize"}, -- Ctrl-Shift-0
  -- {mods = "CTRL", key = "6", action = "DecreaseFontSize"}, -- Ctrl-Shift-- (key with -)
  -- {mods = "CTRL", key = "+", action = "IncreaseFontSize"}, -- Ctrl-Shift-+ (key with =)
}

wezterm.on("my-toggle-ligature", function(win, _pane)
  local overrides = win:get_config_overrides() or {}
  if not overrides.harfbuzz_features then
    -- If we haven't overriden it yet, then override with ligatures disabled
    overrides.harfbuzz_features =  {"calt=0", "clig=0", "liga=0"}
  else
    -- else we did already, and we should disable the override now
    overrides.harfbuzz_features = nil
  end
  win:set_config_overrides(overrides)
end)

local key_ev = {mods = "CTRL", key = "G", action = wezterm.action{EmitEvent="my-toggle-ligature"}} -- Ctrl-Shift-g
table.insert(cfg.keys, key_ev)

return cfg
