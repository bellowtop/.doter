(use-package format-all
  :commands format-all-mode
  :hook
  (prog-mode . format-all-mode)
  (prog-mode . format-all-ensure-formatter)
  ;;   :config
  ;;   (setq-default format-all-formatters
  ;;                 '(("C"     (astyle "--mode=c"))
  ;;                   ("Shell" (shfmt "-i" "4" "-ci"))))
  )



(provide 'init-format-all)
