-- Apply colorscheme
vim.cmd('colorscheme vscode')

-- Custom highlight settings
vim.cmd([[
  function! MyHighlights() abort
      " for term
      hi Normal                                               ctermfg=white       ctermbg=234
      hi NonText                                              ctermfg=59          ctermbg=234
      hi EndOfBuffer                                          ctermfg=234         ctermbg=234
      hi LineNr                                               ctermfg=59          ctermbg=234
      hi Search                       cterm=reverse           ctermfg=214         ctermbg=232
      hi SpellCap                                             ctermfg=black       ctermbg=green

      hi SignColumn                                           ctermfg=white       ctermbg=234
      hi WinSeparator                                         ctermfg=237         ctermbg=NONE
      hi CursorLine                                           cterm=NONE          ctermbg=NONE
      hi multiple_cursors_cursor                              ctermfg=green       ctermbg=red
      hi multiple_cursors_visual                              ctermfg=black       ctermbg=white

      " NvimTree
      hi NvimTreeNormal                                       ctermfg=white       ctermbg=234
      hi NvimTreeEndOfBuffer                                  ctermfg=234         ctermbg=234

      " Tabline
      hi TabLine                                              ctermfg=white       ctermbg=234
      hi TabLineFill                                          ctermfg=white       ctermbg=234
      hi TabLineSel                                           ctermfg=white       ctermbg=237

      " BufferLine
      hi BufferLineFill                                       ctermfg=white       ctermbg=234
      hi BufferLineBackground                                 ctermfg=white       ctermbg=234
      hi BufferLineBuffer                                     ctermfg=white       ctermbg=234

      " for gui
      hi Normal                                                                   guibg=#181818
      hi NonText                                              guifg=#415367       guibg=#181818
      hi EndOfBuffer                                          guifg=#181818       guibg=#181818
      hi LineNr                                               guifg=#415367       guibg=#181818
      hi Search                       gui=reverse                guifg=goldenrod2         guibg=black
      hi SpellCap                                             guifg=black         guibg=springgreen

      hi SignColumn                                           guifg=white         guibg=#181818
      hi WinSeparator                                         guifg=#383b3e       guibg=NONE
      hi CursorLine                                           gui=NONE            guibg=NONE
      hi multiple_cursors_cursor                              guifg=springgreen   guibg=red
      hi multiple_cursors_visual                              guifg=black         guibg=white

      " NvimTree
      hi NvimTreeNormal                                       guifg=white         guibg=#181818
      hi NvimTreeEndOfBuffer                                  guifg=#181818       guibg=#181818

      " Tabline
      hi TabLine                                              guifg=white         guibg=#181818
      hi TabLineFill                                          guifg=white         guibg=#181818
      hi TabLineSel                                           guifg=white         guibg=#383b3e

      " BufferLine
      hi BufferLineFill                                       guifg=white         guibg=#181818
      hi BufferLineBackground                                 guifg=white         guibg=#181818
      hi BufferLineBuffer                                     guifg=white         guibg=#181818
  endfunction
]])

-- Call MyHighlights immediately after defining it
vim.cmd('call MyHighlights()')
