local wezterm = require "wezterm"

local cfg = {}

cfg.disable_default_key_bindings = true

cfg.keys = {

  -- Tabs
  -- {mods = "SUPER",   key = "n", action = wezterm.action{SpawnTab="DefaultDomain"}},
  -- {mods = "SUPER",   key = "l", action = wezterm.action{ActivateTabRelative=1}},
  -- {mods = "SUPER",   key = "h", action = wezterm.action{ActivateTabRelative=-1}},
  -- {mods = "SUPER",   key = "w", action = wezterm.action{CloseCurrentTab={confirm=true}}}, -- Ctrl-Shift-w

  -- Wezterm features
  { mods = 'SUPER',             key = 'q',  action = wezterm.action.QuitApplication },
  { mods = 'SUPER',             key = 'n',  action = wezterm.action.SpawnWindow },

  { mods = 'SUPER|SHIFT',       key = 't',  action = wezterm.action.SpawnTab 'CurrentPaneDomain', },

  { mods = "SUPER|SHIFT",       key = "{",  action = wezterm.action.ActivateTabRelative(-1)    }, -- cmd+shift+[  prev tab
  { mods = "SUPER|SHIFT",       key = "}",  action = wezterm.action.ActivateTabRelative(1)     }, -- cmd+shift+]  next tab

  { mods = "SUPER",             key = "k",  action = wezterm.action{ClearScrollback = "ScrollbackAndViewport"}},
  { mods = "SUPER",             key = "f",  action = wezterm.action{Search = {CaseInSensitiveString = ""}}},

  { mods = "SUPER",             key = "c",  action = wezterm.action{CopyTo = "Clipboard"}},
  { mods = "SUPER",             key = "v",  action = wezterm.action{PasteFrom = "Clipboard"}},

  { mods = "SUPER|SHIFT",       key = "j",  action = wezterm.action.SendString '\x13\x0a'     }, -- cmd+shift+j  next session,  send C-s C-j
  { mods = "SUPER|SHIFT",       key = "k",  action = wezterm.action.SendString '\x13\x0b'     }, -- cmd+shift+k  next session,  send C-s C-k

  { mods = "SUPER",             key = "h",  action = wezterm.action.SendString '\x13\x68'     }, -- cmd+h        next window,   send C-s h
  { mods = "SUPER",             key = "l",  action = wezterm.action.SendString '\x13\x6c'     }, -- cmd+l        next window,   send C-s l

  { mods = "SUPER",             key = "t",  action = wezterm.action.SendString '\x13\x6e'     }, -- cmd+t  new window,          send C-s c
  { mods = "SUPER",             key = "w",  action = wezterm.action.SendString '\x13\x78'     }, -- cmd+d  kill pane,           send C-s X
  { mods = "SUPER",             key = "r",  action = wezterm.action.SendString '\x13\x5b'     }, -- cmd+r  selection mode,      send C-s [
  { mods = "SUPER",             key = "m",  action = wezterm.action.SendString '\x13\x6d'     }, -- cmd+m  toggle mouse,        send C-s m


  { mods = 'SUPER',             key = '=',  action = wezterm.action.IncreaseFontSize },
  { mods = 'SUPER',             key = '-',  action = wezterm.action.DecreaseFontSize },

  { mods = "CTRL",              key = "X",  action = "ShowLauncher"},
  { mods = "CTRL",              key = "q",  action = wezterm.action.SendString '\x11'         }, -- ctrl-q      send ctrl-q

  -- {mods = "CTRL", key = "0", action = "ResetFontSize"}, -- Ctrl-Shift-0
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
