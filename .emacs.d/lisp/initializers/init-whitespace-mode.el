
(global-whitespace-mode 1)
(setq whitespace-style '(face trailing tabs tab-mark))
(setq whitespace-line-column 85)
(setq whitespace-display-mappings '((tab-mark ?\t [?\x203a ?\t] [?\\ ?\t]) ; tab
                                     (newline-mark ?\n [?\x203a ?\n] [?\\ ?\n])))
(setq-default tab-width 4)


(add-hook 'before-save-hook #'delete-trailing-whitespace)

(set-face-attribute 'whitespace-tab nil
  :background (face-background 'default)
  :foreground whitespace-tab-fg-color)

(set-face-attribute 'whitespace-trailing nil
  :background whitespace-trailing-fg-color
  )



(provide 'init-whitespace-mode)
