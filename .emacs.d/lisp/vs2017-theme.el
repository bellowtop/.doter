
;; If you are distributing this theme, please replace this comment
;; with the appropriate license attributing the original VS Code
;; theme author.

(deftheme vs2017 "A nice dark theme.")


(let (
(color0 "#171c22")
(color1 "#d4d4d4")
(color2 "#2b3036")
(color3 "#c4eb45")
(color4 "#214283")
(color5 "#3a3d41")
(color6 "#e8e8e8")
(color7 "#3f444a")
(color8 "#fcfcfc")
(color9 "#62676d")
(color10 "#C8C8C8")
(color11 "#6A9955")
(color12 "#569CD6")
(color13 "#CE9178")
(color14 "#4EC9B0")
(color15 "#2b91af")
(color16 "#262b31")
(color17 "#e3e3e3")
(color18 "#22272d")
(color19 "#dfdfdf"))


(custom-theme-set-faces
'vs2017


;; BASIC FACES
`(default ((t (:background ,color0 :foreground ,color1 ))))
`(hl-line ((t (:background ,color2 ))))
`(cursor ((t (:foreground ,color3 ))))
`(region ((t (:background ,color4 ))))
`(secondary-selection ((t (:background ,color5 ))))
`(fringe ((t (:background ,color0 ))))
`(mode-line-inactive ((t (:background ,color2 :foreground ,color6 ))))
`(mode-line ((t (:background ,color7 :foreground ,color8 ))))
`(vertical-border ((t (:foreground ,color9 ))))


;; FONT LOCK FACES
`(font-lock-builtin-face ((t (:foreground ,color10 ))))
`(font-lock-comment-face ((t (:foreground ,color11 ))))
`(font-lock-constant-face ((t (:foreground ,color12 ))))
`(font-lock-function-name-face ((t (:foreground ,color10 ))))
`(font-lock-keyword-face ((t (:foreground ,color12 ))))
`(font-lock-string-face ((t (:foreground ,color13 ))))
`(font-lock-type-face ((t (:foreground ,color14 ))))
`(font-lock-variable-name-face ((t (:foreground ,color10 ))))


;; linum-mode
`(linum ((t (:foreground ,color15 ))))
`(linum-relative-current-face ((t (:foreground ,color15 ))))


;; display-line-number-mode
`(line-number ((t (:foreground ,color15 ))))
`(line-number-current-line ((t (:foreground ,color15 ))))


;; THIRD PARTY PACKAGE FACES


;; doom-modeline-mode
`(doom-modeline-bar ((t (:background ,color7 :foreground ,color8 ))))
`(doom-modeline-inactive-bar ((t (:background ,color2 :foreground ,color6 ))))


;; web-mode
`(web-mode-string-face ((t (:foreground ,color13 ))))
`(web-mode-html-tag-face ((t (:foreground ,color12 ))))
`(web-mode-html-tag-bracket-face ((t (:foreground ,color12 ))))
`(web-mode-html-attr-name-face ((t (:foreground ,color14 ))))


;; company-mode
`(company-tooltip ((t (:background ,color16 :foreground ,color17 ))))


;; org-mode
`(org-block ((t (:background ,color18 :foreground ,color19 ))))
`(org-block-begin-line ((t (:foreground ,color11 ))))))


(custom-theme-set-variables
  'vs2017
  '(linum-format " %3i "))


;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))


;;;###autoload
(defun vs2017-theme()
  "Apply the vs2017-theme."
  (interactive)
  (load-theme 'vs2017 t))


(provide-theme 'vs2017)


;; Local Variables:
;; no-byte-compile: t
;; End:


;; Generated using https://github.com/nice/themeforge
;; Feel free to remove the above URL and this line.
