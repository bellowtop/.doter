(global-whitespace-mode 1)
(setq whitespace-style '(face trailing tabs tab-mark))
(setq whitespace-line-column 85)
(setq whitespace-display-mappings '((tab-mark ?\t [?\x2023 ?\t] [?\\ ?\t]) ; tab
                                     (newline-mark ?\n [?\x203a ?\n] [?\\ ?\n])))
;; (setq whitespace-display-mappings '((tab-mark ?\t [?\x203a ?\t] [?\\ ?\t]) ; tab
;;                                      (newline-mark ?\n [?\x203a ?\n] [?\\ ?\n])))
(setq-default tab-width 4)

(add-hook 'prog-mode-hook #'(lambda()
                              (add-hook 'before-save-hook #'delete-trailing-whitespace)))

(provide 'init-whitespace-mode)
