(require 'autothemer)


(autothemer-deftheme
 bogster "A theme to set the mood for Halloween"

 ((((class color) (min-colors #xFFFFFF))) ;; We're only concerned with graphical Emacs

  ;; Define our color palette

  (bogster-base0        "#161c23")
  (bogster-base1        "#232d38")
  (bogster-base2        "#313f4e")
  (bogster-base3        "#415367")
  (bogster-base4        "#536984")
  (bogster-base5        "#627d9d")
  (bogster-base6        "#9ea4c2")
  (bogster-base7        "#b6b6c9")
  (bogster-base8        "#cbc7d0")
  (bogster-fg0          "#c6b8ad")
  (bogster-fg1          "#e5ded6")
  (bogster-red          "#d32c5d")
  (bogster-lred         "#dc597f")
  (bogster-orange       "#dc7759")
  (bogster-dyellow      "#A58023")
  (bogster-yellow       "#dcb659")
  (bogster-green        "#57a331")
  (bogster-lgreen       "#7fdc59")
  (bogster-dblue        "#1e758d")
  (bogster-blue         "#36b2d4")
  (bogster-lblue        "#59dcd8")
  (bogster-purp         "#b759dc")
  (bogster-pink         "#dc59c0")
  (bogster-teal         "#23a580")
  (bogster-lteal        "#59dcb7"))


 ;;;   ;; Customize faces
 ;;;   (
 ;;;    (default                              (:foreground bogster-fg0 :background bogster-base0))
 ;;;    (cursor                               (:background bogster-red))
 ;;;    (region                               (:background bogster-base0 :inverse-video 't))
 ;;;    (mode-line                            (:foreground bogster-fg1 :background bogster-base3))
 ;;;    (lazy-highlight                       (:foreground bogster-base0 :background bogster-fg1))
 ;;;    (highlight                            (:background bogster-base1))
 ;;;    (hl-line                              (:background bogster-base1))
 ;;;    (line-number                          (:foreground bogster-base5 :background bogster-base0))
 ;;;    (font-lock-keyword-face               (:foreground bogster-green))
 ;;;    (font-lock-constant-face              (:foreground bogster-green))
 ;;;    (font-lock-string-face                (:foreground bogster-teal))
 ;;;    (font-lock-constant-face              (:foreground bogster-lteal))
 ;;;    (font-lock-function-name-face         (:foreground bogster-blue))
 ;;;    (font-lock-variable-name-face         (:foreground bogster-yellow))
 ;;;    (font-lock-keyword-face               (:foreground bogster-yellow))
 ;;;    (font-lock-type-face                  (:foreground bogster-lred))
 ;;;    (font-lock-comment-face               (:foreground bogster-base5))
 ;;;    (font-lock-builtin-face               (:foreground bogster-green))
 ;;;   )

 ;; Customize faces
 (
  (default                              (:foreground bogster-fg1 :background bogster-base0))
  (cursor                               (:background bogster-red))
  (region                               (:background bogster-base0 :inverse-video 't))
  (mode-line                            (:foreground bogster-fg1 :background bogster-base3))
  (lazy-highlight                       (:foreground bogster-base0 :background bogster-fg1))
  (highlight                            (:background bogster-base1))
  (hl-line                              (:background bogster-base1))
  (line-number                          (:foreground bogster-base5 :background bogster-base0))
  (font-lock-comment-face               (:foreground bogster-base5))
  (font-lock-keyword-face               (:foreground bogster-lgreen))
  (font-lock-constant-face              (:foreground bogster-lgreen))
  (font-lock-string-face                (:foreground bogster-teal))
  (font-lock-constant-face              (:foreground bogster-lteal))
  (font-lock-function-name-face         (:foreground bogster-lblue))
  (font-lock-variable-name-face         (:foreground bogster-yellow))
  (font-lock-keyword-face               (:foreground bogster-yellow))
  (font-lock-type-face                  (:foreground bogster-lred))
  (font-lock-builtin-face               (:foreground bogster-lgreen))

  (helm-selection                       (:background "#364D2D"))
  (helm-source-header                   (:foreground "#00ff00"))

 )

)

(provide-theme 'bogster)
