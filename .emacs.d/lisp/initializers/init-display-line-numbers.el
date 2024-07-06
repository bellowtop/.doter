(use-package display-line-numbers
  :defer t
  :config
  ;; line number fixed width
  (setq display-line-numbers-width-start 100)
  :hook
  (prog-mode . display-line-numbers-mode)
  (markdown-mode . display-line-numbers-mode)
  (nxml-mode . display-line-numbers-mode)
  (yaml-mode . display-line-numbers-mode)
  (conf-mode . display-line-numbers-mode)
  )



(provide 'init-display-line-numbers)
