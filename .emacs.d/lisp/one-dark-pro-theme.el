
;; If you are distributing this theme, please replace this comment
;; with the appropriate license attributing the original VS Code
;; theme author.

(deftheme one-dark-pro "A nice dark theme.")


(let (
(color0 "#282c34")
(color1 "#abb2bf")
(color2 "#3c4048")
(color3 "#528bff")
(color4 "#555961")
(color5 "#41454d")
(color6 "#35393f")
(color7 "#b1b9c8")
(color8 "#494d53")
(color9 "#c5cddc")
(color10 "#dcdcdc")
(color11 "#73777f")
(color12 "#56b6c2")
(color13 "#d19a66")
(color14 "#61afef")
(color15 "#c678dd")
(color16 "#98c379")
(color17 "#e5c07b")
(color18 "#e06c75")
(color19 "#495162")
(color20 "#373b43")
(color21 "#bac1ce")
(color22 "#33373f")
(color23 "#b6bdca")
(color24 "#7f848e")
)


(custom-theme-set-faces
'one-dark-pro




;; BASIC FACES
`(default ((t (:background ,color0 :foreground ,color1 ))))
`(hl-line ((t (:background ,color2 ))))
`(cursor ((t (:foreground ,color3 ))))
`(region ((t (:background ,color4 ))))
`(secondary-selection ((t (:background ,color5 ))))
`(fringe ((t (:background ,color0 ))))
`(mode-line-inactive ((t (:background ,color6 :foreground ,color7 ))))
`(mode-line ((t (:background ,color8 :foreground ,color9 ))))
`(minibuffer-prompt ((t (:background ,color0 :foreground ,color10 ))))
`(vertical-border ((t (:foreground ,color11 ))))


;; FONT LOCK FACES
`(font-lock-builtin-face ((t (:foreground ,color12 ))))
`(font-lock-comment-face ((t (:foreground ,color24 ))))
`(font-lock-constant-face ((t (:foreground ,color13 ))))
`(font-lock-function-name-face ((t (:foreground ,color14 ))))
`(font-lock-keyword-face ((t (:foreground ,color15 ))))
`(font-lock-string-face ((t (:foreground ,color16 ))))
`(font-lock-type-face ((t (:foreground ,color17 ))))
`(font-lock-variable-name-face ((t (:foreground ,color18 ))))


`(helm-selection ((t (:foreground "white" :background "purple"))))
`(helm-source-header ((t (:foreground "black" :background "green"))))


;; linum-mode
`(linum ((t (:foreground ,color19 ))))
`(linum-relative-current-face ((t (:foreground ,color19 ))))


;; display-line-number-mode
`(line-number ((t (:foreground ,color19 ))))
`(line-number-current-line ((t (:foreground ,color19 ))))


;; THIRD PARTY PACKAGE FACES


;; doom-modeline-mode
`(doom-modeline-bar ((t (:background ,color8 :foreground ,color9 ))))
`(doom-modeline-inactive-bar ((t (:background ,color6 :foreground ,color7 ))))


;; web-mode
`(web-mode-string-face ((t (:foreground ,color16 ))))
`(web-mode-html-tag-face ((t (:foreground ,color15 ))))
`(web-mode-html-tag-bracket-face ((t (:foreground ,color15 ))))
`(web-mode-html-attr-name-face ((t (:foreground ,color17 ))))


;; company-mode
`(company-tooltip ((t (:background ,color20 :foreground ,color21 ))))


;; org-mode
`(org-block ((t (:background ,color22 :foreground ,color23 ))))))


(custom-theme-set-variables
  'one-dark-pro
  '(linum-format " %3i "))


;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))


;;;###autoload
(defun one-dark-pro-theme()
  "Apply the one-dark-pro-theme."
  (interactive)
  (load-theme 'one-dark-pro t))


(provide-theme 'one-dark-pro)


;; Local Variables:
;; no-byte-compile: t
;; End:


;; Generated using https://github.com/nice/themeforge
;; Feel free to remove the above URL and this line.
