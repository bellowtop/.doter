
" If you are distributing this theme, please replace this comment
" with the appropriate license attributing the original VS Code
" theme author.


" Simple Dark - A nice dark theme

" ==========> Reset
set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'simple-dark'

" ==========> Highlight function
function! s:h(face, guibg, guifg, ctermbg, ctermfg, gui)
  let l:cmd="highlight " . a:face
  
  if a:guibg != ""
    let l:cmd = l:cmd . " guibg=" . a:guibg
  endif

  if a:guifg != ""
    let l:cmd = l:cmd . " guifg=" . a:guifg
  endif

  if a:ctermbg != ""
    let l:cmd = l:cmd . " ctermbg=" . a:ctermbg
  endif

  if a:ctermfg != ""
    let l:cmd = l:cmd . " ctermfg=" . a:ctermfg
  endif

  if a:gui != ""
    let l:cmd = l:cmd . " gui=" . a:gui
  endif

  exec l:cmd
endfun


" ==========> Colors dictionary

" GUI colors dictionary (hex)
let s:hex = {}
" Terminal colors dictionary (256)
let s:bit = {}

let s:hex.color0="#24272A"
let s:hex.color1="#dddddd"
let s:hex.color2="#444444"
let s:hex.color3="#2e3134"
let s:hex.color4="#56595c"
let s:hex.color5="#383b3e"
let s:hex.color6="#6a6d70"
let s:hex.color7="#343538"
let s:hex.color8="#4d4e51"
let s:hex.color9="#6f7275"
let s:hex.color10="#00d25f"
let s:hex.color11="#424548"
let s:hex.color12="#fbfbfb"
let s:hex.color13="#e7e7e7"
let s:hex.color14="#474a4d"
let s:hex.color15="#737373"
let s:hex.color16="#BD93F9"
let s:hex.color17="#00E673"
let s:hex.color18="#FF69B4"

let s:bit.color9="41"
let s:bit.color12="141"
let s:bit.color13="205"
let s:bit.color10="231"
let s:bit.color0="235"
let s:bit.color3="236"
let s:bit.color5="237"
let s:bit.color2="238"
let s:bit.color7="239"
let s:bit.color4="240"
let s:bit.color6="242"
let s:bit.color8="243"
let s:bit.color1="253"
let s:bit.color11="254"


" ==========> General highlights 
call s:h("Normal", s:hex.color0, s:hex.color1, s:bit.color0, s:bit.color1, "none")
call s:h("Visual", s:hex.color2, "", s:bit.color2, "", "none")
call s:h("ColorColumn", s:hex.color3, "", s:bit.color3, "", "none")
call s:h("LineNr", "", s:hex.color4, "", s:bit.color4, "none")
call s:h("CursorLine", s:hex.color5, "", s:bit.color5, "", "none")
call s:h("CursorLineNr", "", s:hex.color6, "", s:bit.color6, "none")
call s:h("CursorColumn", s:hex.color5, "", s:bit.color5, "", "none")
call s:h("StatusLineNC", s:hex.color7, "", s:bit.color5, "", "none")
call s:h("StatusLine", s:hex.color8, "", s:bit.color7, "", "none")
call s:h("VertSplit", "", s:hex.color9, "", s:bit.color8, "none")
call s:h("Folded", s:hex.color5, s:hex.color10, s:bit.color5, s:bit.color9, "none")
call s:h("Pmenu", s:hex.color11, s:hex.color12, s:bit.color2, s:bit.color10, "none")
call s:h("PmenuSel", s:hex.color3, s:hex.color13, s:bit.color3, s:bit.color11, "none")
call s:h("EndOfBuffer", s:hex.color0, s:hex.color14, s:bit.color0, s:bit.color7, "none")
call s:h("NonText", s:hex.color0, s:hex.color14, s:bit.color0, s:bit.color7, "none")


" ==========> Syntax highlights
call s:h("Comment", "", s:hex.color15, "", s:bit.color8, "none")
call s:h("Constant", "", s:hex.color16, "", s:bit.color12, "none")
call s:h("Special", "", s:hex.color16, "", s:bit.color12, "none")
call s:h("Identifier", "", s:hex.color1, "", s:bit.color1, "none")
call s:h("Function", "", s:hex.color17, "", s:bit.color9, "none")
call s:h("Statement", "", s:hex.color18, "", s:bit.color13, "none")
call s:h("PreProc", "", s:hex.color18, "", s:bit.color13, "none")
call s:h("Type", "", s:hex.color18, "", s:bit.color13, "none")
call s:h("Number", "", s:hex.color16, "", s:bit.color12, "none")

highlight link cStatement Statement
highlight link cSpecial Special


" Generated using https://github.com/nice/themeforge
" Feel free to remove the above URL and this line.
